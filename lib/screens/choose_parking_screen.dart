import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ParkingLocation {
  final String name;
  final String address;
  final String redova;
  final String stupaca;

  ParkingLocation({
    required this.name,
    required this.address,
    required this.redova,
    required this.stupaca,
  });
}

class ChooseParkingScreen extends StatefulWidget {
  @override
  _ChooseParkingScreenState createState() => _ChooseParkingScreenState();
}

class _ChooseParkingScreenState extends State<ChooseParkingScreen> {
  final DatabaseReference _parkingRef = FirebaseDatabase.instance.ref('parkingLocations');
  List<ParkingLocation> parkingLocations = [];

  @override
  void initState() {
    super.initState();
    _fetchParkingLocations();
  }


  Future<void> _fetchParkingLocations() async {
    print("Fetching parking locations started");
    DatabaseEvent event = await _parkingRef.once().timeout(Duration(seconds: 10));
    print(event.snapshot.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Parking Location'),
      ),
      body: parkingLocations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: parkingLocations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(parkingLocations[index].name),
            subtitle: Text(parkingLocations[index].address),
            onTap: () {
              _navigateToParkingDetails(context, parkingLocations[index]);
            },
          );
        },
      ),
    );
  }

  void _navigateToParkingDetails(BuildContext context, ParkingLocation location) {
    // TODO implement navigation to parking details screen here
  }
}
