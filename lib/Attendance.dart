import 'package:alm8d3h/auth/sign_in.dart';
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
      appBar: AppBar(
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
        actions: [
          Switch(
            value: isOnline,
            onChanged: (value){
              setState(() {
                isOnline=value;
              });
            },
          )
        ],
      ),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Who is There:",
              style: TextStyle(
                color: Color(0xffABABAB),
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                size: 35,
              ),
              title: Text(
                "Abo Saleh",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                "Last seen at XXXX",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              trailing: Icon(
                Icons.circle,
                color: isOnline ? Colors.green : Color(0xffC76060),
                size: 35,
              ),
            ),
            Divider(
              thickness: 2,
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                size: 35,
              ),
              title: Text(
                "Abo Nasser",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                "Last seen at XXXX",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              trailing: Icon(
                Icons.circle,
                color: isOnline ? Colors.green : Color(0xffC76060),
                size: 35,
              ),
            ),
            Divider(
              thickness: 2,
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
  }
