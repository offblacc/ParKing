import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (input) => _email = input!,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              validator: (input) {
                if (input == null || input.length < 6) {
                  return 'Please enter a password with at least 6 characters';
                }
                return null;
              },
              onSaved: (input) => _password = input!,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print(e);
        // Handle errors
      }
    }
  }
}
