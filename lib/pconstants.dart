import 'dart:core';

import 'dart:math';

const int X = 0;
const int Y = 1;
const int Z = 2;

// renderers known to processing.core

/*
  // List of renderers used inside PdePreprocessor
   const StringList rendererList = new StringList(new String[] {
    "JAVA2D", "JAVA2D_2X",
    "P2D", "P2D_2X", "P3D", "P3D_2X", "OPENGL",
    "E2D", "FX2D", "FX2D_2X",  // experimental
    "LWJGL.P2D", "LWJGL.P3D",  // hmm
    "PDF"  // no DXF because that's only for beginRaw()
  });
  */

const JAVA2D = "processing.awt.PGraphicsJava2D";

const P2D = "processing.opengl.PGraphics2D";
const P3D = "processing.opengl.PGraphics3D";

// Experimental JavaFX renderer; even better 2D performance
const FX2D = "processing.javafx.PGraphicsFX2D";

const PDF = "processing.pdf.PGraphicsPDF";
const SVG = "processing.svg.PGraphicsSVG";
const DXF = "processing.dxf.RawDXF";

// platform IDs for PApplet.platform

const OTHER = 0;
const WINDOWS = 1;
const MACOSX = 2;
const LINUX = 3;

const platformNames = ["other", "windows", "macosx", "linux"];

const EPSILON = 0.0001;

// max/min values for numbers

/// Same as Float.MAX_VALUE, but included for parity with MIN_VALUE,
/// and to avoid teaching  methods on the first day.
const MAX_FLOAT = double.maxFinite;

/// Note that Float.MIN_VALUE is the smallest <EM>positive</EM> value
/// for a floating point number, not actually the minimum (negative) value
/// for a float. This constant equals 0xFF7FFFFF, the smallest (farthest
/// negative) value a float can have before it hits NaN.
const MIN_FLOAT = -double.maxFinite;

/// Largest possible (positive) integer value */
const MAX_INT = 9007199254740992;

/// Smallest possible (negative) integer value */
const MIN_INT = -9007199254740992;

// shapes

const int VERTEX = 0;
const int BEZIER_VERTEX = 1;
const int QUADRATIC_VERTEX = 2;
const int CURVE_VERTEX = 3;
const int BREAK = 4;

// useful goodness

/// ( begin auto-generated from PI.xml )
///
/// PI is a mathematical constant with the value 3.14159265358979323846. It
/// is the ratio of the circumference of a circle to its diameter. It is
/// useful in combination with the trigonometric functions <b>sin()</b> and
/// <b>cos()</b>.
///
/// ( end auto-generated )
/// @webref constants
/// @see PConstants#TWO_PI
/// @see PConstants#TAU
/// @see PConstants#HALF_PI
/// @see PConstants#QUARTER_PI
///
const PI = pi;

/// ( begin auto-generated from HALF_PI.xml )
///
/// HALF_PI is a mathematical constant with the value
/// 1.57079632679489661923. It is half the ratio of the circumference of a
/// circle to its diameter. It is useful in combination with the
/// trigonometric functions <b>sin()</b> and <b>cos()</b>.
///
/// ( end auto-generated )
/// @webref constants
/// @see PConstants#PI
/// @see PConstants#TWO_PI
/// @see PConstants#TAU
/// @see PConstants#QUARTER_PI
const HALF_PI = (PI / 2.0);
const THIRD_PI = (PI / 3.0);

/// ( begin auto-generated from QUARTER_PI.xml )
///
/// QUARTER_PI is a mathematical constant with the value 0.7853982. It is
/// one quarter the ratio of the circumference of a circle to its diameter.
/// It is useful in combination with the trigonometric functions
/// <b>sin()</b> and <b>cos()</b>.
///
/// ( end auto-generated )
/// @webref constants
/// @see PConstants#PI
/// @see PConstants#TWO_PI
/// @see PConstants#TAU
/// @see PConstants#HALF_PI
const QUARTER_PI = (PI / 4.0);

/// ( begin auto-generated from TWO_PI.xml )
///
/// TWO_PI is a mathematical constant with the value 6.28318530717958647693.
/// It is twice the ratio of the circumference of a circle to its diameter.
/// It is useful in combination with the trigonometric functions
/// <b>sin()</b> and <b>cos()</b>.
///
/// ( end auto-generated )
/// @webref constants
/// @see PConstants#PI
/// @see PConstants#TAU
/// @see PConstants#HALF_PI
/// @see PConstants#QUARTER_PI
const TWO_PI = (2.0 * PI);

/// ( begin auto-generated from TAU.xml )
///
/// TAU is an alias for TWO_PI, a mathematical constant with the value
/// 6.28318530717958647693. It is twice the ratio of the circumference
/// of a circle to its diameter. It is useful in combination with the
/// trigonometric functions <b>sin()</b> and <b>cos()</b>.
///
/// ( end auto-generated )
/// @webref constants
/// @see PConstants#PI
/// @see PConstants#TWO_PI
/// @see PConstants#HALF_PI
/// @see PConstants#QUARTER_PI
const TAU = (2.0 * PI);

const DEG_TO_RAD = PI / 180.0;
const RAD_TO_DEG = 180.0 / PI;

// angle modes

// const  RADIANS = 0;
// const  DEGREES = 1;

// used by split, all the standard whitespace chars
// (also includes unicode nbsp, that little bostage)

const WHITESPACE = " \t\n\r\f\u00A0";

// for colors and/or images

const RGB = 1; // image & color
const ARGB = 2; // image
const HSB = 3; // color
const ALPHA = 4; // image
//   const  CMYK  = 5;  // image & color (someday)

// image file types

const TIFF = 0;
const TARGA = 1;
const JPEG = 2;
const GIF = 3;

// filter/convert types

const BLUR = 11;
const GRAY = 12;
const INVERT = 13;
const OPAQUE = 14;
const POSTERIZE = 15;
const THRESHOLD = 16;
const ERODE = 17;
const DILATE = 18;

// blend mode keyword definitions
// @see processing.core.PImage#blendColor(int,int,int)

const int REPLACE = 0;
const int BLEND = 1 << 0;
const int ADD = 1 << 1;
const int SUBTRACT = 1 << 2;
const int LIGHTEST = 1 << 3;
const int DARKEST = 1 << 4;
const int DIFFERENCE = 1 << 5;
const int EXCLUSION = 1 << 6;
const int MULTIPLY = 1 << 7;
const int SCREEN = 1 << 8;
const int OVERLAY = 1 << 9;
const int HARD_LIGHT = 1 << 10;
const int SOFT_LIGHT = 1 << 11;
const int DODGE = 1 << 12;
const int BURN = 1 << 13;

// for messages

const CHATTER = 0;
const COMPLAINT = 1;
const PROBLEM = 2;

// types of transformation matrices

const PROJECTION = 0;
const MODELVIEW = 1;

// types of projection matrices

const CUSTOM = 0; // user-specified fanciness
const ORTHOGRAPHIC = 2; // 2D isometric projection
const PERSPECTIVE = 3; // perspective matrix

// shapes

// the low four bits set the variety,
// higher bits set the specific shape type

const GROUP = 0; // createShape()

const POINT = 2; // primitive
const POINTS = 3; // vertices

const LINE = 4; // primitive
const LINES = 5; // beginShape(), createShape()
const LINE_STRIP = 50; // beginShape()
const LINE_LOOP = 51;

const TRIANGLE = 8; // primitive
const TRIANGLES = 9; // vertices
const TRIANGLE_STRIP = 10; // vertices
const TRIANGLE_FAN = 11; // vertices

const QUAD = 16; // primitive
const QUADS = 17; // vertices
const QUAD_STRIP = 18; // vertices

const POLYGON = 20; // in the end, probably cannot
const PATH = 21; // separate these two

const RECT = 30; // primitive
const ELLIPSE = 31; // primitive
const ARC = 32; // primitive

const SPHERE = 40; // primitive
const BOX = 41; // primitive

//   const int POINT_SPRITES = 52;
//   const int NON_STROKED_SHAPE = 60;
//   const int STROKED_SHAPE     = 61;

// shape closing modes

const OPEN = 1;
const CLOSE = 2;

// shape drawing modes

/// Draw mode convention to use (x, y) to (width, height) */
const CORNER = 0;

/// Draw mode convention to use (x1, y1) to (x2, y2) coordinates */
const CORNERS = 1;

/// Draw mode from the center, and using the radius */
const RADIUS = 2;

/// Draw from the center, using second pair of values as the diameter.
/// Formerly called CENTER_DIAMETER in alpha releases.
const CENTER = 3;

/// Synonym for the CENTER constant. Draw from the center,
/// using second pair of values as the diameter.
const DIAMETER = 3;

// arc drawing modes

// const  OPEN = 1;  // shared
const CHORD = 2;
const PIE = 3;

// vertically alignment modes for text

/// Default vertical alignment for text placement */
const BASELINE = 0;

/// Align text to the top */
const TOP = 101;

/// Align text from the bottom, using the baseline. */
const BOTTOM = 102;

// uv texture orientation modes

/// texture coordinates in 0..1 range */
const NORMAL = 1;

/// texture coordinates based on image width/height */
const IMAGE = 2;

// texture wrapping modes

/// textures are clamped to their edges */
const CLAMP = 0;

/// textures wrap around when uv values go outside 0..1 range */
const REPEAT = 1;

// text placement modes

/// textMode(MODEL) is the default, meaning that characters
/// will be affected by transformations like any other shapes.
/// <p/>
/// Changed value in 0093 to not interfere with LEFT, CENTER, and RIGHT.
const MODEL = 4;

/// textMode(SHAPE) draws text using the the glyph outlines of
/// individual characters rather than as textures. If the outlines are
/// not available, then textMode(SHAPE) will be ignored and textMode(MODEL)
/// will be used instead. For this reason, be sure to call textMode()
/// <EM>after</EM> calling textFont().
/// <p/>
/// Currently, textMode(SHAPE) is only supported by OPENGL mode.
/// It also requires Java 1.2 or higher (OPENGL requires 1.4 anyway)
const SHAPE = 5;

// text alignment modes
// are inherited from LEFT, CENTER, RIGHT

// stroke modes

const SQUARE = 1 << 0; // called 'butt' in the svg spec
const ROUND = 1 << 1;
const PROJECT = 1 << 2; // called 'square' in the svg spec
const MITER = 1 << 3;
const BEVEL = 1 << 5;

// lighting

const AMBIENT = 0;
const DIRECTIONAL = 1;
// const  POINT  = 2;  // shared with shape feature
const SPOT = 3;

// key constants

// only including the most-used of these guys
// if people need more esoteric keys, they can learn about
// the esoteric java KeyEvent api and of virtual keys

// both key and keyCode will equal these values
// for 0125, these were changed to 'char' values, because they
// can be upgraded to ints automatically by Java, but having them
// as ints prevented split(blah, TAB) from working
const int BACKSPACE = 8;
const int TAB = 9;
const int ENTER = 10;
const int RETURN = 13;
const int ESC = 27;
const int DELETE = 127;

// i.e. if ((key == CODED) && (keyCode == UP))
const CODED = 0xffff;

// TODO define key events
// key will be CODED and keyCode will be this value
//  const UP = KeyEvent.VK_UP;
//  const DOWN = KeyEvent.VK_DOWN;
//  const LEFT = KeyEvent.VK_LEFT;
//  const RIGHT = KeyEvent.VK_RIGHT;

// // key will be CODED and keyCode will be this value
//  const ALT = KeyEvent.VK_ALT;
//  const CONTROL = KeyEvent.VK_CONTROL;
//  const SHIFT = KeyEvent.VK_SHIFT;

// orientations (only used on Android, ignored on desktop)

/// Screen orientation constant for portrait (the hamburger way). */
const PORTRAIT = 1;

/// Screen orientation constant for landscape (the hot dog way). */
const LANDSCAPE = 2;

/// Use with fullScreen() to indicate all available displays. */
const SPAN = 0;

// cursor types
// TODO define cursor events
//  const ARROW = Cursor.DEFAULT_CURSOR;
//  const CROSS = Cursor.CROSSHAIR_CURSOR;
//  const HAND = Cursor.HAND_CURSOR;
//  const MOVE = Cursor.MOVE_CURSOR;
//  const TEXT = Cursor.TEXT_CURSOR;
//  const WAIT = Cursor.WAIT_CURSOR;

const DISABLE_DEPTH_TEST = 2;
const ENABLE_DEPTH_TEST = -2;

const ENABLE_DEPTH_SORT = 3;
const DISABLE_DEPTH_SORT = -3;

const DISABLE_OPENGL_ERRORS = 4;
const ENABLE_OPENGL_ERRORS = -4;

const DISABLE_DEPTH_MASK = 5;
const ENABLE_DEPTH_MASK = -5;

const DISABLE_OPTIMIZED_STROKE = 6;
const ENABLE_OPTIMIZED_STROKE = -6;

const ENABLE_STROKE_PERSPECTIVE = 7;
const DISABLE_STROKE_PERSPECTIVE = -7;

const DISABLE_TEXTURE_MIPMAPS = 8;
const ENABLE_TEXTURE_MIPMAPS = -8;

const ENABLE_STROKE_PURE = 9;
const DISABLE_STROKE_PURE = -9;

const ENABLE_BUFFER_READING = 10;
const DISABLE_BUFFER_READING = -10;

const DISABLE_KEY_REPEAT = 11;
const ENABLE_KEY_REPEAT = -11;

const DISABLE_ASYNC_SAVEFRAME = 12;
const ENABLE_ASYNC_SAVEFRAME = -12;

const HINT_COUNT = 13;

const SINCOS_PRECISION = 0.5;
const SINCOS_LENGTH = 360 ~/ SINCOS_PRECISION;

const PERLIN_YWRAPB = 4;
const PERLIN_YWRAP = 1 << PERLIN_YWRAPB;
const PERLIN_ZWRAPB = 8;
const PERLIN_ZWRAP = 1 << PERLIN_ZWRAPB;
const PERLIN_SIZE = 4095;
