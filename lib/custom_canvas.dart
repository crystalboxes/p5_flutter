import 'dart:typed_data';
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

class CustomCanvas {
  PictureRecorder pictureRecorder;
  var drawCalls = 0;
  Canvas _internal;

  Canvas get internalCanvas => _internal;

  CustomCanvas({this.pictureRecorder, Canvas fromOther}) {
    if (pictureRecorder != null) {
      _internal = Canvas(pictureRecorder);
    } else if (fromOther != null) {
      _internal = fromOther;
    }
  }

  PictureData getPicture() {
    if (pictureRecorder != null) {
      return PictureData(
          picture: pictureRecorder.endRecording(), drawCommands: drawCalls);
    }
    return null;
  }

  void scale(double sx, [double sy]) {
    _internal.scale(sx, sy);
  }

  void clipPath(Path pppath, {bool dddoAntiAlias = true}) {
    _internal.clipPath(pppath, doAntiAlias: dddoAntiAlias);
  }

  void clipRect(Rect rect,
      {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {
    _internal.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);
  }

  void drawColor(Color color, BlendMode blendMode) {
    _internal.drawColor(color, blendMode);
    drawCalls += 1;
  }

  void drawParagraph(Paragraph paragraph, Offset offset) {
    _internal.drawParagraph(paragraph, offset);
    drawCalls += 1;
  }

  void save() {
    _internal.save();
  }

  void restore() {
    _internal.restore();
  }

  void translate(double dx, double dy) {
    _internal.translate(dx, dy);
  }

  void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter,
      Paint paint) {
    _internal.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    drawCalls += 1;
  }

  void drawCircle(Offset c, double radius, Paint paint) {
    _internal.drawCircle(c, radius, paint);
    drawCalls += 1;
  }

  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) {
    _internal.drawPoints(pointMode, points, paint);
    drawCalls += 1;
  }

  void drawLine(Offset p1, Offset p2, Paint paint) {
    _internal.drawLine(p1, p2, paint);
    drawCalls += 1;
  }

  void drawImage(Image image, Offset offset, Paint paint) {
    _internal.drawImage(image, offset, paint);
    drawCalls += 1;
  }

  void drawPath(Path path, Paint paint) {
    _internal.drawPath(path, paint);
    drawCalls += 1;
  }

  void drawRect(Rect rect, Paint paint) {
    _internal.drawRect(rect, paint);
    drawCalls += 1;
  }

  void drawRRect(RRect rrect, Paint paint) {
    _internal.drawRRect(rrect, paint);
    drawCalls += 1;
  }

  void drawPicture(Picture picture) {
    _internal.drawPicture(picture);
  }

  void drawPictureData(PictureData data) {
    _internal.drawPicture(data.picture);
    drawCalls += data.drawCommands;
  }
}

// class Cust implements Canvas {
//   @override
//   void clipPath(Path pppath, {bool dddoAntiAlias = true}) {
//       // TODO: implement clipPath
//     }

//     @override
//     void clipRRect(Path ppaect, {bool dddoAntiAlias = true}) {
//       // TODO: implement clipRRect
//     }

//     @override
//     void clipRect(Path prpact, {bool d doipOp = ClipOp.intersect, bool doAntiAlias = true}) {
//       // TODO: implement clipRect
//     }

//     @override
//     void drawArc(Path prpact, bool d doartAngle, bool e doAntAngle, bool useCenter, Paint paPaint paPaint paipaipaint) {
//       // TODO: implement drawArc
//     }

//     @override
//     void drawAtlas(Path ppalas, bool dSTransform> doansforms, bool Rect> doAnt, bool<Color> useCenter, Paint paBlendMode bPaint pai paint) {
//   , Rect cullRect, Paint paint) {
//       // TODO: implement drawAtlas
//     }

//     @override
//     void drawCircle(Path p pa bool d dodius, bool  doAnt) {
//       // TODO: implement drawCircle
//     }

//     @override
//     void drawColor(Path ppalor, bool dode doendMode) {
//       // TODO: implement drawColor
//     }

//     @override
//     void drawDRRect(Path ppater, bool ddoner, bool  doAnt) {
//       // TODO: implement drawDRRect
//     }

//     @override
//     void drawImage(Path ppaage, bool d do bool  doAnt) {
//       // TODO: implement drawImage
//     }

//     @override
//     void drawImageNine(Path ppaage, bool dcdonter, bool doAntboolt useCenter, Paint paO: implement drawImageNine
//     }

//     @override
//     void drawImageRect(Path ppaage, bool dsdoc, bool doAntboolt useCenter, Paint paO: implement drawImageRect
//     }

//     @override
//     void drawLine(Path p pa, bool d do, bool  doAnt) {
//       // TODO: implement drawLine
//     }

//     @override
//     void drawOval(Path prpact, bool ddoint) {
//       // TODO: implement drawOval
//     }

//     @override
//     void drawPaint(Path ppaint) {
//       // TODO: implement drawPaint
//     }

//     @override
//     void drawParagraph(Path paph paragraph, bool d dofset) {
//       // TODO: implement drawParagraph
//     }

//     @override
//     void drawPath(Path pppath, bool ddoint) {
//       // TODO: implement drawPath
//     }

//     @override
//     void drawPicture(Path pe pacture) {
//       // TODO: implement drawPicture
//     }

//     @override
//     void drawPoints(Path pode paintMode, bool dffset> doints, bool  doAnt) {
//       // TODO: implement drawPoints
//     }

//     @override
//     void drawRRect(Path ppaect, bool ddoint) {
//       // TODO: implement drawRRect
//     }

//     @override
//     void drawRawAtlas(Path ppalas, bool d2List dotTransforms, bool 32List doAnt, bool2List useCenter, Paint paBlendMode bPaint pai paint) {
//   , Rect cullRect, Paint paint) {
//       // TODO: implement drawRawAtlas
//     }

//     @override
//     void drawRawPoints(Path pode paintMode, bool d2List doints, bool  doAnt) {
//       // TODO: implement drawRawPoints
//     }

//     @override
//     void drawRect(Path prpact, bool ddoint) {
//       // TODO: implement drawRect
//     }

//     @override
//     void drawShadow(Path pppath, bool ddolor, bool e doAnttion, bool useCenter, Paint pa) {
//       // TODO: implement drawShadow
//     }

//     @override
//     void drawVertices(Path pes partices, bool dode doendMode, bool  doAnt) {
//       // TODO: implement drawVertices
//     }

//     @override
//     int getSaveCount() {
//       // TODO: implement getSaveCount
//       throw UnimplementedError();
//     }

//     @override
//     void restore() {
//       // TODO: implement restore
//     }

//     @override
//     void rotate(Path p padians) {
//       // TODO: implement rotate
//     }

//     @override
//     void save() {
//       // TODO: implement save
//     }

//     @override
//     void saveLayer(Path pbpaunds, bool ddoint) {
//       // TODO: implement saveLayer
//     }

//     @override
//     void scale(Path p pa, [bool d do]) {
//       // TODO: implement scale
//     }

//     @override
//     void skew(Path p pa, bool d do) {
//       // TODO: implement skew
//     }

//     @override
//     void transform(Path p4List patrix4) {
//       // TODO: implement transform
//     }

//     @override
//     void translate(Path p pa, bool d do) {
//     // TODO: implement translate
//   }
// }
