import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:p5_flutter/pvector.dart';

import 'color_mode.dart';
import 'conversion.dart';
import 'perlin_noise.dart';
import 'text_output.dart';
import 'array_functions.dart';
import 'custom_canvas.dart';
import 'internal_random.dart';
import 'pconstants.dart';
import 'paint_style.dart';
import 'pmath.dart';
import 'time_date.dart';

// TODO parametrize these
const batchesToKeep = 2;
const drawCommandsPerBatch = 1000;

abstract class PApplet extends CustomPainter
    with
        material.ChangeNotifier,
        PMath,
        PerlinNoise,
        InternalRandom,
        TextOutput,
        ArrayFunctions,
        TimeDate,
        Conversion,
        ColorFunctions {
  var elapsed = Duration();
  var deltaTime = Duration();

  var mouseX = 0.0;
  var mouseY = 0.0;

  Size _size;

  double get width => _size.width;
  double get height => _size.height;

  var _styleStack = <PaintStyle>[
    PaintStyle.makeDefault(),
  ];

  var _initialized = false;

  CustomCanvas _canvas;
  Canvas _targetCanvas;

  var batches = <PictureData>[];
  PictureData _previousFrame;

  PApplet();

  var drawCalls = 0;

  int _frameCount = 0;
  double _frameRate = 0;
  int frameCount() => _frameCount;
  double frameRate() => _frameRate;

  bool clearOnBeginFrame(); //=> true;

  PVector createVector(double x, double y) => PVector(x, y);

  _getBlendMode(int mode) {
    switch (mode) {
      case DARKEST:
        return material.BlendMode.darken;
      case LIGHTEST:
        return material.BlendMode.lighten;
      case DIFFERENCE:
        return material.BlendMode.difference;
      case EXCLUSION:
        return material.BlendMode.exclusion;
      case MULTIPLY:
        return material.BlendMode.multiply;
      case SCREEN:
        return material.BlendMode.screen;
      case REPLACE:
        return material.BlendMode.dst;
      case HARD_LIGHT:
        return material.BlendMode.hardLight;
      case SOFT_LIGHT:
        return material.BlendMode.softLight;
      case OVERLAY:
        return material.BlendMode.overlay;
      case DODGE:
        return material.BlendMode.colorDodge;
      case BURN:
        return material.BlendMode.colorBurn;
      case SUBTRACT:
        return material.BlendMode.dstOut; // ?
      case ADD:
        return BlendMode.plus;
      case BLEND:
      default:
        return material.BlendMode.srcOver;
    }
  }

  blendMode(int mode) {
    paintStyle.fill.blendMode = _getBlendMode(mode);
    paintStyle.stroke.blendMode = _getBlendMode(mode);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _size = size;
    _targetCanvas = canvas;
    _targetCanvas.drawColor(color(200), BlendMode.color);

    var shouldClearOnBeginFrame = clearOnBeginFrame();
    if (!shouldClearOnBeginFrame) {
      _canvas = CustomCanvas(pictureRecorder: PictureRecorder());
      // draw previous frame to canvas
      batches.forEach((element) => element.drawToCanvas(_targetCanvas));

      if (_previousFrame != null) {
        _canvas.drawPictureData(_previousFrame);
      }
    } else {
      _canvas = CustomCanvas(fromOther: _targetCanvas);
    }

    if (!_initialized) {
      setup();
      _initialized = true;
    }
    draw();
    eventQueue.forEach((key, value) => value());
    eventQueue.clear();

    if (!shouldClearOnBeginFrame) {
      if (_previousFrame != null &&
          _previousFrame.drawCommands > drawCommandsPerBatch) {
        _previousFrame.toImage(size);
        batches.add(_previousFrame);
        _targetCanvas.drawPicture(_previousFrame.picture);

        if (batches.length == batchesToKeep) {
          // make multibatch
          // create canvas
          final _temp = CustomCanvas(pictureRecorder: PictureRecorder());
          batches
              .forEach((element) => element.drawToCanvas(_temp.internalCanvas));
          final pic = _temp.getPicture();
          pic.toImage(size);
          batches.clear();
          batches.add(pic);
        }
        _previousFrame = null;
      } else {
        _previousFrame = _canvas.getPicture();
        _targetCanvas.drawPicture(_previousFrame.picture);
      }
    }
    _showDebugInfo();

    _canvas = null;
    _firstFrameDrawn = true;
    _frameCount += 1;
    _frameRate = 1 / (deltaTime.inMilliseconds * 0.001);

    // _targetCanvas.restore();
  }

  imageMode(int mode) {
    paintStyle.imageMode = mode;
  }

  clip(double a, double b, double c, double d) {
    Rect rect;
    final mode = paintStyle.imageMode;
    if (mode == CENTER) {
      rect = Rect.fromCenter(center: Offset(a, b), width: c, height: d);
    } else if (mode == CORNERS) {
      rect = Rect.fromLTRB(a, b, c, d);
    } else {
      rect = Rect.fromLTWH(a, b, c, d);
    }
    _canvas.clipRect(rect);
  }

  noClip() {
    _canvas.clipRect(
        Rect.fromCircle(center: Offset(0, 0), radius: double.infinity));
  }

  clear() {
    _canvas.drawColor(Color(0), material.BlendMode.clear);
  }

  background(dynamic r, [int g, int b, int a]) {
    if (r is Image) {
      _canvas.drawImage(r, Offset(0, 0), Paint());
    } else {
      final c = color(r, g, b, a);
      _canvas.drawColor(c, BlendMode.src);
    }
  }

  _showDebugInfo() {
    // fps
    final fps = _frameRate;
    var drawCalls = 0;
    drawCalls = _canvas.drawCalls;
    TextSpan span = new TextSpan(
        style: new TextStyle(color: material.Colors.blue[800]), text: '''       
        elapsed: ${elapsed.toString()}
        fps: $fps
        mouseX: $mouseX
        mouseY: $mouseY

        batches: ${batches.length}

        drawCalls: $drawCalls
        ''');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(_targetCanvas, new Offset(5.0, 5.0));
  }

  @override
  bool shouldRepaint(PApplet oldDelegate) {
    return false;
  }

  @override
  bool shouldRebuildSemantics(PApplet oldDelegate) {
    return false;
  }

  var _isTicking = true;
  var _firstFrameDrawn = false;

  bool get isTicking => _isTicking;
  bool get firstFrameDrawn => _firstFrameDrawn;

  PaintStyle get paintStyle => _styleStack.last;

  // to override
  setup() {}
  draw() {}

  // callbacks
  mousePressed() {}
  mouseReleased() {}
  mouseDragged() {}
  mouseClicked() {}

  translate(double x, double y) {
    _canvas.translate(x, y);
  }

  applyMatrix(dynamic n00,
      [double n01,
      double n02,
      double n03,
      double n10,
      double n11,
      double n12,
      double n13,
      double n20,
      double n21,
      double n22,
      double n23,
      double n30,
      double n31,
      double n32,
      double n33]) {
    throw UnimplementedError();
  }

  popMatrix() {
    if (_canvas != null) {
      _canvas.restore();
    }
  }

  pushMatrix() {
    if (_canvas != null) {
      _canvas.save();
    }
  }

  push() {
    pushMatrix();
    pushStyle();
  }

  pop() {
    popMatrix();
    popStyle();
  }

  pushStyle() {
    _styleStack.add(_styleStack.last.clone());
  }

  popStyle() {
    if (_styleStack.length != 1) {
      _styleStack.removeLast();
    }
  }

  redraw() {
    notifyListeners();
  }

  setLocation(int x, int y) {}

  setResizable(bool resizable) {}

  setTitle(String title) {}

  thread() {}

  noLoop() {
    _isTicking = false;
  }

  loop() {
    _isTicking = true;
  }

  exit() {
    return UnimplementedError();
  }

  noFill() {
    paintStyle.useFill = false;
  }

  fill(dynamic r, [int g, int b, int a]) {
    Color color;
    if (r is Color) {
      color = r;
    } else {
      color = this.color(r, g, b, a);
    }

    paintStyle.useFill = true;
    paintStyle.fill.color = color;
  }

  smooth() {}
  noSmooth() {}

  noStroke() {
    paintStyle.useStroke = false;
  }

  stroke(dynamic r, [int g, int b, int a]) {
    Color color;
    if (r is Color && !(r is num)) {
      color = r;
    } else {
      color = this.color(r.toInt(), g, b, a);
    }
    paintStyle.useStroke = true;
    paintStyle.stroke.color = color;
  }

  strokeCap(int cap) {
    StrokeCap scap = cap == SQUARE ? StrokeCap.square : StrokeCap.round;
    scap = cap == PROJECT ? StrokeCap.butt : scap;
    paintStyle.stroke.strokeCap = scap;
  }

  strokeWeight(double weight) {
    paintStyle.stroke.strokeWidth = weight;
  }

  strokeJoin(int join) {
    StrokeJoin j = join == MITER ? StrokeJoin.miter : StrokeJoin.bevel;
    j = join == ROUND ? StrokeJoin.round : j;
    paintStyle.stroke.strokeJoin = j;
  }

  arc(double x, double y, double width, double height, double start,
      double stop,
      [int mode]) {
    final sweepAngle = stop - start;
    final ps = paintStyle;

    final rect =
        Rect.fromCenter(center: Offset(x, y), width: width, height: height);

    if (ps.useFill) {
      _canvas.drawArc(
          rect, start, sweepAngle, mode == null || mode == PIE, ps.fill);
    }
    if (ps.useStroke) {
      _canvas.drawArc(rect, start, sweepAngle, mode == PIE, ps.stroke);

      if (mode == CHORD) {
        final offsetA =
            Offset(x + cos(start) * width / 2.0, y + sin(start) * height / 2.0);
        final offsetB =
            Offset(x + cos(stop) * width / 2.0, y + sin(stop) * height / 2.0);

        _canvas.drawLine(offsetA, offsetB, ps.stroke);
      }
    }
  }

  circle(double x, double y, double extent) {
    final ps = paintStyle;
    if (ps.useFill) _canvas.drawCircle(Offset(x, y), extent, ps.fill);
    if (ps.useStroke) _canvas.drawCircle(Offset(x, y), extent, ps.stroke);
  }

  ellipseMode(int mode) {
    paintStyle.ellipseMode = mode;
  }

  ellipse(double a, double b, double c, [double d]) {
    final x = a;
    final y = b;
    final width = c;
    final height = d != null ? d : c;

    final ps = paintStyle;
    Rect rect;

    final emode = paintStyle.ellipseMode;

    if (emode == RADIUS) {
      rect = Rect.fromCenter(
          center: Offset(x, y), width: width * 2, height: height * 2);
    } else if (emode == CORNER) {
      rect = Rect.fromLTWH(x, y, width, height);
    } else if (emode == CORNERS) {
      rect = Rect.fromLTRB(x, y, width, height);
    } else {
      rect =
          Rect.fromCenter(center: Offset(x, y), width: width, height: height);
    }

    if (ps.useFill) _canvas.drawArc(rect, 0, TWO_PI, false, ps.fill);
    if (ps.useStroke) _canvas.drawArc(rect, 0, TWO_PI, false, ps.stroke);
  }

  line(num x1, num y1, num x2, num y2) {
    final ps = paintStyle;
    if (ps.useStroke) {
      _canvas.drawLine(Offset(x1.toDouble(), y1.toDouble()),
          Offset(x2.toDouble(), y2.toDouble()), ps.stroke);
    }
  }

  point(num x, num y, [num z]) {
    final ps = paintStyle;
    if (ps.useStroke)
      _canvas.drawPoints(
          PointMode.points, [Offset(x.toDouble(), y.toDouble())], ps.stroke);
  }

  quad(double x1, double y1, double x2, double y2, double x3, double y3,
      double x4, double y4) {
    Path p = Path();
    p.addPolygon([
      Offset(x1, y1),
      Offset(x2, y2),
      Offset(x3, y3),
      Offset(x4, y4),
    ], true);

    final ps = paintStyle;
    if (ps.useFill) _canvas.drawPath(p, ps.fill);
    if (ps.useStroke) _canvas.drawPath(p, ps.stroke);
  }

  bezier(double x1, double y1, double x2, double y2, double x3, double y3,
      double x4, double y4) {
    final ps = paintStyle;

    if (ps.useFill) {
      final p = Path();
      p.moveTo(x1, y1);
      p.cubicTo(x2, y2, x3, y3, x4, y4);
      p.close();
      _canvas.drawPath(p, ps.fill);
    }

    if (ps.useStroke) {
      final p = Path();
      p.moveTo(x1, y1);
      p.cubicTo(x2, y2, x3, y3, x4, y4);
      _canvas.drawPath(p, ps.stroke);
    }
  }

  bezierDetail(num detail) {
    // ignore
  }

  /// Evaluates the Bezier at point t for points a, b, c, d. The parameter t
  /// varies between 0 and 1, a and d are points on the curve, and b and c are
  /// the control points. This can be done once with the x coordinates and a
  /// second time with the y coordinates to get the location of a bezier curve
  /// at t.
  double bezierPoint(double a, double b, double c, double d, double t) {
    double t1 = 1.0 - t;
    return a * t1 * t1 * t1 +
        3 * b * t * t1 * t1 +
        3 * c * t * t * t1 +
        d * t * t * t;
  }

  /// Calculates the tangent of a point on a Bezier curve. There is a good
  /// definition of <a href="http://en.wikipedia.org/wiki/Tangent"
  /// target="new"><em>tangent</em> on Wikipedia</a>.
  double bezierTangent(double a, double b, double c, double d, double t) {
    return (3 * t * t * (-a + 3 * b - 3 * c + d) +
        6 * t * (a - 2 * b + c) +
        3 * (-a + b));
  }

  var _curveDetail = 20;
  var _curveTightness = 0.0;

  curveTightness(double tightness) {
    _curveTightness = tightness;
  }

  curveDetail(int detail) {
    detail = detail < 0 ? 1 : detail;
    _curveDetail = detail;
  }

  double curveTangent(double a, double b, double c, double d, double t) {
    final t2 = t * t,
        f1 = -3 * t2 / 2 + 2 * t - 0.5,
        f2 = 9 * t2 / 2 - 5 * t,
        f3 = -9 * t2 / 2 + 4 * t + 0.5,
        f4 = 3 * t2 / 2 - t;
    return a * f1 + b * f2 + c * f3 + d * f4;
  }

  curve(double x1, double y1, double x2, double y2, double x3, double y3,
      double x4, double y4) {
    final vertices = <Offset>[];
    final curveDetail = _curveDetail;
    for (var i = 0; i <= curveDetail; i++) {
      final c1 = pow(i / curveDetail, 3) * 0.5;
      final c2 = pow(i / curveDetail, 2) * 0.5;
      final c3 = i / curveDetail * 0.5;
      final c4 = 0.5;
      final vx = c1 * (-x1 + 3 * x2 - 3 * x3 + x4) +
          c2 * (2 * x1 - 5 * x2 + 4 * x3 - x4) +
          c3 * (-x1 + x3) +
          c4 * (2 * x2);
      final vy = c1 * (-y1 + 3 * y2 - 3 * y3 + y4) +
          c2 * (2 * y1 - 5 * y2 + 4 * y3 - y4) +
          c3 * (-y1 + y3) +
          c4 * (2 * y2);
      vertices.add(Offset(vx, vy));
    }
    var ps = paintStyle;
    if (ps.useFill) {
      final p = Path();
      p.addPolygon(vertices, true);
      _canvas.drawPath(p, ps.fill);
    }
    if (ps.useStroke) {
      _canvas.drawPoints(PointMode.polygon, vertices, ps.stroke);
    }
  }

  double curvePoint(double a, double b, double c, double d, double t) {
    final t3 = t * t * t,
        t2 = t * t,
        f1 = -0.5 * t3 + t2 - 0.5 * t,
        f2 = 1.5 * t3 - 2.5 * t2 + 1.0,
        f3 = -1.5 * t3 + 2.0 * t2 + 0.5 * t,
        f4 = 0.5 * t3 - 0.5 * t2;
    return a * f1 + b * f2 + c * f3 + d * f4;
  }

  rectMode(mode) {
    paintStyle.rectMode = mode;
  }

  rect(double a, double b, double c, double d,
      [double tl, double tr, double br, double bl]) {
    final x = a, y = b, width = c, height = d;

    if (tl != null && (tr == null)) {
      tr = tl;
      br = tl;
      bl = tl;
    }
    Rect rect;
    final rm = paintStyle.rectMode;

    if (rm == CENTER) {
      rect =
          Rect.fromCenter(center: Offset(x, y), width: width, height: height);
    } else if (rm == CORNERS) {
      rect = Rect.fromLTRB(a, b, c, d);
    } else if (rm == RADIUS) {
      rect = Rect.fromCenter(
          center: Offset(x, y), width: width * 2, height: height * 2);
    } else {
      // CORNER
      rect = Rect.fromLTWH(x, y, width, height);
    }

    final ps = paintStyle;
    if (tl == null) {
      if (ps.useFill) _canvas.drawRect(rect, ps.fill);
      if (ps.useStroke) _canvas.drawRect(rect, ps.stroke);
    } else {
      final rrect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(tl),
          bottomLeft: Radius.circular(bl),
          topRight: Radius.circular(tr),
          bottomRight: Radius.circular(br));
      if (ps.useFill) _canvas.drawRRect(rrect, ps.fill);
      if (ps.useStroke) _canvas.drawRRect(rrect, ps.stroke);
    }
  }

  square(double x, double y, double extent) {
    final rect = Rect.fromCircle(center: Offset(x, y), radius: extent);
    final ps = paintStyle;
    if (ps.useFill) _canvas.drawRect(rect, ps.fill);
    if (ps.useStroke) _canvas.drawRect(rect, ps.stroke);
  }

  triangle(double x1, double y1, double x2, double y2, double x3, double y3) {
    final ps = paintStyle;
    Path p = Path();
    p.addPolygon([
      Offset(x1, y1),
      Offset(x2, y2),
      Offset(x3, y3),
    ], true);

    if (ps.useFill) _canvas.drawPath(p, ps.fill);
    if (ps.useStroke) _canvas.drawPath(p, ps.stroke);
  }

  Path _currentShape;
  Path _currentContour;
  bool _isCatmullRomShape = false;
  bool _isCatmullRomContour = false;
  var _shapeVertices = <Offset>[];
  var _contourVertices = <Offset>[];

  bool _isContourActive = false;

  List<Offset> get _pathVertices =>
      _isContourActive ? _contourVertices : _shapeVertices;

  int _shapeKind;

  var _cutters = <Path>[];

  beginContour() {
    _isCatmullRomContour = false;
    _currentContour = Path();
    _contourVertices = [];
    _isContourActive = true;
  }

  Path resolveCurvePath(List<Offset> vertices) {
    if (vertices.length < 3) {
      return null;
    }

    var b = List<Offset>(4), s = 1 - _curveTightness;
    var newPath = Path();

    newPath.moveTo(vertices[1].dx, vertices[1].dy);
    for (var i = 1; i + 2 < vertices.length; i++) {
      var v = vertices[i];

      b[0] = Offset(v.dx, v.dy);
      b[1] = Offset(
          v.dx + (s * vertices[i + 1].dx - s * vertices[i - 1].dx) / 6,
          v.dy + (s * vertices[i + 1].dy - s * vertices[i - 1].dy) / 6);
      b[2] = Offset(
          vertices[i + 1].dx +
              (s * vertices[i].dx - s * vertices[i + 2].dx) / 6,
          vertices[i + 1].dy +
              (s * vertices[i].dy - s * vertices[i + 2].dy) / 6);
      b[3] = Offset(vertices[i + 1].dx, vertices[i + 1].dy);

      newPath.cubicTo(b[1].dx, b[1].dy, b[2].dx, b[2].dy, b[3].dx, b[3].dy);
    }
    return newPath;
  }

  endContour() {
    if (_currentContour == null) {
      return;
    }

    if (_isCatmullRomContour) {
      _currentContour = resolveCurvePath(_contourVertices);
    }

    if (_currentContour != null) {
      _currentContour.close();
      _cutters.add(_currentContour);
    }
    _isContourActive = false;
    _currentContour = null;
  }

  beginShape([int kind]) {
    _isCatmullRomShape = false;
    _shapeVertices = [];
    _shapeKind = kind;
    _currentShape = Path();
  }

  endShape([int mode]) {
    if (_shapeKind == LINES) {
      for (int x = 0; x < _shapeVertices.length; x += 2) {
        line(
          _shapeVertices[x].dx,
          _shapeVertices[x].dy,
          _shapeVertices[x + 1].dx,
          _shapeVertices[x + 1].dy,
        );
      }
    } else if (_shapeKind == POINTS && paintStyle.useStroke) {
      _canvas.drawPoints(PointMode.points, _shapeVertices, paintStyle.stroke);
    } else if (_shapeKind == TRIANGLES) {
      for (int x = 0; x < _shapeVertices.length; x += 3) {
        triangle(
            _shapeVertices[x + 0].dx,
            _shapeVertices[x + 0].dy,
            _shapeVertices[x + 1].dx,
            _shapeVertices[x + 1].dy,
            _shapeVertices[x + 2].dx,
            _shapeVertices[x + 2].dy);
      }
    } else if (_shapeKind == TRIANGLE_STRIP) {
      for (int x = 0; x < _shapeVertices.length - 2; x += 1) {
        triangle(
            _shapeVertices[x + 0].dx,
            _shapeVertices[x + 0].dy,
            _shapeVertices[x + 1].dx,
            _shapeVertices[x + 1].dy,
            _shapeVertices[x + 2].dx,
            _shapeVertices[x + 2].dy);
      }
    } else {
      if (_isCatmullRomShape) {
        _currentShape = resolveCurvePath(_shapeVertices);
      }

      if (_currentShape != null) {
        if (mode == CLOSE) {
          _currentShape.close();
        }
        _cutters.forEach((element) {
          _currentShape =
              Path.combine(PathOperation.difference, _currentShape, element);
        });

        var ps = paintStyle;

        if (ps.useFill) {
          _canvas.drawPath(_currentShape, ps.fill);
        }
        if (ps.useStroke) {
          _canvas.drawPath(_currentShape, ps.stroke);
        }
      }
    }

    _cutters = [];
    _currentShape = null;
  }

  vertex(double x, double y) {
    var path = _currentShape;
    if (_isContourActive) {
      path = _currentContour;
    }

    if (_pathVertices.length == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    _pathVertices.add(Offset(x, y));
  }

  curveVertex(double x, double y) {
    if (_shapeKind != null) {
      return;
    }
    if (_isContourActive) {
      _isCatmullRomContour = true;
    } else {
      _isCatmullRomShape = true;
    }
    vertex(x, y);
  }

  bezierVertex(x2, y2, x3, y3, x4, y4) {
    var path = _currentShape;
    if (_isContourActive) {
      path = _currentContour;
    }
    path.cubicTo(x2, y2, x3, y3, x4, y4);
  }

  textSize(int size) {
    paintStyle.textSize = size;
    paintStyle.textLeading = size;
  }

  textLeading(int leading) {
    paintStyle.textLeading = leading;
  }

  textAlign(int align) {
    if (align == CENTER) {
      paintStyle.textAlign = material.TextAlign.center;
    } else if (align == LEFT) {
      paintStyle.textAlign = material.TextAlign.left;
    } else {
      // RIGHT
      paintStyle.textAlign = material.TextAlign.right;
    }
  }

  textMode(int mode) {
    paintStyle.textMode = mode;
  }

  text(String str, double x1, double y1, [double x2, double y2]) {
    var style = ui.TextStyle(
      color: paintStyle.fill.color,
      height: paintStyle.textLeading.toDouble(),
      fontSize: paintStyle.textSize.toDouble(),
    );
    if (false) {
      _canvas.drawParagraph(
          (ParagraphBuilder(
            ParagraphStyle(
              fontSize: paintStyle.textSize.toDouble(),
              textAlign: paintStyle.textAlign,
              height: paintStyle.textLeading.toDouble(),
              fontStyle: material.FontStyle.normal,
            ),
          )..pushStyle(style))
              .build()
                ..layout(ui.ParagraphConstraints(width: x2)),
          Offset(x1, y1));
    } else {
      material.TextPainter(
        text: TextSpan(
          text: str,
          style: TextStyle(
            color: paintStyle.fill.color,
            height: paintStyle.textLeading.toDouble() /
                paintStyle.textSize.toDouble(),
            fontSize: paintStyle.textSize.toDouble(),
          ),
        ),
        textAlign: paintStyle.textAlign,
        textDirection: material.TextDirection.ltr,
      )
        ..layout(
            maxWidth:
                x2 != null ? x2 > 0 ? x2 : double.infinity : double.infinity)
        ..paint(_canvas.internalCanvas, Offset(x1, y1));
    }
  }

  updateTime(Duration newElapsed) {
    deltaTime = newElapsed - elapsed;
    elapsed = newElapsed;
  }

  final eventQueue = <_EventType, Function>{};
  pushCallback(_EventType type, Function func) {
    if (!eventQueue.containsKey(type)) {
      eventQueue[type] = func;
    }
  }
}

enum _EventType {
  mousePressed,
  mouseDragged,
  mouseReleased,
  mouseClicked,
}

// make a generic class which adds a subcass of the custom painter

class P5Widget<T extends PApplet> extends material.StatefulWidget {
  final T Function() create;
  P5Widget({@material.required this.create});

  @override
  _P5WidgetState createState() => _P5WidgetState(create: create);
}

class _P5WidgetState<T extends PApplet> extends material.State<P5Widget>
    with material.SingleTickerProviderStateMixin {
  T Function() create;
  T sketch;

  Ticker ticker;
  _P5WidgetState({this.create});

  @override
  void initState() {
    super.initState();
    sketch = create();

    ticker = createTicker((elapsed) {
      sketch.updateTime(elapsed);
      if (sketch.firstFrameDrawn && !sketch.isTicking) {
      } else {
        sketch.redraw();
      }
    })
      ..start();
  }

  @override
  material.Widget build(material.BuildContext context) {
    return material.MouseRegion(
      child: material.GestureDetector(
        child: material.CustomPaint(
          size: Size.infinite,
          painter: sketch,
        ),
        onPanStart: (details) {
          sketch.mouseX = details.localPosition.dx;
          sketch.mouseY = details.localPosition.dy;
          sketch.pushCallback(
              _EventType.mousePressed, () => sketch.mousePressed());
        },
        onPanUpdate: (details) {
          sketch.mouseX = details.localPosition.dx;
          sketch.mouseY = details.localPosition.dy;
          sketch.pushCallback(
              _EventType.mouseDragged, () => sketch.mouseDragged());
        },
        onPanEnd: (details) {
          sketch.pushCallback(
              _EventType.mouseReleased, () => sketch.mouseReleased());
        },
        onTapUp: (details) {
          sketch.pushCallback(
              _EventType.mouseClicked, () => sketch.mouseClicked());
        },
      ),
      onHover: (event) {
        sketch.mouseX = event.position.dx;
        sketch.mouseY = event.position.dy;
      },
    );
  }
}
