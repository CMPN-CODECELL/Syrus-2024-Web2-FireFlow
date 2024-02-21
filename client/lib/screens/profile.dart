import 'package:client/screens/add_place.dart';
import 'package:client/screens/addplace.dart';
import 'package:client/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colors/pallete.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  late User? _user;
  late Map<String, dynamic> _userData;
  late String _userName = '';
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user?.uid)
          .get();

      setState(() {
        _userName = userDoc['name'];
        _userData = userDoc.data() ?? {};
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(color: Pallete.primary),
                child: const SizedBox(
                  height: 100,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("My Profile",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Pallete.whiteColor,
                                    )),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('LogOut'),
                                            content: const Text(
                                                'Are you sure you want to logout'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // Don't allow navigation
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        });

                                    // Add your logout logic here
                                    // Call your logout function when tapped
                                  },
                                  child: Icon(
                                    Icons.logout,
                                    size: 30,
                                    color: Pallete.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ),
                          const SizedBox(
                            height: 85,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Pallete.whiteColor,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Hello!!",
                                            style: TextStyle(
                                              fontSize: 15,
                                              // fontWeight: FontWeight.w800,
                                              color: Pallete.whiteColor,
                                            )),
                                        Text(_userName,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.bottomRight,
                              //   child: Icon(
                              //     Icons.edit_square,
                              //     size: 30,
                              //     color: Pallete.whiteColor,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Padding(
          // padding: EdgeInsets.only(
          //     bottom: 8, top: 8, left: 8), //apply padding to all four sides
          padding: EdgeInsets.all(16),
          child: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color.fromARGB(255, 203, 195, 195),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.lock,
              color: Pallete.primary,
            ),
            title: const Text(
              'Change Password',
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Pallete.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.format_list_bulleted_sharp,
              color: Pallete.primary,
            ),
            title: const Text(
              'Bucket List',
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: InkWell(
            onTap: () {
              // navigateBasedOnRole();
            },
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Pallete.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(
                Icons.person,
                color: Pallete.primary,
              ),
              title: Text(
                  "Edit Profile" // Customize the text color based on the role
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16), //apply padding to all four sides
          child: Text(
            'About Us',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Pallete.blackColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Pallete.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.question_answer_outlined,
              color: Pallete.primary,
            ),
            title: const Text('FAQ'),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Pallete.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.security,
              color: Pallete.primary,
            ),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Pallete.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.phone,
              color: Pallete.primary,
            ),
            title: const Text('Contact Us'),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16), //apply padding to all four sides
          child: Text(
            'Other',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Pallete.blackColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Pallete.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.mobile_friendly_rounded,
              color: Pallete.primary,
            ),
            title: const Text('Terms & Conditions'),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: 8, top: 8, left: 8), //apply padding to all four sides
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Pallete.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.share,
              color: Pallete.primary,
            ),
            title: const Text('Share'),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlace()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
