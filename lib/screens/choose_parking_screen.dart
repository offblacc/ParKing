import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/parking_screen.dart';
import 'package:parking/models/parking_location.dart';

class ChooseParkingScreen extends StatefulWidget {
  @override
  _ChooseParkingScreenState createState() => _ChooseParkingScreenState();
}

class _ChooseParkingScreenState extends State<ChooseParkingScreen> {
  final DatabaseReference _parkingRef =
      FirebaseDatabase.instance.ref().child('parkingLocations');
  List<ParkingLocation> parkingLocations = [];
  bool hasWritePermission = false;

  @override
  void initState() {
    super.initState();
    _fetchParkingLocations();
    _checkUserRootStatus();
  }

  Future<void> _fetchParkingLocations() async {
    Map<int, Map<String, String>> locationsMap = <int, Map<String, String>>{};
    print("Fetching parking locations started");
    DatabaseEvent event = await _parkingRef.once(DatabaseEventType.value);
    print("Fetching parking locations completed");

    int i = 0;
    for (var child in event.snapshot.children) {
      String childKey = child.key?.toString() ?? '';
      final childRef = _parkingRef.child(childKey);
      Map<String, String> childValue = <String, String>{};

      // jako sloppy napisano, neda mi se.. u biti child je svaki parking a childchild su propertiji unutar childa dakle od parkinga konkretnog...
      DatabaseEvent childEvent = await childRef.once(DatabaseEventType.value);
      for (var childChild in childEvent.snapshot.children) {
        String childChildKey = childChild.key?.toString() ?? '';
        String childChildValue = childChild.value?.toString() ?? '';
        childValue[childChildKey] = childChildValue;
      }

      locationsMap[i++] = childValue;
    }

    print("Locations map: $locationsMap");
    for (int i = 0; i < locationsMap.length; i++) {
      Map<String, String> locationMap = locationsMap[i]??{};
      ParkingLocation location = ParkingLocation(
        id: '0',
        name: locationMap['name'] ?? '',
        address: locationMap['address'] ?? '',
        stupaca: locationMap['stupaca'] ?? '0',
        redova: locationMap['redova'] ?? '0',
      );
      parkingLocations.add(location);
    }

    setState(() {
      //parkingLocations = parkingLocations;
    });
    return;
  }

  Future<void> _checkUserRootStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    } // redundant, has to be logged in, but let's keep this here...

    final currentUserDbRef = FirebaseDatabase.instance.ref().child('writePermissionUsers/${user.uid}');
    final DatabaseEvent event = await currentUserDbRef.once(DatabaseEventType.value);
    hasWritePermission = event.snapshot.value == true;
    print("Has write permission: $hasWritePermission");
    setState(() {
      hasWritePermission = hasWritePermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Parking Location'),
      ),
      body: parkingLocations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parkingLocations.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(parkingLocations[index].name),
                    subtitle: Text(parkingLocations[index].address ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ParkingScreen(
                            parkingLocation: parkingLocations[index],
                          );
                        }),
                      );
                    });
              },
            ),
      floatingActionButton: hasWritePermission ? FloatingActionButton(
        onPressed: () {
          // go to screen AddParkingScreen
          Navigator.pushNamed(context, '/addParking'); // TODO modify all Navigator.push* to use Named routes ! will be better
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
