import 'package:client/colors/pallete.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool passwordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': _emailController.text,
        'name': _nameController.text, // ... other user data fields
      });
      print("User registered: ${userCredential.user!.email}");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TabsScreen(getIndex: 0)));
      // Navigate to the next screen or perform desired actions upon successful registration.
    } catch (e) {
      print("Registration failed: $e");
      // Handle registration failure, display error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Image(image: AssetImage('assets/images/syrus.png')),
              ),
              SizedBox(height: 20),
              Text(
                'FireFlow, the smart AI Planne',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Pallete.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.primary),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusColor: Pallete.primary,
                        hintText: 'Name',
                        icon: Icon(Icons.person),
                        iconColor: Pallete.primary),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.primary),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusColor: Pallete.primary,
                        hintText: 'Email',
                        icon: Icon(Icons.email),
                        iconColor: Pallete.primary),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.primary),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: !passwordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusColor: Pallete.primary,
                        hintText: 'Password',
                        icon: Icon(Icons.pin),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Pallete.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        iconColor: Pallete.primary),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Pallete.whiteColor,
                  backgroundColor: Pallete.primary, // Text color
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  //minimumSize: Size(double.infinity, 0), // Full width
                ),
                onPressed: _register,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  try {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'Already a User? Login',
                  style: TextStyle(color: Pallete.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
