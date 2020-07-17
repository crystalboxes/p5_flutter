import 'dart:ui';

// TODO figure out the correct size
const captureAspect = 1;

class PictureData {
  Picture picture;
  final int drawCommands;

  Image image;

  Duration elapsed;

  toImage(Size size) {
    final sizeX = (size.width.toInt() * captureAspect).toInt();
    final sizeY = (size.height.toInt() * captureAspect).toInt();

    CustomCanvas a = CustomCanvas(pictureRecorder: PictureRecorder());
    a.scale(captureAspect.toDouble());
    a.drawPicture(picture);
    final p = a.getPicture();

    p.picture.toImage(sizeX, sizeY).then((value) {
      image = value;
    });
  }

  drawToCanvas(Canvas c) {
    if (this.image != null) {
      c.scale(1 / captureAspect.toDouble());
      c.drawImage(image, Offset(0, 0), Paint());
      c.scale(captureAspect.toDouble());
    } else {
      c.drawPicture(picture);
    }
  }

  PictureData({this.picture, this.drawCommands});
}

class CustomCanvas extends Canvas {
  PictureRecorder pictureRecorder;

  CustomCanvas({this.pictureRecorder}) : super(pictureRecorder);
  var drawCalls = 0;

  PictureData getPicture() => PictureData(
      picture: pictureRecorder.endRecording(), drawCommands: drawCalls);

  @override
  void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter,
      Paint paint) {
    super.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    drawCalls += 1;
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    super.drawCircle(c, radius, paint);
    drawCalls += 1;
  }

  @override
  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) {
    super.drawPoints(pointMode, points, paint);
    drawCalls += 1;
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    super.drawLine(p1, p2, paint);
    drawCalls += 1;
  }

  @override
  void drawImage(Image image, Offset offset, Paint paint) {
    super.drawImage(image, offset, paint);
    drawCalls += 1;
  }

  @override
  void drawPath(Path path, Paint paint) {
    super.drawPath(path, paint);
    drawCalls += 1;
  }

  @override
  void drawRect(Rect rect, Paint paint) {
    super.drawRect(rect, paint);
    drawCalls += 1;
  }

  @override
  void drawRRect(RRect rrect, Paint paint) {
    super.drawRRect(rrect, paint);
    drawCalls += 1;
  }

  void drawPictureData(PictureData data) {
    drawPicture(data.picture);
    drawCalls += data.drawCommands;
  }

  // @override
  // void clipPath(Path path, {bool doAntiAlias = true}) {
  //   // TODO: implement clipPath
  //   super.clipPath(path, doAntiAlias: doAntiAlias);
  // }

  // @override
  // void clipRRect(RRect rrect, {bool doAntiAlias = true}) {
  //   // TODO: implement clipRRect
  //   super.clipRRect(rrect, doAntiAlias: doAntiAlias);
  // }

  // @override
  // void clipRect(Rect rect,
  //     {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {
  //   // TODO: implement clipRect
  //   super.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);
  // }

  // @override
  // void drawAtlas(Image atlas, List<RSTransform> transforms, List<Rect> rects,
  //     List<Color> colors, BlendMode blendMode, Rect cullRect, Paint paint) {
  //   // TODO: implement drawAtlas
  //   super.drawAtlas(
  //       atlas, transforms, rects, colors, blendMode, cullRect, paint);
  // }

  // @override
  // void drawColor(Color color, BlendMode blendMode) {
  //   // TODO: implement drawColor
  //   super.drawColor(color, blendMode);
  // }

  // @override
  // void drawDRRect(RRect outer, RRect inner, Paint paint) {
  //   // TODO: implement drawDRRect
  //   super.drawDRRect(outer, inner, paint);
  // }

  // @override
  // void drawImageNine(Image image, Rect center, Rect dst, Paint paint) {
  //   // TODO: implement drawImageNine
  //   super.drawImageNine(image, center, dst, paint);
  // }

  // @override
  // void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {
  //   // TODO: implement drawImageRect
  //   super.drawImageRect(image, src, dst, paint);
  // }

  // @override
  // void drawOval(Rect rect, Paint paint) {
  //   // TODO: implement drawOval
  //   super.drawOval(rect, paint);
  // }

  // @override
  // void drawPaint(Paint paint) {
  //   // TODO: implement drawPaint
  //   super.drawPaint(paint);
  // }

  // @override
  // void drawPicture(Picture picture) {
  //   // TODO: implement drawPicture
  //   super.drawPicture(picture);
  // }

  // @override
  // void drawRRect(RRect rrect, Paint paint) {
  //   // TODO: implement drawRRect
  //   super.drawRRect(rrect, paint);
  // }

  // @override
  // void drawRect(Rect rect, Paint paint) {
  //   // TODO: implement drawRect
  //   super.drawRect(rect, paint);
  // }

  // @override
  // void drawShadow(
  //     Path path, Color color, double elevation, bool transparentOccluder) {
  //   // TODO: implement drawShadow
  //   super.drawShadow(path, color, elevation, transparentOccluder);
  // }

  // @override
  // void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) {
  //   // TODO: implement drawVertices
  //   super.drawVertices(vertices, blendMode, paint);
  // }

  // @override
  // int getSaveCount() {
  //   // TODO: implement getSaveCount
  //   return super.getSaveCount();
  // }

  // @override
  // void restore() {
  //   // TODO: implement restore
  //   super.restore();
  // }

  // @override
  // void rotate(double radians) {
  //   // TODO: implement rotate
  //   super.rotate(radians);
  // }

  // @override
  // void save() {
  //   // TODO: implement save
  //   super.save();
  // }

  // @override
  // void saveLayer(Rect bounds, Paint paint) {
  //   // TODO: implement saveLayer
  //   super.saveLayer(bounds, paint);
  // }

  // @override
  // void scale(double sx, [double sy]) {
  //   // TODO: implement scale
  //   super.scale(sx, sy);
  // }

  // @override
  // void skew(double sx, double sy) {
  //   // TODO: implement skew
  //   super.skew(sx, sy);
  // }

  // @override
  // void translate(double dx, double dy) {
  //   // TODO: implement translate
  //   super.translate(dx, dy);
  // }
}
