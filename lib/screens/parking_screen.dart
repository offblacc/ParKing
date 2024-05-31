import 'package:flutter/material.dart';
import 'package:parking/models/parking_location.dart';
import 'package:parking/screens/parking_layout_screen.dart';

class ParkingScreen extends StatelessWidget {
  final ParkingLocation parkingLocation;

  ParkingScreen({required this.parkingLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              parkingLocation.name,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Address:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              parkingLocation.address,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            // button with text "show layout"
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ParkingLayoutScreen(
                          parkingLocation: parkingLocation,
                        );
                      },
                    ),
                  );
                },
                child: const Text('Show Layout'),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
