import 'package:client/colors/pallete.dart';
import 'package:client/screens/navbar.dart';
import 'package:client/screens/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User logged in: ${userCredential.user!.email}");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TabsScreen(getIndex: 0)));
      // Navigate to the next screen or perform desired actions upon successful login.
    } catch (e) {
      print("Login failed: $e");
      // Handle login failure, display error message, etc.
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
                'FireFlow, The smart AI planner',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Pallete.textprimary,
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
              const SizedBox(height: 32.0),
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
                onPressed: _login,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  try {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'New User? Register',
                  style: TextStyle(color: Pallete.textprimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Login extends StatefulWidget {
//   const Login({Key? key}) : super(key: key);
//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _login() async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       print("User logged in: ${userCredential.user!.email}");
//       // Navigate to the next screen or perform desired actions upon successful login.
//     } catch (e) {
//       print("Login failed: $e");
//       // Handle login failure, display error message, etc.
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Login Demo'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//             SizedBox(height: 16.0),
//             TextButton(
//               onPressed: () {
//                 try {
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => RegistrationPage()));
//                 } catch (e) {
//                   print(e);
//                 }
//               },
//               child: Text(
//                 'New User? Register',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
