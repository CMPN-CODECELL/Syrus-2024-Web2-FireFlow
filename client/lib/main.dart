import 'package:client/colors/pallete.dart';
import 'package:client/firebase_options.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FireFlow',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      User? user = _auth.currentUser;

      if (user != null) {
        // User is logged in, navigate to the desired screen
        // For example, navigate to the home screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TabsScreen(
                  getIndex: 0,
                )));
      } else {
        // User is not logged in, navigate to the login screen
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
    return Scaffold(
      // backgroundColor: Pallete.blueprimary,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GradientAnimationText(
                text: Text(
                  'Humsafar',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                colors: [
                  // Color(0xFF061A9C),
                  // Color(0xff92effd),
                  Color(0xff8f00ff),
                  Colors.indigo,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                ],
                duration: Duration(seconds: 5),
                transform: GradientRotation(math.pi / 4),
              ),
              Container(
                height: 450,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/syrus.png', // Replace with the correct path to your image
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              CircularProgressIndicator(color: Pallete.textprimary),
            ],
          ),
        ),
      ),
    );
  }
}
