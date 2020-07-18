import 'package:flutter/material.dart';
import 'package:p5_flutter/p5_flutter.dart';
import 'package:p5_flutter/pconstants.dart';

import 'pvector.dart';

void main() {
  runApp(MyApp());
}

class Dot {
  PVector pos;
  PVector prev;
  Color color;
  int deadCount;
  double radius;
  List<int> colorRange;
  int alpha;
  int brightness;
  PApplet p;

  PVector v;

  Dot(PApplet applet, radius, colorRange, brightness, alpha) {
    p = applet;
    var r = p.random(TWO_PI);
    var x = p.width / 2 + p.sin(r) * radius;
    var y = p.height / 2 + p.cos(r) * radius;
    this.pos = p.createVector(x, y);
    this.prev = p.createVector(x, y);
    this.color = p.color(255);
    this.deadCount = 0;
    this.radius = radius;
    this.colorRange = colorRange;
    this.alpha = alpha;
    this.brightness = brightness;
  }

  update(noize) {
    v = PVector.fromAngle(noize * TWO_PI + (this.deadCount * PI));
    v.setMag(2);
    color = p.color(p.map(noize, 0, 1, colorRange[0], colorRange[1]).toInt(),
        100, this.brightness, this.alpha);
    this.prev = this.pos.copy();
    this.pos = this.pos.add(this.v);

    if (p.dist(p.width / 2, p.height / 2, this.pos.x, this.pos.y) >
        this.radius + 2) {
      this.deadCount += 1;
    }
  }

  draw() {
    if (p.dist(p.width / 2, p.height / 2, this.pos.x, this.pos.y) >
            this.radius ||
        p.dist(p.width / 2, p.height / 2, this.prev.x, this.prev.y) >
            this.radius) {
      return;
    }

    p.strokeWeight(1);
    p.stroke(this.color);
    p.line(this.prev.x, this.prev.y, this.pos.x, this.pos.y);
  }
}

class MySketch extends PApplet {
  final dots = [];
  final factor = 0.008;
  final count = 500;
  final size = 500;
  final radius = 500 * 0.8 / 2;

  @override
  void setup() {
    // noFill();
    // noLoop();

    // createCanvas(size, size);
    background(255);
    noiseDetail(2);
    colorMode(HSB, 100);
    strokeWeight(2);
    stroke(0);
    noFill();
    ellipse(width / 2, height / 2, radius * 2 + 1);

    for (var i = 0; i < count; i++) {
      dots.add(Dot(this, radius, [60, 80], 20, 5));
    }
  }

  @override
  void draw() {
    for (var i = 0; i < dots.length; i++) {
      final dot = dots[i];
      var n = noise(dot.pos.x * factor, dot.pos.y * factor);
      dot.update(n);
      dot.draw();
    }
  }

  @override
  bool clearOnBeginFrame() {
    return false;
  }

  void drawCurves(double y) {
    curve(5, 28 + y, 5, 28 + y, 73, 26 + y, 73, 63 + y);
    curve(5, 28 + y, 73, 26 + y, 73, 63 + y, 15, 67 + y);
    curve(73, 26 + y, 73, 63 + y, 15, 67 + y, 15, 67 + y);
  }
}

// class MySketch extends PApplet {
//   @override
//   bool clearOnBeginFrame() {
//     return false;
//   }

//   @override
//   mouseDragged() {
//     // TODO: implement mouseDragged
//     circle(mouseX, mouseY, 50);
//   }
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: P5Widget(
        create: () => MySketch(),
      ),
    );
  }
}
