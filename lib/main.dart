import 'package:flutter/material.dart';
import 'package:p5_flutter/p5_flutter.dart';
import 'package:p5_flutter/pconstants.dart';

void main() {
  runApp(MyApp());
}

class MySketch extends PApplet {
  @override
  void setup() {
    noFill();
    noLoop();
  }

  @override
  void draw() {
    strokeWeight(1); // Default
    line(20, 20, 80, 20);
    strokeWeight(4); // Thicker
    line(20, 40, 80, 40);
    strokeWeight(10); // Beastly
    line(20, 70, 80, 70);
  }

  void drawCurves(double y) {
    curve(5, 28 + y, 5, 28 + y, 73, 26 + y, 73, 63 + y);
    curve(5, 28 + y, 73, 26 + y, 73, 63 + y, 15, 67 + y);
    curve(73, 26 + y, 73, 63 + y, 15, 67 + y, 15, 67 + y);
  }

  @override
  mouseReleased() {}
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: P5Widget(
        create: () => MySketch(),
      ),
    );
  }
}
