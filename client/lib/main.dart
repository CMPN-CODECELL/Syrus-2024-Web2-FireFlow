import 'package:client/firebase_options.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Stack(children: [
          Container(
            child: Text('FireFlow AI Planner'),
          ),
        ]),
      ),
    );
  }
}
