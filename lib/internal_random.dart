import 'dart:math';

class _CustomRandom {
  Random _internal;
  _CustomRandom([int seed]) {
    _internal = Random(seed);
  }

  bool nextBool() => _internal.nextBool();

  double nextDouble() => _internal.nextDouble();

  int nextInt(int max) => _internal.nextInt(max);

  double nextNextGaussian;
  bool haveNextNextGaussian = false;

  double nextGaussian() {
    // See Knuth, ACP, Section 3.4.1 Algorithm C.
    if (haveNextNextGaussian) {
      haveNextNextGaussian = false;
      return nextNextGaussian;
    } else {
      double v1, v2, s;
      do {
        v1 = 2 * nextDouble() - 1; // between -1 and 1
        v2 = 2 * nextDouble() - 1; // between -1 and 1
        s = v1 * v1 + v2 * v2;
      } while (s >= 1 || s == 0);
      double multiplier = sqrt(-2 * log(s) / s);
      nextNextGaussian = v2 * multiplier;
      haveNextNextGaussian = true;
      return v1 * multiplier;
    }
  }

  void setSeed(int seed) {
    _internal = Random(seed);
  }
}

class InternalRandom {
  factory InternalRandom._() => null;
  _CustomRandom internalRandom;

  double _random(double low, double high) {
    if (low >= high) return low;
    double diff = high - low;
    double value = 0;
    // because of rounding error, can't just add low, otherwise it may hit high
    // https://github.com/processing/processing/issues/4551
    do {
      value = random(diff) + low;
    } while (value == high);
    return value;
  }

  double random(double high, [double highHigh]) {
    if (highHigh != null) {
      return _random(high, highHigh);
    }
    // avoid an infinite loop when 0 or NaN are passed in
    if (high == 0 || high != high) {
      return 0;
    }

    if (internalRandom == null) {
      internalRandom = _CustomRandom();
    }

    // for some reason (rounding error?) Math.random() * 3
    // can sometimes return '3' (once in ~30 million tries)
    // so a check was added to avoid the inclusion of 'howbig'
    double value = 0;
    do {
      value = internalRandom.nextDouble() * high;
    } while (value == high);
    return value;
  }

  /**
     * Returns a float from a random series of numbers having a mean of 0
     * and standard deviation of 1. Each time the <b>randomGaussian()</b>
     * function is called, it returns a number fitting a Gaussian, or
     * normal, distribution. There is theoretically no minimum or maximum
     * value that <b>randomGaussian()</b> might return. Rather, there is
     * just a very low probability that values far from the mean will be
     * returned; and a higher probability that numbers near the mean will
     * be returned.
     *
     * ( end auto-generated )
     * @webref math:random
     * @see PApplet#random(float,float)
     * @see PApplet#noise(float, float, float)
     */
  double randomGaussian() {
    if (internalRandom == null) {
      internalRandom = new _CustomRandom();
    }
    return internalRandom.nextGaussian();
  }

  void randomSeed(int seed) {
    if (internalRandom == null) {
      internalRandom = new _CustomRandom();
    }
    internalRandom.setSeed(seed);
  }
}
