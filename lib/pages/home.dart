// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:amazonbreak/pages/login2.dart';
import 'package:amazonbreak/pages/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatelessWidget {
  Home({super.key});

  String? userName;

  @override
  Widget build(BuildContext context) {
    User? aUser = FirebaseAuth.instance.currentUser;
    //making an reference to the instance
    final realRef =
        FirebaseFirestore.instance.collection("Shoppers").doc(aUser!.uid).get();
    String UID = aUser.uid;
////////////////////////////////////////
    // get User (or so we may say~)

////////////////////////////////////////////////
    //UI
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 91, 177, 88),
        body: Stack(
          children: [
            Container(
              alignment: Alignment(0, -.5),
              child: Image(
                  height: 350,
                  width: 350,
                  image: AssetImage('assets/WFCircleLogo.png')),
            ),
            Container(
              alignment: Alignment(0, -1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text("Auth User (Logged" +
                      (aUser == null ? " out" : " in") +
                      ")"),
                  SizedBox(),
                  Text("Uid = " + (aUser == null ? " out" : aUser.uid)),
                  FutureBuilder(
                      future: _fetch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text('Loading data....Please wait');
                        return Text('your name:  $userName');
                      })
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 6, 87, 8))),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 6, 87, 8))),
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
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 6, 87, 8))),
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

  //function to fetch the users name
  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('Shoppers')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        userName = ds.data()!['name'];
      });
    }
  }
}

/*

 User? user = FirebaseAuth.instance.currentUser;
    final realRef =
        FirebaseFirestore.instance.collection("Shoppers").doc(user!.uid).get();
*/
