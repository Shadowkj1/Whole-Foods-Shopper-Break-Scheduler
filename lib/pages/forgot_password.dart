// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //create an authentication instance
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 158, 98),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image(image: AssetImage('assets/WFCircleLogo.png')),
                ),
                Text(
                  "[Forgot Password]",
                  style: TextStyle(fontSize: 37),
                ),
                Text(
                  "An email will be sent with a \n       password reset link",
                  style: TextStyle(
                      fontSize: 24, color: Color.fromARGB(255, 1, 86, 54)),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 133, 83),
                      border: Border.all(color: Color.fromARGB(255, 1, 86, 54)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                //button For Resetting Password
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color.fromARGB(255, 0, 111, 70),
                    ),
                    onPressed: () {
                      auth.sendPasswordResetEmail(email: emailController.text);
                      Navigator.pop(context);
                    },
                    child:
                        Text("Reset Password", style: TextStyle(fontSize: 24))),
                SizedBox(
                  height: 5,
                ),
                //Textbutton For Going Back To Login
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 1, 86, 54),
                          decoration: TextDecoration.underline),
                    ))
              ]),
        ));
  }
}
