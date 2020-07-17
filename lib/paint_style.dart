import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:p5_flutter/pconstants.dart';

extension ClonePaint on Paint {
  Paint clone() {
    var p = Paint();
    p.blendMode = blendMode;
    p.color = color;
    p.colorFilter = colorFilter;
    p.filterQuality = filterQuality;
    p.imageFilter = imageFilter;
    p.invertColors = invertColors;
    p.isAntiAlias = isAntiAlias;
    p.maskFilter = maskFilter;
    p.shader = shader;
    p.strokeCap = strokeCap;
    p.strokeJoin = strokeJoin;
    p.strokeMiterLimit = strokeMiterLimit;
    p.strokeWidth = strokeWidth;
    p.style = style;
    return p;
  }
}

class PaintStyle {
  var useStroke = false;
  var useFill = false;

  var _fillPaint = Paint();
  var _strokePaint = Paint();

  var ellipseMode = CENTER;
  var rectMode = CORNER;
  var imageMode = CORNER;

  var textSize = 12;
  var textLeading = 14;
  var textAlign = TextAlign.left;
  var textMode = MODEL;

  Paint get fill => _fillPaint;
  Paint get stroke => _strokePaint;

  clone() {
    var cloned = PaintStyle();
    cloned.useFill = useFill;
    cloned.useStroke = useStroke;
    cloned._fillPaint = _fillPaint.clone();
    cloned._strokePaint = _strokePaint.clone();
    cloned.ellipseMode = ellipseMode;
    cloned.rectMode = rectMode;
    cloned.imageMode = imageMode;

    cloned.textSize = textSize;
    cloned.textLeading = textLeading;
    cloned.textAlign = textAlign;
    cloned.textMode = textMode;

    return cloned;
  }

  static makeDefault() {
    var paintStyle = PaintStyle();
    paintStyle.useFill = true;
    paintStyle.useStroke = true;
    paintStyle._fillPaint
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    paintStyle._strokePaint
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.miter
      ..strokeCap = StrokeCap.round;
    return paintStyle;
  }
}
