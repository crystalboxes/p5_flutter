import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:p5_flutter/pconstants.dart';

num map(num value, num start1, num stop1, num start2, num stop2) =>
    start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
num clamp(num val, num min, num max) => val > max ? max : val < min ? min : val;

class ColorMode {
  int mode = RGB;

  int amax = 255;
  int bmax = 255;
  int cmax = 255;
  int dmax = 255;

  Color make(int r, [int g, int b, int a]) {
    if (g != null && b == null) {
      return getColor(r, r, r, g);
    }
    if (g == null) {
      return getColor(r, r, r, 255);
    }
    if (a == null && b != null) {
      return getColor(r, g, b, 255);
    }
    return getColor(r, g, b, a);
  }

  Color getColor(int r, int g, int b, int a) {
    if (mode == HSB) {
      return HSVColor.fromAHSV(
        clamp(map(a.toDouble(), 0.0, dmax.toDouble(), 0.0, 1.0), 0.0, 1.0),
        clamp(map(r.toDouble(), 0.0, amax.toDouble(), 0.0, 360.0), 0.0, 360.0),
        clamp(map(g.toDouble(), 0.0, bmax.toDouble(), 0.0, 1.0), 0.0, 1.0),
        clamp(map(b.toDouble(), 0.0, cmax.toDouble(), 0.0, 1.0), 0.0, 1.0),
      ).toColor();
    } else {
      return Color.fromARGB(
        clamp(map(a, 0, dmax, 0, 255), 0, 255).toInt(),
        clamp(map(r, 0, amax, 0, 255), 0, 255).toInt(),
        clamp(map(g, 0, bmax, 0, 255), 0, 255).toInt(),
        clamp(map(b, 0, cmax, 0, 255), 0, 255).toInt(),
      );
    }
  }
}

class ColorFunctions {
  factory ColorFunctions._() => null;
  var _colorMode = ColorMode();

  colorMode(int mode, [int max, int max1, int max2, int max3]) {
    _colorMode.mode = mode;
    if (max != null) {
      _colorMode.amax = max;
      _colorMode.bmax = max1 == null ? max : max1;
      _colorMode.cmax = max2 == null ? max : max2;
      _colorMode.dmax = max3 == null ? max : max3;
    }
  }

  Color color(int r, [int g, int b, int a]) {
    return _colorMode.make(r, g, b, a);
  }

  int red(Color c) => c.red;
  int green(Color c) => c.green;
  int blue(Color c) => c.blue;

  double hue(Color c) => HSVColor.fromColor(c).hue;
  double saturation(Color c) => HSVColor.fromColor(c).saturation;
  double brightness(Color c) => HSVColor.fromColor(c).value;

  Color lerpColor(Color c1, Color c2, double amt) => Color.lerp(c1, c2, amt);
}
