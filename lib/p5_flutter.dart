import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'custom_canvas.dart';
import 'pconstants.dart';
import 'paint_style.dart';
import 'pmath.dart';

// TODO parametrize these
const batchesToKeep = 2;
const drawCommandsPerBatch = 100;

class PApplet extends CustomPainter with ChangeNotifier, PMath {
  var elapsed = Duration();
  var deltaTime = Duration();

  var mouseX = 0.0;
  var mouseY = 0.0;

  var _styleStack = <PaintStyle>[
    PaintStyle.makeDefault(),
  ];

  var _initialized = false;

  Canvas _canvas;
  Canvas _targetCanvas;

  var batches = <PictureData>[];
  PictureData _previousFrame;

  PApplet();

  var drawCalls = 0;

  bool clearOnBeginFrame() => true;

  @override
  void paint(Canvas canvas, Size size) {
    _targetCanvas = canvas;
    _targetCanvas.drawColor(color(200), BlendMode.color);

    var shouldClearOnBeginFrame = clearOnBeginFrame();
    if (!shouldClearOnBeginFrame) {
      _canvas = CustomCanvas(pictureRecorder: PictureRecorder());
      // draw previous frame to canvas
      batches.forEach((element) => element.drawToCanvas(_targetCanvas));

      if (_previousFrame != null) {
        (_canvas as CustomCanvas).drawPictureData(_previousFrame);
      }
    } else {
      _canvas = _targetCanvas;
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
          batches.forEach((element) => element.drawToCanvas(_temp));
          final pic = _temp.getPicture();
          pic.toImage(size);
          batches.clear();
          batches.add(pic);
        }
        _previousFrame = null;
      } else {
        _previousFrame = (_canvas as CustomCanvas).getPicture();
        _targetCanvas.drawPicture(_previousFrame.picture);
      }
    }

    // _showDebugInfo();

    _canvas = null;
  }

  _showDebugInfo() {
    // fps
    final fps = 1 / (deltaTime.inMilliseconds * 0.001);
    var drawCalls = 0;
    if (_canvas is CustomCanvas) {
      drawCalls = (_canvas as CustomCanvas).drawCalls;
    }
    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.blue[800]), text: '''       
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

  PaintStyle get paintStyle => _styleStack.last;

  // to override
  setup() {}
  draw() {}

  // callbacks
  mousePressed() {}
  mouseReleased() {}
  mouseDragged() {}
  mouseClicked() {}

  popMatrix() {
    _canvas?.restore();
  }

  pushMatrix() {
    _canvas?.save();
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

  setLocation(int x, int y) {
    throw UnimplementedError();
  }

  setResizable(bool resizable) {
    throw UnimplementedError();
  }

  setTitle(String title) {
    throw UnimplementedError();
  }

  thread() {
    throw UnimplementedError();
  }

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
    paintStyle.fill?.color = color;
  }

  noSmooth() {
    print('noSmooth unimplemented');
  }

  noStroke() {
    paintStyle.useStroke = false;
  }

  Color color(int r, [int g, int b, int a]) {
    if (g != null && b == null) {
      return Color.fromARGB(g, r, r, r);
    }
    if (g == null) {
      return Color.fromARGB(255, r, r, r);
    }
    if (a == null && b != null) {
      return Color.fromARGB(255, r, g, b);
    }
    return Color.fromARGB(a, r, g, b);
  }

  stroke(dynamic r, [int g, int b, int a]) {
    Color color;
    if (r is Color && !(r is num)) {
      color = r;
    } else {
      color = this.color(r, g, b, a);
    }
    paintStyle.useStroke = true;
    paintStyle.stroke?.color = color;
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

  ellipse(double a, double b, double c, double d) {
    final x = a;
    final y = b;
    final width = c;
    final height = d;

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

  line(double x1, double y1, double x2, double y2) {
    final ps = paintStyle;
    if (ps.useStroke) {
      _canvas.drawLine(Offset(x1, y1), Offset(x2, y2), ps.stroke);
    }
  }

  point(double x, double y, [double z]) {
    final ps = paintStyle;
    if (ps.useStroke)
      _canvas.drawPoints(PointMode.points, [Offset(x, y)], ps.stroke);
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

class P5Widget<T extends PApplet> extends StatefulWidget {
  final T Function() create;
  P5Widget({@required this.create});

  @override
  _P5WidgetState createState() => _P5WidgetState(create: create);
}

// TODO wrap into mouse region
class _P5WidgetState<T extends PApplet> extends State<P5Widget>
    with SingleTickerProviderStateMixin {
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
      sketch.redraw();
    })
      ..start();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        child: CustomPaint(
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
