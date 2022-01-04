import 'package:alm8d3h/auth/sign_in.dart';
import 'package:alm8d3h/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class NewRequest extends StatefulWidget {
  const NewRequest({Key? key}) : super(key: key);

  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  @override
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController = new TextEditingController();
  void Submit (String Title, String Description) async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('Requests')
          .doc()
          .set(
          {
            'Title': Title,
            'Status': 0,
            'Description': Description,
            'Created by': FirebaseAuth.instance.currentUser?.uid,
            'Time': Timestamp.now(),
            'Completed by': null,
          });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Requests()));
    }
  }
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
        actions: [],
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("New Request",
                  style: TextStyle(
                      color: Color(0xff222B44),
                      fontWeight: FontWeight.w600,
                      fontSize: 21)),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: titleController,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return ('Please Enter a Title');
                  }
                  if (value.length < 3) {
                    return ("Must be more than 3 letters you lazy mf");
                  }
                  return null;
                },
                onSaved: (value) {
                  titleController.text = value!;
                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: descriptionController,

                style: TextStyle(height: 5),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: "Description",
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),

                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return ('Please Enter a Description');
                  }
                  if (value.length < 5) {
                    return ("Must be more than 5 letters you lazy mf");
                  }
                  return null;
                },
                onSaved: (value) {
                  descriptionController.text = value!;
                },
              ),
              SizedBox(height: 20,),
              isLoading
                  ? CircularProgressIndicator()
                  :
              MaterialButton(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                minWidth: 200,
                onPressed: () {
                  if (isLoading) return;
                  Submit(
                      titleController.text,descriptionController.text);
                },

                child: Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
