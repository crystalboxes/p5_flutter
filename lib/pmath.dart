import 'dart:math' as math;

import 'dart:ui';

class PMath {
  factory PMath._() => null;
  num sin(num a) => math.sin(a);
  num cos(num a) => math.cos(a);
  num tan(num a) => math.tan(a);
  num atan(num a) => math.atan(a);
  num atan2(num a, num b) => math.atan2(a, b);
  num asin(num a) => math.asin(a);
  num acos(num a) => math.acos(a);

  num degrees(num radians) => radians * (180 / math.pi);
  num radians(num degrees) => degrees * (math.pi / 180);

  num abs(num a) => a.abs();
  num ceil(num x) => x.ceil();
  num constrain(num amt, num low, num high) => amt.clamp(low, high);
  num dist(num x1, num y1, num x2, num y2) =>
      (Offset(x2, y2) - Offset(x1, x2)).distance;
  num exp(num n) => math.exp(n);
  num floor(num n) => n.floor();
  num lerp(num start, num stop, num amt) => amt * (stop - start) + start;
  num log(num n) => math.log(n);
  num mag(num a, num b) => Offset(a, b).distance;
  num map(num value, num start1, num stop1, num start2, num stop2) =>
      start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
  num max(dynamic a, [num b, num c]) {
    if (a is List<num>) {
      return a.reduce(math.max);
    }
    if (b == null) {
      return 0;
    }
    if (c != null) {
      return [a as num, b, c].reduce(math.max);
    }
    return math.max(a, b);
  }
  num min(dynamic a, [num b, num c]) {
    if (a is List<num>) {
      return a.reduce(math.min);
    }
    if (b == null) {
      return 0;
    }
    if (c != null) {
      return [a as num, b, c].reduce(math.min);
    }
    return math.min(a, b);
  }
  num norm(num value, num start, num stop) => map(value, start, stop, 0, 1);
  num pow(num x, num exponent) => math.pow(x, exponent);
  num round(num n) => n is int ? n.round() : n.roundToDouble();
  num sq(num n) => n * n;
  num sqrt(num n) => math.sqrt(n);
}
