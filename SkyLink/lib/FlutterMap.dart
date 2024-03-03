import 'package:flutter/material.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Beacon> beacons = [
    Beacon(id: 'A', x: 50, y: 80, distance: 50),
    Beacon(id: 'B', x: 350, y: 80, distance: 70),
    Beacon(id: 'C', x: 200, y: 700, distance: 70),
  ];
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GestureDetector(
        onTapDown: (details) {
          setState(() {
            position = calculateCurrentPosition(details.localPosition);
          });
        },
        child: CustomPaint(
          foregroundPainter: MapPainter(beacons: beacons, position: position),
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
    List<Beacon> availableBeacons = beacons.where((beacon) => beacon.distance != null).toList();
    if (availableBeacons.length < 3) {
      return null; // Not enough beacons to perform trilateration
    }

    List<Point> points = availableBeacons.map((beacon) => Point(beacon.x, beacon.y)).toList();
    List<double> distances = availableBeacons.map((beacons) => beacons.distance!).toList();

    // Perform trilateration calculation
    Position? estimatedPosition = trilaterate(points, distances);

    if (estimatedPosition != null) {
      double estimatedX = estimatedPosition.x;
      double estimatedY = estimatedPosition.y;
      return Position(x: estimatedX, y: estimatedY);
    }

    return null; // Trilateration failed
  }

  Position? trilaterate(List<Point> points, List<double> distance) {
    if (points.length < 3 || points.length != distance.length) {
      return null;
    }

    // Get the coordinates of the three beacons
    Beacon p1 = beacons[0];
    Beacon p2 = beacons[1];
    Beacon p3 = beacons[2];

    // Get the distances between the current position and the three beacons
    double r1 = 25;
    double r2 = 50;
    double r3 = 70;

    // Calculate the differences between the beacon coordinates
    double p2p1x = p2.x - p1.x.toDouble();
    double p2p1y = p2.y - p1.y.toDouble();
    double p3p1x = p3.x - p1.x.toDouble();
    double p3p1y = p3.y - p1.y.toDouble();

    // Calculate the distance between the first two beacons
    double d = pow(p2p1x, 2) + pow(p2p1y, 2).toDouble();
    double i = sqrt(d);

    // Calculate the unit vectors
    double ex = p2p1x / i;
    double ey = p2p1y / i;
    double p3p1 = p3p1x * ex + p3p1y * ey;

    // Calculate the coordinates of the estimated position
    double x = (pow(r1, 2) - pow(r2, 2) + pow(i, 2)) / (2 * i);
    double y = (pow(r1, 2) - pow(r3, 2) + pow(p3p1, 2) + pow(p3p1x, 2) + pow(p3p1y, 2)) / (2 * p3p1) - (p3p1x / p3p1) * x;

    // Calculate the estimated position
    double estimatedX = p1.x + ex * x + ey * y;
    double estimatedY = p1.y + ey * x - ex * y;

    return Position(x: estimatedX, y: estimatedY);
  }
}

class Beacon {
  final String id;
  final double x;
  final double y;
  final double? distance;

  Beacon({required this.id, required this.x, required this.y, this.distance});
}

class Position {
  final double x;
  final double y;

  Position({required this.x, required this.y});
}

class MapPainter extends CustomPainter {
  final List<Beacon> beacons;
  final Position? position;

  MapPainter({required this.beacons, required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint beaconPaint = Paint()..color = Colors.blue;
    final Paint currentPositionPaint = Paint()..color = Colors.red;

    // Draw beacons
    for (Beacon beacon in beacons) {
      canvas.drawCircle(Offset(beacon.x, beacon.y), 8.0, beaconPaint);
    }

    // Draw current position
    if (Position != null) {
      canvas.drawCircle(Offset(position!.x, position!.y), 10.0, currentPositionPaint);
    }
  }

  @override
  bool shouldRepaint(MapPainter oldDelegate) {
    return oldDelegate.beacons != beacons || oldDelegate.position != Position;
  }
}
