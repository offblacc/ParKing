import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  String _userName = "";
  String _profilePictureUrl = "";
  User? user = FirebaseAuth.instance.currentUser;

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