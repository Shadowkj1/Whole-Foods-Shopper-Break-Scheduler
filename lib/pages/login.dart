// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:amazonbreak/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    User? status = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 158, 98),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Container(
            //     alignment: Alignment(0, 0),
            //     child: Text("Auth User (Logged" +
            //         (status == null ? " out" : " in") +
            //         ")")),
            SizedBox(
              height: 200,
              width: 200,
              child: Image(image: AssetImage('assets/WFCircleLogo.png')),
            ),
            Text(
              "Welcome Back!",
              style: GoogleFonts.bebasNeue(fontSize: 50),
            ),
            Text(
              "Please put in your email and password",
              style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  textStyle: TextStyle(color: Color.fromARGB(255, 1, 86, 54))),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 133, 83),
                  border: Border.all(color: Color.fromARGB(255, 1, 86, 54)),
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: '   Enter Email',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 133, 83),
                  border: Border.all(color: Color.fromARGB(255, 1, 86, 54)),
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '   Enter Password', border: InputBorder.none)),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Color.fromARGB(255, 0, 111, 70),
              ),
              icon: Icon(Icons.lock_open, size: 32),
              label: Text(
                'Sign In',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim())
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  });
                } on Exception catch (e) {
                  print(e);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color.fromARGB(255, 201, 224, 215),
                          title: null,
                          content: Text('Invalid Username or Password'),
                        );
                      });
                  setState(() {});
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
/*
  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home())));
  }
  */
}
