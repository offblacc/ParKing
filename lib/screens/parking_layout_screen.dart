

import 'package:flutter/material.dart';
import 'package:parking/models/parking_location.dart';
import 'package:dio/dio.dart';



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
  List<String> deviceIDs = ["9bdfc600-299e-11ef-a963-a37ba3a57ce2", "e28a5ca0-296c-11ef-a963-a37ba3a57ce2", "5b42af90-28ea-11ef-a963-a37ba3a57ce2", "035e8570-24ed-11ef-a963-a37ba3a57ce2"];
  String JWNToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJib3JuYS5tYWplcmljQGZlci5ociIsInVzZXJJZCI6ImVhNWM3Y2MwLTE3NWEtMTFlZi1hOTYzLWEzN2JhM2E1N2NlMiIsInNjb3BlcyI6WyJURU5BTlRfQURNSU4iXSwic2Vzc2lvbklkIjoiZjMwMzI4ZjYtM2RjMy00YjI2LThiZmItZjRkMTdhYTdkMmFjIiwiaXNzIjoidGhpbmdzYm9hcmQuaW8iLCJpYXQiOjE3MTgzMTQxMDUsImV4cCI6MTcxODMyMzEwNSwiZmlyc3ROYW1lIjoiQm9ybmEgIiwibGFzdE5hbWUiOiJNYWplcmnEhyIsImVuYWJsZWQiOnRydWUsImlzUHVibGljIjpmYWxzZSwidGVuYW50SWQiOiJkNDcwOWMyMC0xNzVhLTExZWYtYTk2My1hMzdiYTNhNTdjZTIiLCJjdXN0b21lcklkIjoiMTM4MTQwMDAtMWRkMi0xMWIyLTgwODAtODA4MDgwODA4MDgwIn0.o2cIP0IhxWFFBZhcckka2kMdx0tWNMNZ1GiA944Aj71_I2JzLa7yjbnapNGGei7VtgjTQ1L21OQNKrJS6ij94A";
  String apiTelemetryStart = "/api/plugins/telemetry/DEVICE/";
  String apiTelemetryEnd = "/values/timeseries";
  // Fetch data from Thingsboard in initState (replace with your actual logic)

  Future<List<Coordinate>> _getThingsboardDevices() async {
    List<Coordinate> occupied = [];
    List<Map<String, dynamic>> JSONDecodedData = [];

    var apiPoint = "/api/device/";

    var deviceID = "5b42af90-28ea-11ef-a963-a37ba3a57ce2";


    final dio = Dio();

    //dio.options.headers["Authorization"] = JWNToken;

    for (String deviceID in deviceIDs) {

      //dohvati podatke
      debugPrint(thingsBoardApiEndpoint + apiTelemetryStart + deviceID + apiTelemetryEnd);
      final response = await dio.get(thingsBoardApiEndpoint + apiTelemetryStart + deviceID + apiTelemetryEnd, 
            options: Options(headers: {
            "Authorization": "Bearer " + JWNToken,
            'Content-Type': 'application/json',
          }));

      if (response.statusCode == 200) {

    
        

        JSONDecodedData.add(response.data);

      } else {
        throw Exception('Failed to load data'); // Handle errors
      }

    }

    //Izracunaj polja koja su crvena ili zelena
    int brojac = 0; //brojac za mjesta
    for (Map<String, dynamic> response in JSONDecodedData) {

      //provjeri jel isParked == 1 i ako da stavi u occupied koordinate 1, brojac

      if (response["isParked"] != null) {
        debugPrint(response["isParked"].toString());
        debugPrint(response["isParked"][0]["value"].toString());
        if (response["isParked"][0]["value"] == "1") {
          Coordinate koordinata = Coordinate(x: 0, y: brojac);
          occupied.add(koordinata);

        }

      }

      brojac += 1;

    }

    
    return occupied;
    
    
    

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