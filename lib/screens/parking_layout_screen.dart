import 'package:flutter/material.dart';
import 'package:parking/models/parking_location.dart';

class Coordinate {
  final int x;
  final int y;

  Coordinate({required this.x, required this.y});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Coordinate &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class ParkingLayoutScreen extends StatelessWidget {
  final ParkingLocation parkingLocation;

  ParkingLayoutScreen({required this.parkingLocation});

  @override
  Widget build(BuildContext context) {
    // Extracting redova and stupaca values
    int redova = int.parse(parkingLocation.redova);
    int stupaca = int.parse(parkingLocation.stupaca);
    List<Coordinate> occupied = [];

    // Calculate the size of each square dynamically based on available width and number of columns
    double squareSize = MediaQuery.of(context).size.width / stupaca * 0.6;

    // Generating rows with green or red squares
    List<Widget> rows = [];
    for (int i = 0; i < redova; i++) {
      bool isRow = i % 2 == 0;
      List<Widget> squares = [];
      for (int j = 0; j < stupaca; j++) {
        bool isVisibleSquare = i % 2 == 0;
        var color = !occupied.contains(Coordinate(x: i, y: j))
            ? Colors.green
            : Colors.red;
        squares.add(
          Container(
            width: squareSize,
            height: squareSize,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isVisibleSquare ? color : Colors.transparent,
              border:
              Border.all(color: isVisibleSquare ? color : Colors.transparent),
            ),
          ),
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: squares,
        ),
      );
      // Add invisible rows in between
      if (i < redova - 1) {
        rows.add(SizedBox(height: 8));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Layout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: rows,
          ),
        ),
      ),
    );
  }
}
