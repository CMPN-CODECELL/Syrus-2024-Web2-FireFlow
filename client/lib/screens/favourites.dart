import 'package:client/colors/pallete.dart';
import 'package:client/screens/place_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  fetchBucketList() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    CollectionReference bucketCollectionRef = userRef.collection('bucket');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket List"),
        backgroundColor: Pallete.primary,
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('bucket')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(
                  color: Pallete.primary,
                );
              } else {
                if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text('No Places added Yet, Keep Exploring'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var place = snapshot.data!.docs[index];
                      return Padding(
                          padding: EdgeInsets.all(4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlaceInfo(
                                            locationName: place['name'],
                                          )));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Pallete.primary),
                                // color: Pallete.primary,
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 100,
                                child: Center(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      place['LocationName'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Pallete.whiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      place['LocationCity'],
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  ],
                                ))),
                          ));
                    });
              }
            }),
      ),
    );
  }
}
