import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';




class MyProfileScreen extends StatefulWidget {
  late final User? userData; // Map to hold user data


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MyProfileScreen> {

  Widget getAvatar(User user) {
  if (user.photoURL != null) {
    return CircleAvatar(
      backgroundImage: NetworkImage(user.photoURL!),
      radius: 50.0,
    );
  } else {
    return CircleAvatar(
      backgroundColor: Colors.grey[200], // Default background color
      radius: 50.0,
    );
  }
}



  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Profile picture section
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: getAvatar(user!),
              ),
              const SizedBox(height: 20.0),
          
              // User information section
              Text(
                "Username: ${user.displayName ?? "No username"}",
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Text("E-mail: ${user.email ?? "No e-mail"}"),
              const SizedBox(height: 20.0),
              Text("Verified: ${user.emailVerified.toString() ?? "False"}"),
              const SizedBox(height: 20.0),

              // Edit profile button (optional)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/editProfile'); 
                }, 
                  
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}