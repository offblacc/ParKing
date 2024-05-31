import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('userCount');
  int userCount = 0;

  @override
  void initState() {
    super.initState();
    _dbRef.onValue.listen((event) {
      setState(() {
        userCount = int.parse(event.snapshot.value.toString());
        print("Updated user count: $userCount");
      });
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
                  child: Center(
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
                  leading: Icon(Icons.inbox),
                  title: Text('Parkirališta'),
                  onTap: () {
                    // go to screen ChooseParkingScreen
                    Navigator.pushNamed(context, '/chooseParking');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.inbox),
                  title: Text('Moji podaci'),
                  onTap: () {
                    // Handle the onTap here, if necessary
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to the Home Screen!'),
            Text('User Count: $userCount'),
          ],
        ),
      ),
    );
  }
}
