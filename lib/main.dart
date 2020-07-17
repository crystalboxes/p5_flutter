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
    textSize(32);
    text("word", 10, 30);
    fill(0, 102, 153);
    text("word", 10, 60);
    fill(0, 102, 153, 51);
    text("word", 10, 90);
  }

  void drawCurves(double y) {
    curve(5, 28 + y, 5, 28 + y, 73, 26 + y, 73, 63 + y);
    curve(5, 28 + y, 73, 26 + y, 73, 63 + y, 15, 67 + y);
    curve(73, 26 + y, 73, 63 + y, 15, 67 + y, 15, 67 + y);
  }

  @override
  mouseReleased() {
    var c = color(255, 204, 0);
    println(c.value.toString()); // Prints "-13312"
    println(binary(c.value)); // Prints "11111111111111111100110000000000"
    println(binary(c.value, 16)); // Prints "1100110000000000"
  }
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
