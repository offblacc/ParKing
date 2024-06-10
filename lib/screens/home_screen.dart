import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('userCount');
  int userCount = 0;
  late final User user;

  @override
  void initState() {
    super.initState();
    _dbRef.onValue.listen((event) {
      setState(() {
        userCount = int.parse(event.snapshot.value.toString());
        
      });
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Container(
                  height: 100, // Adjust the height as needed
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'ParKing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.local_parking),
                  title: const Text('Choose Parking Location'),
                  onTap: () {
                    // go to screen ChooseParkingScreen
                    Navigator.pushNamed(context, '/chooseParking');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Moji podaci'),
                  onTap: () {
                    // Handle the onTap here, if necessary
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome to ParKing!',
              style: TextStyle(
                fontSize: 30, // adjust the size as needed
                fontWeight: FontWeight.bold, // make the text bold
                color: Colors.blue, // change the color of the text
              ),
            ),
            const SizedBox(height: 20), // Add space between welcome message and buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chooseParking');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.grey, // Add shadow color
                elevation: 2, // Add elevation
              ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_parking), // Add an icon to the left of the text
                    SizedBox(width: 10), // Add space between icon and text
                    Text(
                      'Parking List',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
            ),
            const SizedBox(height: 20), // Add space between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to user profile screen or handle the action as needed
                Navigator.pushNamed(context, '/myProfile');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.grey,
                elevation: 2,
              ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person), // Add an icon to the left of the text
                    SizedBox(width: 10), // Add space between icon and text
                    Text(
                      'My profile',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}