import 'package:alm8d3h/auth/register.dart';
import 'package:alm8d3h/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  String? errorMessage;
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
                  controller: emailController,
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
                      return ('Please Enter Your Email');
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                //pass
                TextFormField(
                  controller: passwordController,
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
                    passwordController.text = value!;
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
                      if (isLoading) return;
                      signIn(
                          emailController.text, passwordController.text);
                    },
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                              color: Color(0xff222B44),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
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

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        var auth = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.user!.uid)
            .get();
        if (userDoc.exists) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Nav()));
        } else {
          Fluttertoast.showToast(msg: 'Sorry you are not registered');
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.message ?? 'Error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
