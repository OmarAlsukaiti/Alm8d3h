import 'package:alm8d3h/auth/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as Math;


class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  var locationMessage = "";


  bool isOnline = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC76060),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
              [
                SliverAppBar(
                  title: Text("Alm8d3h", style: TextStyle(fontSize: 30)),
                  centerTitle: true,
                  backgroundColor: Color(0xffC76060),
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.remove('email');
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    icon: Icon(Icons.logout),
                    iconSize: 35,
                  ),
                ),
              ],
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                child: Column(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        if (snapshot.data!.docs.isEmpty)
                          return Center(
                              child: Text(
                                'No one is here',
                                style: TextStyle(
                                  color: Color(0xff222B44),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ));
                        return ListView.separated(
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var User = snapshot.data!.docs[index];
                              var online =
                              snapshot.data!.docs[index]['isOnline'];
                              return ListTile(
                                leading: Icon(Icons.person, size: 35),
                                title: Text(User.get("name")),
                                trailing: Icon(
                                  Icons.circle,
                                  color: online ? Colors.green : Colors.red,
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                thickness: 2,
                                height: 5,
                              );
                            });
                      }),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      locationMessage, style: TextStyle(color: Colors.black),),
                    SizedBox(height: 8,),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffF0D5A3),
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        minWidth: 200,
                        onPressed: () {
                          getCurrentLocation();


                          // setState(() {
                          //   isOnline = !isOnline;
                          // });
                          // FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(FirebaseAuth.instance.currentUser!.uid)
                          //     .update({'isOnline': isOnline});
                        },
                        child: Text(
                          isOnline ? "i'm out" : "i'm here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    var lastPosition = await Geolocator.getLastKnownPosition();

    double lat1 = 24.6749336;
    double lng1 = 46.8523105;
    double lat2 = position.latitude;
    double lng2 = position.longitude;

    if (Geolocator.distanceBetween(lat1, lng1, lat2, lng2) < 1.0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isOnline': isOnline});
      }
  }

}