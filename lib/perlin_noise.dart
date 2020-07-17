import 'dart:math';

import 'package:p5_flutter/pconstants.dart';

List<double> cosLUT;

makeCosLUT() {
  if (cosLUT != null) {
    return cosLUT;
  }
  cosLUT = List<double>(SINCOS_LENGTH);
  for (int i = 0; i < SINCOS_LENGTH; i++) {
    cosLUT[i] = cos(i * DEG_TO_RAD * SINCOS_PRECISION);
  }
  return cosLUT;
}

class PerlinNoise {
  factory PerlinNoise._() => null;
  
  List<double> perlin;
  List<double> _perlinCosTable;
  int _perlinTWOPI, _perlinPI;

  Random perlinRandom;
  int perlinOctaves = 4; // default to medium smooth
  double perlinAmpFalloff = 0.5; // 50% reduction/octave

  double _noiseFsc(double i) {
    // using bagel's cosine table instead
    return 0.5 *
        (1.0 - _perlinCosTable[(i * _perlinPI).toInt() % _perlinTWOPI]);
  }

  void noiseDetail(int lod) {
    if (lod > 0) perlinOctaves = lod;
  }

  void noiseSeed(int seed) {
    perlinRandom = Random(seed);
    // force table reset after changing the random number seed [0122]
    perlin = null;
  }

  double noise(double x, [double y = 0, double z = 0]) {
    if (perlin == null) {
      if (perlinRandom == null) {
        perlinRandom = Random();
      }

      perlin = List<double>(PERLIN_SIZE + 1);
      for (int i = 0; i < PERLIN_SIZE + 1; i++) {
        perlin[i] = perlinRandom.nextDouble(); //(double)Math.random();
      }
      // [toxi 031112]
      // noise broke due to recent change of cos table in PGraphics
      // this will take care of it
      _perlinCosTable = makeCosLUT();
      _perlinTWOPI = _perlinPI = SINCOS_LENGTH;
      _perlinPI >>= 1;
    }

    if (x < 0) x = -x;
    if (y < 0) y = -y;
    if (z < 0) z = -z;

    int xi = x.toInt(), yi = y.toInt(), zi = z.toInt();
    double xf = x - xi;
    double yf = y - yi;
    double zf = z - zi;
    double rxf, ryf;

    double r = 0;
    double ampl = 0.5;

    double n1, n2, n3;

    for (int i = 0; i < perlinOctaves; i++) {
      int of = xi + (yi << PERLIN_YWRAPB) + (zi << PERLIN_ZWRAPB);

      rxf = _noiseFsc(xf);
      ryf = _noiseFsc(yf);

      n1 = perlin[of & PERLIN_SIZE];
      n1 += rxf * (perlin[(of + 1) & PERLIN_SIZE] - n1);
      n2 = perlin[(of + PERLIN_YWRAP) & PERLIN_SIZE];
      n2 += rxf * (perlin[(of + PERLIN_YWRAP + 1) & PERLIN_SIZE] - n2);
      n1 += ryf * (n2 - n1);

      of += PERLIN_ZWRAP;
      n2 = perlin[of & PERLIN_SIZE];
      n2 += rxf * (perlin[(of + 1) & PERLIN_SIZE] - n2);
      n3 = perlin[(of + PERLIN_YWRAP) & PERLIN_SIZE];
      n3 += rxf * (perlin[(of + PERLIN_YWRAP + 1) & PERLIN_SIZE] - n3);
      n2 += ryf * (n3 - n2);

      n1 += _noiseFsc(zf) * (n2 - n1);

      r += n1 * ampl;
      ampl *= perlinAmpFalloff;
      xi <<= 1;
      xf *= 2;
      yi <<= 1;
      yf *= 2;
      zi <<= 1;
      zf *= 2;

      if (xf >= 1.0) {
        xi++;
        xf--;
      }
      if (yf >= 1.0) {
        yi++;
        yf--;
      }
      if (zf >= 1.0) {
        zi++;
        zf--;
      }
    }
    return r;
  }
}
