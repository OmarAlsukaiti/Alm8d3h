import 'package:alm8d3h/auth/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  bool isOnline = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC76060),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text("Alm8d3h", style: TextStyle(fontSize: 30)),
                  centerTitle: true,
                  backgroundColor: Color(0xffC76060),
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
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
                          setState(() {
                            isOnline = !isOnline;
                          });
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({'isOnline': isOnline});
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
}
