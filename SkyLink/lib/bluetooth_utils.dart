// trilateration.dart
import 'dart:html';

import 'package:f2/FlutterMap.dart';
import 'dart:math';
import 'package:f2/newB.dart';

class Trilateration {
  List<Point> beacons;
  List<double> _dis;


  Trilateration(List<Point> beacons)
      : beacons = beacons,


  Point calculatePosition() {
    if (beacons.length < 3 || beacons.length != _distances.length) {
      throw Exception("Invalid input data");
    }

    // Calculate the intersection point of three circles
    double x1 = beacons[0].x;
    double y1 = beacons[0].y;
    double r1 = _distances[0];

    double x2 = beacons[1].x;
    double y2 = beacons[1].y;
    double r2 = _distances[1];

    double x3 = beacons[2].x;
    double y3 = beacons[2].y;
    double r3 = _distances[2];

    double A = 2 * x2 - 2 * x1;
    double B = 2 * y2 - 2 * y1;
    double C = r1 * r1 - r2 * r2 - x1 * x1 + x2 * x2 - y1 * y1 + y2 * y2;
    double D = 2 * x3 - 2 * x2;
    double E = 2 * y3 - 2 * y2;
    double F = r2 * r2 - r3 * r3 - x2 * x2 + x3 * x3 - y2 * y2 + y3 * y3;

    double x = (C * E - F * B) / (E * A - B * D);
    double y = (C * D - A * F) / (B * D - A * E);

    return Point(x, y);
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}
