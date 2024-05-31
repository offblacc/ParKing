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
  final DatabaseReference _parkingRef =
      FirebaseDatabase.instance.ref().child('parkingLocations');
  Map<int, Map<String, String>> parkingLocations = <int, Map<String, String>>{};
  var parkingIds = <int>[];

  @override
  void initState() {
    super.initState();
    _fetchParkingLocations();
  }

  Future<void> _fetchParkingLocations() async {
    print("Fetching parking locations started");
    DatabaseEvent event = await _parkingRef.once(DatabaseEventType.value);
    print("Fetching parking locations completed");

    int i = 0;
    for (var child in event.snapshot.children) {
      String childKey = child.key?.toString() ?? '';
      final childRef = _parkingRef.child(childKey);
      Map<String, String> childValue = <String, String>{};

      // jako sloppy napisano, neda mi se.. u biti child je svaki parking a childchild su propertiji unutar childa dakle od parkinga...
      DatabaseEvent childEvent = await childRef.once(DatabaseEventType.value);
      for (var childChild in childEvent.snapshot.children) {
        String childChildKey = childChild.key?.toString() ?? '';
        String childChildValue = childChild.value?.toString() ?? '';
        childValue[childChildKey] = childChildValue;
      }

      parkingLocations[i++] = childValue;
    }
    parkingIds = parkingLocations.keys.toList();
    print(parkingIds);
    setState(() {
      parkingLocations = parkingLocations;
    });
    return;
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
                    title: Text(parkingLocations[index]!['name'] ?? ''),
                    subtitle: Text(parkingLocations[index]!['address'] ?? ''),
                    onTap: () {
                      // TODO implement _navigateToParkingDetails(context, parkingLocations[index]);
                    },
                  );
                },
              ),
        );
  }

  void _navigateToParkingDetails(
      BuildContext context, ParkingLocation location) {
    // TODO implement navigation to parking details screen here
  }
}
