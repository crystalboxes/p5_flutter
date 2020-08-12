import 'dart:math';
import 'dart:ui';

class PVector {
  double _dx, _dy, _dz;
  PVector(double dx, double dy, [double dz = 0]) {
    _dx = dx;
    _dy = dy;
    _dz = dz;
  }

  Offset toOffset() => Offset(_dx, _dy);

  double get x => _dx;
  double get y => _dy;
  double get z => _dz;

  static PVector fromAngle(angle, [double length = 1.0]) =>
      PVector(cos(angle) * length, sin(angle) * length);

  setMag(double n) {
    normalize().mult(n);
  }

  PVector normalize() {
    final len = this.mag();
    // here we multiply by the reciprocal instead of calling 'div()'
    // since div duplicates this zero check.
    if (len != 0) {
      mult(1 / len);
    }
    return this;
  }

  double mag() => toOffset().distance;

  PVector mult(dynamic x, [double y, double z]) {
    List<double> xyz = _getXYZ(x, y, z);
    this._dx *= xyz[0];
    this._dy *= xyz[1];
    this._dz *= xyz[2];
    return this;
  }

  List<double> _getXYZ(dynamic x, [double y, double z]) {
    if (x is List<num>) {
      return [
        x[0].toDouble(),
        x[1].toDouble(),
        x[2].toDouble(),
      ];
    } else if (x is PVector) {
      return [
        x._dx,
        x._dy,
        x._dz,
      ];
    } else if (x is double) {
      if (z == null && y == null) {
        y = x;
        z = x;
      } else if (y == null) {
        z = this._dz;
        y = x;
      }
      return [x, y, z];
    } else {
      return [-1, -1, -1];
    }
  }

  PVector set(dynamic x, [double y, double z]) {
    if (x is List<num>) {
      this._dx = x[0].toDouble();
      this._dy = x[1].toDouble();
      this._dz = x[2].toDouble();
    } else if (x is PVector) {
      this._dx = x._dx;
      this._dy = x._dy;
      this._dz = x._dz;
    } else if (x is double) {
      if (z == null && y == null) {
        y = x;
        z = x;
      } else if (y == null) {
        z = this._dz;
        y = x;
      }
      this._dx = x;
      this._dy = y;
      this._dz = z;
    }
    return this;
  }

  PVector add(dynamic x, [double y, double z]) {
    List<double> xyz = _getXYZ(x, y, z);
    this._dx += xyz[0];
    this._dy += xyz[1];
    this._dz += xyz[2];
    return this;
  }

  PVector copy() => PVector(_dx, _dy, _dz);
}
