import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewParkingScreen extends StatefulWidget {
  @override
  _NewParkingScreenState createState() => _NewParkingScreenState();
}

class _NewParkingScreenState extends State<NewParkingScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  TextEditingController addressController = TextEditingController();
  TextEditingController mjestaController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController redovaController = TextEditingController();
  TextEditingController stupacaController = TextEditingController();

  void addParkingInfo() {
    DatabaseReference newParkingRef = databaseReference.child('parkingLocations').push();

    Map<String, dynamic> newData = {
      'address': addressController.text,
      'mjesta': mjestaController.text,
      'name': nameController.text,
      'redova': redovaController.text,
      'stupaca': stupacaController.text,
    };

    newParkingRef.set(newData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parking information added successfully')));
      // Clear text fields after adding
      addressController.clear();
      mjestaController.clear();
      nameController.clear();
      redovaController.clear();
      stupacaController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add parking info')));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Parking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: mjestaController,
              decoration: const InputDecoration(labelText: 'Mjesta'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: redovaController,
              decoration: const InputDecoration(labelText: 'Redova'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: stupacaController,
              decoration: const InputDecoration(labelText: 'Stupaca'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    mjestaController.text.isEmpty ||
                    redovaController.text.isEmpty ||
                    stupacaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill all fields')));
                  return;
                }
                addParkingInfo();
              },
              child: const Text('Add Parking Info'),
            ),
          ],
        ),
      ),
    );
  }
}
