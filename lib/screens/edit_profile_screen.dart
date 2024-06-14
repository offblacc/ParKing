import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  String _userName = "";
  String _profilePictureUrl = "";
  User? user = FirebaseAuth.instance.currentUser;
  File? chosenPicture;

  @override
  void initState() {
    super.initState();
    _userName = user?.displayName ?? "";
    _profilePictureUrl = user?.photoURL ?? "";
  }

  Future<void> _saveChanges() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      await user.updateDisplayName(_userName);
      await user.updatePhotoURL(_profilePictureUrl);

       // Close screen
    } else {
      // Handle error - no signed-in user
    }
  }
}

Future<String?> uploadImageToFirebase(File imageFile) async {
  final storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return null; // Handle case where user is not signed ina
  }

  final reference = storage.ref().child('images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // Username field
                TextFormField(
                  initialValue: _userName,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _userName = value!),
                ),


                // Photo URL field
                TextFormField(
                  initialValue: _profilePictureUrl,
                  decoration: InputDecoration(labelText: 'PhotoURL'),
                  onSaved: (value) => setState(() => _profilePictureUrl= value!),
                ),

                SizedBox(height: 20.0),

                //Choose image button
                ElevatedButton(
                  onPressed: () async {
                    chosenPicture = await pickImageFromGallery();

                    final downloadUrl = uploadImageToFirebase(chosenPicture!);
                    
                    _profilePictureUrl = (await downloadUrl)!;
                    
                    
                  },
                  child: Text('Choose picture from gallery'),
                ),

                // Save button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Implement logic to save changes (e.g., update data)

                      _saveChanges();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}