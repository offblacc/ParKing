import 'package:flutter/material.dart';
import 'package:parking/models/parking_location.dart';
import 'package:parking/screens/parking_layout_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ParkingScreen extends StatelessWidget {
  final ParkingLocation parkingLocation;
  
  ParkingScreen({required this.parkingLocation});

  bool hasWritePermission = true;

  Future<void> _checkUserRootStatus({bool rebuild = true}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    } // redundant, has to be logged in, but let's keep this here...

    final currentUserDbRef = FirebaseDatabase.instance
        .ref()
        .child('writePermissionUsers/${user.uid}');
    final DatabaseEvent event =
        await currentUserDbRef.once(DatabaseEventType.value);
    hasWritePermission = event.snapshot.value == true;

  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
  final storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return null; // Handle case where user is not signed ina
  }
  
  final reference = storage.ref().child('images/${parkingLocation.name}/${DateTime.now().millisecondsSinceEpoch}.jpg');

  try {
    await reference.putFile(imageFile);
    final downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  } catch (error) {
    print('Error uploading image: $error');
    return null;
  }
}

Future<bool> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isGranted) {
    return true;
  } else {
    // Request permission if not granted
    var result = await Permission.storage.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}

Future<File?> pickImageFromGallery() async {
  
  requestStoragePermission();
  final ImagePicker imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

  @override
  Widget build(BuildContext context) {
    File? chosenPicture;

    _checkUserRootStatus();  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

            Center(
              child: hasWritePermission
              ? ElevatedButton(
                onPressed:  () async {
                  //promptaj za biranje iz galerije
                  chosenPicture = await pickImageFromGallery();

                  uploadImageToFirebase(chosenPicture!);
                },
                child: const Text('Add parking picture'),
              )
              : null,
            ),


          ],
        ),
      ),
    );
  }
}
