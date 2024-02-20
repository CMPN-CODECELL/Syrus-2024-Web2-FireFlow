import 'package:client/Services/auth.dart';
import 'package:client/common/custom_button.dart';
import 'package:client/screens/favourites.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/pallete.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class DrawerContent extends StatefulWidget {
  DrawerContent({Key? key}) : super(key: key);

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _userName = '';
  // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user name when the widget initializes
  }

  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        setState(() {
          _userName = userSnapshot['name'];
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final email = user!.email;

    return Drawer(
      backgroundColor: Pallete.whiteColor,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        _userName.isNotEmpty ? _userName : "Loading...",
                      ), // Replace with the user's name // Replace with the user's name
                      accountEmail: Text(
                          email.toString()), // Replace with the user's email
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage(
                            "assets/images/logo.png"), // Replace with the path to the user's profile image
                      ),
                      decoration: BoxDecoration(
                        color: Pallete
                            .primary, // Change this color to the desired blue shade
                      ),
                    ),
                    Positioned(
                      bottom:
                          16.0, // Adjust this value to position the icon as needed
                      right:
                          16.0, // Adjust this value to position the icon as needed
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          PhosphorIcons.pencil,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.pen),
                      SizedBox(width: 10),
                      Text('Trip Vlog/Diary'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.heart),
                      SizedBox(width: 10),
                      Text('Favourites'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.list_checks),
                      SizedBox(width: 10),
                      Text('Bucket List'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favourites()),
                    );
                  },
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.buildings),
                      SizedBox(width: 10),
                      Text('Stay'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.car),
                      SizedBox(width: 10),
                      Text('Transport'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.user),
                      SizedBox(width: 10),
                      Text('Profile'),
                    ],
                  ),
                  onTap: () {
                    // // Navigate to the Profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.info),
                      SizedBox(width: 10),
                      Text('About Us'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.phone),
                      SizedBox(width: 10),
                      Text('Contact Us'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
                ListTile(
                  title: Row(
                    children: [
                      Icon(PhosphorIcons.star),
                      SizedBox(width: 10),
                      Text('Rate Us'),
                    ],
                  ),
                  onTap: () {},
                  trailing: Icon(PhosphorIcons.caret_right),
                ),
                Divider(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: Container(
                  // width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: CustomButton(
                    buttonText: 'Logout',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Logout",
                              style: GoogleFonts.nunito(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  AuthService.logout();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                  // SystemNavigator.pop();
                                  // SystemNavigator.pop();
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// Change your location
// Speed Dials
// Help 
// Terms & Conditions
// About Us
// Contact Us                          );




// Change your location
// Speed Dials
// Help 
// Terms & Conditions
// About Us
// Contact Us