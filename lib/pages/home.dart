// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:amazonbreak/pages/login2.dart';
import 'package:amazonbreak/pages/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    User? aUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
        backgroundColor: Colors.blue[400],
        body: Stack(
          children: [
            Container(
              alignment: Alignment(0, -1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text("Auth User (Logged" +
                      (aUser == null ? " out" : " in") +
                      ")")
                ],
              ),
            ),
            Container(
              alignment: Alignment(0, -1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 260,
                    child: ElevatedButton(
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Schedule()));
                        }),
                        child:
                            Text('Schedule', style: TextStyle(fontSize: 23))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: 260,
                    child: ElevatedButton(
                        onPressed: (() {
                          print('I AM THE BREAK BUTTON');
                        }),
                        child: Text(
                          'Go On Break',
                          style: TextStyle(fontSize: 23),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment(-.92, .988),
              child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    });
                  },
                  child: Text('Log Out')),
            )
          ],
        ));
  }
}
      
      /*SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Schedule()));
                    },
                    child: Text('button 1'))),
            SizedBox(
              height: 15,
            ),
            SizedBox(
                width: 200,
                height: 40,
                child:
                    ElevatedButton(onPressed: () {}, child: Text('button 2'))),
          ])
        ],
      )),*/
 
