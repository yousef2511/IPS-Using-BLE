import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Beacon> beacons = [
    Beacon(num: 0, x: 50, y: 80, distance: 100),
    Beacon(num: 1, x: 350, y: 80, distance: 50),
    Beacon(num: 2, x: 200, y: 700, distance: 300),
  ];
  Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GestureDetector(
        onTapDown: (details) {
          setState(() {
            currentPosition = calculateCurrentPosition(details.localPosition);
          });
        },
        child: CustomPaint(
          foregroundPainter: MapPainter(
              beacons: beacons, currentPosition: currentPosition),
          child: Container(
            // Set the background image path here
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/section.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Position? calculateCurrentPosition(Offset tapPosition) {
    List<Beacon> availableBeacons = beacons.where((beacon) =>
    beacon.distance != null).toList();
    if (availableBeacons.length < 3) {
      return null; // Not enough beacons to perform trilateration
    }

    double x1 = beacons[0].x;
    double y1 = beacons[0].y;
    double x2 = beacons[1].x;
    double y2 = beacons[1].y;
    double x3 = beacons[2].x;
    double y3 = beacons[2].y;

    double d1 = beacons[0].distance!;
    double d2 = beacons[1].distance!;
    double d3 = beacons[2].distance!;

    double A = x2 - x1;
    double B = y2 - y1;
    double C = x3 - x1;
    double D = y3 - y1;
    double E = ((d1 * d1) - (d2 * d2) - (x1 * x1) + (x2 * x2) - (y1 * y1) + (y2 * y2));
    double F = ((d1 * d1) - (d3 * d3) - (x1 * x1) + (x3 * x3) - (y1 * y1) + (y3 * y3));

    double denominator = (2 * ((A * D) - (B * C)));
    double x = ((D * E) - (B * F)) / denominator;
    double y = ((A * F) - (C * E)) / denominator;

    if (x < 0 || x > MediaQuery.of(context).size.width ||
        y < 0 || y > MediaQuery.of(context).size.height) {
      return null; // The calculated position is out of bounds
    }

    return Position(x: x, y: y);
  }


}

class Beacon {
  final int num;
  final double x;
  final double y;
  final double? distance;

  Beacon({required this.num, required this.x, required this.y, this.distance});
}

class Position {
  final double x;
  final double y;

  Position({required this.x, required this.y});
}

class MapPainter extends CustomPainter {
  final List<Beacon> beacons;
  final Position? currentPosition;

  MapPainter({required this.beacons, required this.currentPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint beaconPaint = Paint()..color = Colors.blue;
    final Paint currentPositionPaint = Paint()..color = Colors.red;

    // Draw beacons
    for (Beacon beacon in beacons) {
      canvas.drawCircle(Offset(beacon.x, beacon.y), 8.0, beaconPaint);
    }

    // Draw current position
    if (currentPosition != null) {
      canvas.drawCircle(Offset(currentPosition!.x, currentPosition!.y), 10.0, currentPositionPaint);
    }
  }

  @override
  bool shouldRepaint(MapPainter oldDelegate) {
    return oldDelegate.beacons != beacons || oldDelegate.currentPosition != currentPosition;
  }
}
