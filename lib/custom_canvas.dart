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
}
