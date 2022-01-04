import 'package:alm8d3h/NewRequest.dart';
import 'package:alm8d3h/auth/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final _auth = FirebaseAuth.instance;
  int _state = 0;
  bool isTaken = false;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffC76060),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NewRequest()));
          },
          backgroundColor: Color(0xffC76060),
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Requests')
                .where('Status', isEqualTo: _state)
                .orderBy('Time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
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
                    actions: [
                      PopupMenuButton<int>(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: Text(
                                      'waiting',
                                      style: TextStyle(
                                          fontWeight: _state == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                    value: 0),
                                PopupMenuItem(
                                    child: Text(
                                      'Taken',
                                      style: TextStyle(
                                          fontWeight: _state == 1
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                    value: 1),
                              ],
                          onSelected: (int value) {
                            setState(() {
                              _state = value;
                            });
                          })
                    ],
                  )
                ],
                body: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                  child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        var snapData = snapshot.data?.docs[index];
                        return index == snapshot.data!.docs.length
                            ? SizedBox(height: 230)
                            : _request(snapshot: snapData);
                      }),
                ),
              );
            }));
  }

  Widget _request({QueryDocumentSnapshot<Map<String, dynamic>>? snapshot}) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border.all(color: Colors.black54, width: 2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )),
      child: Column(
        children: [
          Text(
            '${snapshot?.get("Title") ?? 'Unknown'} ',
            style: TextStyle(
              color: Color(0xffA23737),
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${snapshot?.get("Description") ?? 'Unknown'} ',
            style: TextStyle(
              color: Color(0xffA23737),
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Requested By:",
                    style: TextStyle(color: Color(0xffA23737), fontSize: 8),
                  ),
                  Text(
                    '${snapshot?.get("Created by") ?? 'Unknown'} ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              Text(
                "Time:",
                //'${snapshot?.get("Time") ?? 'Unknown'} ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 8,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              snapshot!.get('Created by') == _auth.currentUser!.uid || snapshot!.get('Completed by') == _auth.currentUser!.uid?
              IconButton(
              icon: snapshot!.get('Status') == 0 ? Icon(Icons.delete, color: Colors.black54,) :
                    Icon(Icons.done, color: Colors.black54,),
              onPressed: () {
                if(snapshot!.get('Status') == 1 && snapshot!.get('Completed by') == _auth.currentUser!.uid){
                  snapshot?.reference.update({"Status": 2});
                }else{
                  Fluttertoast.showToast(msg: 'FUCK OFF');
                }
                if(snapshot!.get('Status') == 0 && snapshot!.get('Created by') == _auth.currentUser!.uid){
                  snapshot?.reference.update({"Status": 3});
                }else{
                  Fluttertoast.showToast(msg: 'Sorry you are not responsible for this request');// جالس يعرض هالمسج دايم لان الاف ما تتحقق في حالة انه جعل الفعالية حالتها 2
                }
              },
            ) : SizedBox(width: 39,),
              GestureDetector(
                onTap: () {
                  if (snapshot!.get('Completed by') == null) {
                    snapshot?.reference.update({"Status": 1});
                    snapshot?.reference
                        .update({"Completed by": _auth.currentUser!.uid});
                  } else {
                    if(snapshot!.get('Completed by') == _auth.currentUser!.uid){
                      snapshot?.reference.update({"Status": 0});
                      snapshot?.reference.update({"Completed by": null});
                    } else {
                      Fluttertoast.showToast(msg: 'Sorry you are not the owner of this request');
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: snapshot!.get('Status') == 0
                              ? Color(0xff3C7B48)
                              : Color(0xff9F2222),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          )),
                      child: Center(
                        child: Icon(
                            snapshot!.get('Status') == 0
                                ? Icons.check
                                : Icons.close,
                            color: Colors.white),
                      ),
                    ),

                    // if (snapshot.get("Completed by") != null)
                    //   Text(
                    //       '${FirebaseFirestore.instance.collection("users").doc(snapshot.get("Completed by")).get('name')}'
                    //   ),
                  ],
                ),
              ),
              SizedBox(width: 47,),
            ],
          )

        ],
      ),
    );
  }
}
