import 'package:flutter/material.dart';
import 'package:parking/models/parking_location.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;


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

class ParkingLayoutScreen extends StatefulWidget {
  final ParkingLocation parkingLocation;

  const ParkingLayoutScreen({required this.parkingLocation});

  @override
  _ParkingLayoutScreenState createState() => _ParkingLayoutScreenState();
}

class _ParkingLayoutScreenState extends State<ParkingLayoutScreen> {
  // Add a state variable to store occupied coordinates (initially empty)
  List<Coordinate> _occupied = [];
  final thingsBoardApiEndpoint = 'http://161.53.19.19:45080';
  // Fetch data from Thingsboard in initState (replace with your actual logic)

  Future<List<Coordinate>> _getThingsboardDevices() async {
    List<Coordinate> occupied = [];

    var apiPoint = "/api/device/";

    var deviceID = "5b42af90-28ea-11ef-a963-a37ba3a57ce2";


    final dio = Dio();
    final response = await dio.get(thingsBoardApiEndpoint + apiPoint + deviceID);
    if (response.statusCode == 200) {
      //return response.data;
      return occupied; // Response data contains the parsed object
    } else {
      throw Exception('Failed to load data'); // Handle errors
    }
    

  }

  @override
  void initState() {
    super.initState();
    // Your logic to fetch occupied coordinates from Thingsboard
    // (might involve async operations, potentially update state using setState)
    //ispuniti occupied listu 
    _getThingsboardDevices().then((occupied) => setState(() => _occupied = occupied));
    
  }

  @override
  Widget build(BuildContext context) {
    int redova = int.parse(widget.parkingLocation.redova);
    int stupaca = int.parse(widget.parkingLocation.stupaca);
    double squareSize = MediaQuery.of(context).size.width / stupaca * 0.6;

    List<Widget> rows = [];
    for (int i = 0; i < redova; i++) {
      List<Widget> squares = [];
      for (int j = 0; j < stupaca; j++) {
        bool isVisibleSquare = i % 2 == 0;
        var color = !_occupied.contains(Coordinate(x: i, y: j))
            ? Colors.green
            : Colors.red;
        squares.add(
          Container(
            width: squareSize,
            height: squareSize,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isVisibleSquare ? color : Colors.transparent,
              border: Border.all(color: isVisibleSquare ? color : Colors.transparent),
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
      if (i < redova - 1) {
        rows.add(const SizedBox(height: 8));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Layout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: rows,
          ),
        ),
      ),
    );
  }
}