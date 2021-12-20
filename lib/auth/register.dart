import 'package:alm8d3h/auth/sign_in.dart';
import 'package:alm8d3h/model/user_model.dart';
import 'package:alm8d3h/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final nameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC76060),
      appBar: AppBar(
        title: Text("Alm8d3h",
            style: TextStyle(
              fontSize: 30,
            )),
        centerTitle: true,
        backgroundColor: Color(0xffC76060),
        elevation: 0,
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
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                //email
                TextFormField(
                  controller: emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    // reg expression for email validation
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@alm8d3h.com")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailEditingController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                //name
                TextFormField(
                  controller: nameEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("First Name cannot be Empty");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid name(Min. 3 Character)");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nameEditingController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                //pass
                TextFormField(
                  controller: passwordEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Password is required for login");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid Password(Min. 6 Character)");
                    }
                  },
                  onSaved: (value) {
                    passwordEditingController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                //conform pass
                TextFormField(
                  controller: confirmPasswordEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (confirmPasswordEditingController.text !=
                        passwordEditingController.text) {
                      return "Password don't match";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmPasswordEditingController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                //button
                isLoading
                    ? CircularProgressIndicator()
                    : Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffF0D5A3),
                  child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      minWidth: 200,
                      onPressed: () {
                        signUp(emailEditingController.text,
                            passwordEditingController.text);
                      },
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(height: 15),
                //text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                            color: Color(0xff222B44),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
              postDetailsToFirestore()
            })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: e.message ?? 'problem in signin');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;

    await firebaseFirestore
        .collection(("users"))
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Nav()));
  }
}
