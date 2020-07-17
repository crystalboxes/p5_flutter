import 'dart:ui';

import 'package:p5_flutter/pgraphics.dart';

import 'pconstants.dart';

class PShape {
  String name;
  var nameTable = <String, PShape>{};

//  /** Generic, only draws its child objects. */
//  static const int GROUP = 0;
  // GROUP now inherited from PConstants, and is still zero

  // These constants were updated in 3.0b6 so that they could be distinguished
  // from others in PConstants and improve how some typos were handled.
  // https://github.com/processing/processing/issues/3776
  /// A line, ellipse, arc, image, etc. */
  static const int PRIMITIVE = 101;

  /// A series of vertex, curveVertex, and bezierVertex calls. */
  static const int PATH = 102;

  /// Collections of vertices created with beginShape(). */
  static const int GEOMETRY = 103;

  /// The shape type, one of GROUP, PRIMITIVE, PATH, or GEOMETRY. */
  int family;

  /// ELLIPSE, LINE, QUAD; TRIANGLE_FAN, QUAD_STRIP; etc. */
  int kind;

  PMatrix matrix;

  int _textureMode;

  /// Texture or image data associated with this shape. */
  PImage image;

  static const String OUTSIDE_BEGIN_END_ERROR =
      "%1_s can only be called between beginShape() and endShape()";

  static const String INSIDE_BEGIN_END_ERROR =
      "%1_s can only be called outside beginShape() and endShape()";

  static const String NO_SUCH_VERTEX_ERROR = "%1_s vertex index does not exist";

  static const String NO_VERTICES_ERROR =
      "getVertexCount() only works with PATH or GEOMETRY shapes";

  static const String NOT_A_SIMPLE_VERTEX =
      "%1_s can not be called on quadratic or bezier vertices";

  static const String PER_VERTEX_UNSUPPORTED =
      "This renderer does not support %1_s for individual vertices";

  /*
            * ( begin auto-generated from PShape_width.xml )
            *
            * The width of the PShape document.
            *
            * ( end auto-generated )
            * @webref pshape:field
            * @usage web_application
            * @brief     Shape document width
            * @see PShape#height
            */
  double width;
  /*
            * ( begin auto-generated from PShape_height.xml )
            *
            * The height of the PShape document.
            *
            * ( end auto-generated )
            * @webref pshape:field
            * @usage web_application
            * @brief     Shape document height
            * @see PShape#width
            */
  double height;

  double depth;

  PGraphics g;

  // set to false if the object is hidden in the layers palette
  bool visible = true;

  /// Retained shape being created with beginShape/endShape */
  bool openShape = false;

  bool openContour = false;

  bool _stroke;
  int strokeColor;
  double _strokeWeight; // default is 1
  int _strokeCap;
  int _strokeJoin;

  bool _fill;
  int fillColor;

  bool _tint;
  int tintColor;

  int ambientColor;
  bool setAmbient;
  int specularColor;
  int emissiveColor;
  double shininess;

  int sphereDetailU, sphereDetailV;
  int rectMode;
  int ellipseMode;

  /// Temporary toggle for whether styles should be honored. */
  bool style = true;

  /// For primitive shapes in particular, params like x/y/w/h or x1/y1/x2/y2. */
  var params = <double>[];

  int vertexCount;
  /*
            * When drawing POLYGON shapes, the second param is an array of length
            * VERTEX_FIELD_COUNT. When drawing PATH shapes, the second param has only
            * two variables.
            */
  List<List<double>> vertices;

  PShape parent;
  int childCount;
  var children = <PShape>[];

  /// Array of VERTEX, BEZIER_VERTEX, and CURVE_VERTEX calls. */
  int vertexCodeCount;
  var vertexCodes = <int>[];

  /// True if this is a closed path. */
  bool close;

  // ........................................................

  // internal color for setting/calculating
  double calcR, calcG, calcB, calcA;
  int calcRi, calcGi, calcBi, calcAi;
  int calcColor;
  bool calcAlpha;

  /// The current colorMode */
  int colorMode; // = RGB;

  /// Max value for red (or hue) set by colorMode */
  double colorModeX; // = 255;

  /// Max value for green (or saturation) set by colorMode */
  double colorModeY; // = 255;

  /// Max value for blue (or value) set by colorMode */
  double colorModeZ; // = 255;

  /// Max value for alpha set by colorMode */
  double colorModeA; // = 255;

  /// True if colors are not in the range 0..1 */
  bool colorModeScale; // = true;

  /// True if colorMode(RGB, 255) */
  bool colorModeDefault; // = true;

  /// True if contains 3D data */
  bool _is3D = false;

  bool perVertexStyles = false;

  // should this be called vertices (consistent with PGraphics internals)
  // or does that hurt flexibility?

  // POINTS, LINES, xLINE_STRIP, xLINE_LOOP
  // TRIANGLES, TRIANGLE_STRIP, TRIANGLE_FAN
  // QUADS, QUAD_STRIP
  // xPOLYGON
//  static final int PATH = 1;  // POLYGON, LINE_LOOP, LINE_STRIP
//  static final int GROUP = 2;

  // how to handle rectmode/ellipsemode?
  // are they bitshifted into the constant?
  // CORNER, CORNERS, CENTER, (CENTER_RADIUS?)
//  static final int RECT = 3; // could just be QUAD, but would be x1/y1/x2/y2
//  static final int ELLIPSE = 4;
//
//  static final int VERTEX = 7;
//  static final int CURVE = 5;
//  static final int BEZIER = 6;

  // fill and stroke functions will need a pointer to the parent
  // PGraphics object.. may need some kind of createShape() fxn
  // or maybe the values are stored until draw() is called?

  // attaching images is very tricky.. it's a different type of data

  // material parameters will be thrown out,
  // except those currently supported (kinds of lights)

  // pivot point for transformations
//   double px;
//   double py;
  Paint _paint;

  /// @nowebref
  PShape({Paint paint, int family, int kind, List<double> params}) {
    _paint = paint == null ? Paint() : paint;
    this.family = family == null ? GROUP : family;
    this.kind = kind == null ? PRIMITIVE : kind;
  }

  void setFamily(int family) {
    this.family = family;
  }

  void setKind(int kind) {
    this.kind = kind;
  }

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return name;
  }

  /// ( begin auto-generated from PShape_isVisible.xml )
  ///
  /// Returns a boolean value "true" if the image is set to be visible,
  /// "false" if not. This is modified with the <b>setVisible()</b> parameter.
  /// <br/> <br/>
  /// The visibility of a shape is usually controlled by whatever program
  /// created the SVG file. For instance, this parameter is controlled by
  /// showing or hiding the shape in the layers palette in Adobe Illustrator.
  ///
  /// ( end auto-generated )
  /// @webref pshape:method
  /// @usage web_application
  /// @brief Returns a boolean value "true" if the image is set to be visible, "false" if not
  /// @see PShape#setVisible(boolean)
  bool isVisible() {
    return visible;
  }

  /// ( begin auto-generated from PShape_setVisible.xml )
  ///
  /// Sets the shape to be visible or invisible. This is determined by the
  /// value of the <b>visible</b> parameter.
  /// <br/> <br/>
  /// The visibility of a shape is usually controlled by whatever program
  /// created the SVG file. For instance, this parameter is controlled by
  /// showing or hiding the shape in the layers palette in Adobe Illustrator.
  ///
  /// ( end auto-generated )
  /// @webref pshape:mathod
  /// @usage web_application
  /// @brief Sets the shape to be visible or invisible
  /// @param visible "false" makes the shape invisible and "true" makes it visible
  /// @see PShape#isVisible()
  void setVisible(bool visible) {
    this.visible = visible;
  }

  /// ( begin auto-generated from PShape_disableStyle.xml )
  ///
  /// Disables the shape's style data and uses Processing's current styles.
  /// Styles include attributes such as colors, stroke weight, and stroke
  /// joints.
  ///
  /// ( end auto-generated )
  ///  <h3>Advanced</h3>
  /// Overrides this shape's style information and uses PGraphics styles and
  /// colors. Identical to ignoreStyles(true). Also disables styles for all
  /// child shapes.
  /// @webref pshape:method
  /// @usage web_application
  /// @brief     Disables the shape's style data and uses Processing styles
  /// @see PShape#enableStyle()
  void disableStyle() {
    style = false;

    for (int i = 0; i < childCount; i++) {
      children[i].disableStyle();
    }
  }

  /// ( begin auto-generated from PShape_enableStyle.xml )
  ///
  /// Enables the shape's style data and ignores Processing's current styles.
  /// Styles include attributes such as colors, stroke weight, and stroke
  /// joints.
  ///
  /// ( end auto-generated )
  ///
  /// @webref pshape:method
  /// @usage web_application
  /// @brief Enables the shape's style data and ignores the Processing styles
  /// @see PShape#disableStyle()
  void enableStyle() {
    style = true;

    for (int i = 0; i < childCount; i++) {
      children[i].enableStyle();
    }
  }

  /// Get the width of the drawing area (not necessarily the shape boundary).
  getWidth() {
    //checkBounds();
    return width;
  }

  /// Get the height of the drawing area (not necessarily the shape boundary).
  getHeight() {
    //checkBounds();
    return height;
  }

  /// Get the depth of the shape area (not necessarily the shape boundary). Only makes sense for 3D PShape subclasses,
  /// such as PShape3D.
  getDepth() {
    //checkBounds();
    return depth;
  }

  /// Return true if this shape is 2D. Defaults to true.
  bool is2D() {
    return !_is3D;
  }

  /// Return true if this shape is 3D. Defaults to false.
  bool is3D() {
    return _is3D;
  }

  void set3D(bool val) {
    _is3D = val;
  }

  // Drawing methods

  void textureMode(int mode) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "textureMode()");
      return;
    }

    _textureMode = mode;
  }

  void texture(PImage tex) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "texture()");
      return;
    }

    image = tex;
  }

  void noTexture() {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "noTexture()");
      return;
    }

    image = null;
  }

  // TODO unapproved
  void solid(bool solid) {}

  /// @webref shape:vertex
  /// @brief Starts a new contour
  /// @see PShape#endContour()
  void beginContour() {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "beginContour()");
      return;
    }

    if (family == GROUP) {
      PGraphics.showWarning("Cannot begin contour in GROUP shapes");
      return;
    }

    if (openContour) {
      PGraphics.showWarning("Already called beginContour().");
      return;
    }
    openContour = true;
    beginContourImpl();
  }

  void beginContourImpl() {
    if (vertexCodes == null) {
      vertexCodes = [for (int x = 0; x < 10; x++) 0];
    } else if (vertexCodes.length == vertexCodeCount) {
      // vertexCodes = PApplet.expand(vertexCodes);
      vertexCodes.add(0);
    }
    vertexCodes[vertexCodeCount++] = BREAK;
  }

  /// @webref shape:vertex
  /// @brief Ends a contour
  /// @see PShape#beginContour()
  void endContour() {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "endContour()");
      return;
    }

    if (family == GROUP) {
      PGraphics.showWarning("Cannot end contour in GROUP shapes");
      return;
    }

    if (!openContour) {
      PGraphics.showWarning("Need to call beginContour() first.");
      return;
    }
    endContourImpl();
    openContour = false;
  }

  void endContourImpl() {}

  void _vertex(double x, double y) {
    if (vertices == null) {
      vertices = [
        for (int x = 0; x < 10; x++) [0.0, 0.0]
      ];
    } else if (vertices.length == vertexCount) {
      vertices.add([0.0, 0.0]);
    }
    vertices[vertexCount++] = [x, y];

    if (vertexCodes == null) {
      vertexCodes = [for (int x = 0; x < 10; x++) 0];
    } else if (vertexCodes.length == vertexCodeCount) {
      vertexCodes.add(0);
    }
    vertexCodes[vertexCodeCount++] = VERTEX;

    if (x > width) {
      width = x;
    }
    if (y > height) {
      height = y;
    }
  }

  void vertex({double x, double y, double z, double u, double v}) {
    _vertex(x, y);
  }

  void normal(double nx, double ny, double nz) {}

  void attribPosition(String name, double x, double y, double z) {}

  void attribNormal(String name, double nx, double ny, double nz) {}

  void attribColor(String name, int color) {}

  void attrib(String name, List<dynamic> values) {}

  /// @webref pshape:method
  /// @brief Starts the creation of a new PShape
  /// @see PApplet#endShape()

  void beginShape([int kind]) {
    this.kind = kind == null ? POLYGON : kind;
    openShape = true;
  }

  /// @webref pshape:method
  /// @brief Finishes the creation of a new PShape
  /// @see PApplet#beginShape()
  void endShape([int mode]) {
    mode = mode == null ? OPEN : mode;

    if (family == GROUP) {
      PGraphics.showWarning("Cannot end GROUP shape");
      return;
    }

    if (!openShape) {
      PGraphics.showWarning("Need to call beginShape() first");
      return;
    }

    close = (mode == CLOSE);

    // this is the state of the shape
    openShape = false;
  }

  //////////////////////////////////////////////////////////////

  // STROKE CAP/JOIN/WEIGHT

  void strokeWeight(double weight) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "strokeWeight()");
      return;
    }

    _strokeWeight = weight;
  }

  void strokeJoin(int join) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "strokeJoin()");
      return;
    }

    _strokeJoin = join;
  }

  void strokeCap(int cap) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "strokeCap()");
      return;
    }
    _strokeCap = cap;
  }

  //////////////////////////////////////////////////////////////

  // FILL COLOR

  void noFill() {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "noFill()");
      return;
    }

    _fill = false;
    fillColor = 0x0;

    if (!setAmbient) {
      ambientColor = fillColor;
    }
  }

  void fill({int rgb, double gray, double alpha}) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "fill()");
      return;
    }

    _fill = true;
    throw UnimplementedError();
    // colorCalc(rgb, alpha);
    fillColor = calcColor;

    if (!setAmbient) {
      ambientColor = fillColor;
    }
  }

  void noStroke() {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "noStroke()");
      return;
    }

    _stroke = false;
  }

  void stroke({int rgb, double gray, double alpha}) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "stroke()");
      return;
    }

    _stroke = true;
    throw UnimplementedError();
    // colorCalc(rgb);
    strokeColor = calcColor;
  }

  //////////////////////////////////////////////////////////////

  // TINT COLOR

  void noTint() {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "noTint()");
      return;
    }

    _tint = false;
  }

  void tint({int rgb, double gray, double alpha}) {
    if (!openShape) {
      PGraphics.showWarning(OUTSIDE_BEGIN_END_ERROR, "tint()");
      return;
    }

    _tint = true;
    // colorCalc(rgb);
    tintColor = calcColor;
  }

  // TODO ambient, specular, emissive, shininess

  ///////////////////////////////////////////////////////////
  //
  // Bezier curves

  void bezierDetail(int detail) {}

  void bezierVertex(
      double x2, double y2, double x3, double y3, double x4, double y4) {
    if (vertices == null) {
      vertices = [
        for (int x = 0; x < 10; x++) [0.0, 0.0]
      ];
    } else if (vertexCount + 2 >= vertices.length) {
      vertices.add([0.0, 0.0]);
      vertices.add([0.0, 0.0]);
      vertices.add([0.0, 0.0]);
    }
    vertices[vertexCount++] = [x2, y2];
    vertices[vertexCount++] = [x3, y3];
    vertices[vertexCount++] = [x4, y4];

    // vertexCodes must be allocated because a vertex() call is required
    if (vertexCodes.length == vertexCodeCount) {
      vertexCodes.add(0); // = PApplet.expand(vertexCodes);
    }
    vertexCodes[vertexCodeCount++] = BEZIER_VERTEX;

    if (x4 > width) {
      width = x4;
    }
    if (y4 > height) {
      height = y4;
    }
  }

  void quadraticVertex(double cx, double cy, double x3, double y3) {
    if (vertices == null) {
      vertices = [
        for (int x = 0; x < 10; x++) [0.0, 0.0]
      ];
    } else if (vertexCount + 1 >= vertices.length) {
      vertices.add([0.0, 0.0]);
      vertices.add([0.0, 0.0]);
    }
    vertices[vertexCount++] = [cx, cy];
    vertices[vertexCount++] = [x3, y3];

    // vertexCodes must be allocated because a vertex() call is required
    if (vertexCodes.length == vertexCodeCount) {
      vertexCodes.add(0); // = PApplet.expand(vertexCodes);
    }
    vertexCodes[vertexCodeCount++] = QUADRATIC_VERTEX;

    if (x3 > width) {
      width = x3;
    }
    if (y3 > height) {
      height = y3;
    }
  }
}

class PImage {}

class PMatrix {}
