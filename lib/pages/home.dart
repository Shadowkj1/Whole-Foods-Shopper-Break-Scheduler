// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, dead_code

import 'package:amazonbreak/pages/login2.dart';
import 'package:amazonbreak/pages/schedule.dart';
import 'package:amazonbreak/pages/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userName;

  String? shiftFormat;

  bool? canIBreak;
  bool? verify;

  DateTime? shift;

  final timeIsNow = DateTime.now();

  DocumentReference breakRefforStream =
      FirebaseFirestore.instance.collection("Shoppers").doc("breakActivity");

  late Stream<DocumentSnapshot> _streamBreak;

  @override
  void initState() {
    super.initState();
    _streamBreak = breakRefforStream.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    User? aUser = FirebaseAuth.instance.currentUser;
    //making an reference to the instance
    DocumentReference realRef =
        FirebaseFirestore.instance.collection("Shoppers").doc(aUser!.uid);

    DocumentReference breakRef =
        FirebaseFirestore.instance.collection("Shoppers").doc("breakActivity");
    String UID = aUser.uid;
////////////////////////////////////////
    // get User (or so we may say~)

////////////////////////////////////////////////
    //UI
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 158, 98),
        body: Stack(
          children: [
            Container(
              alignment: /*Alignment(0, -.5 */ Alignment(-.96, -.92),
              child: Image(
                  height: 70,
                  width: 70,
                  image: AssetImage('assets/WFCircleLogo.png')),
            ),
            Container(
              alignment: Alignment(0, -.5),
              decoration: BoxDecoration(),
              child: FutureBuilder(
                  future: _fetch(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator(
                        color: Colors.green,
                      );
                    }
                    return Container(
                      alignment: Alignment(0, -.5),
                      child: Text(
                        'Welcome $userName',
                        style: GoogleFonts.lato(
                            fontSize: 42, fontWeight: FontWeight.w500),
                      ),
                    );
                  }),
            ),

/////////////////////////////////////////////////////////////////////
            //this is all the junk text at the top of the screen
            Container(
              alignment: Alignment(0, -1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text("Auth User (Logged${aUser == null ? " out" : " in"})"),
                  SizedBox(),
                  Text("Uid = " + (aUser == null ? " out" : aUser.uid)),
                  FutureBuilder(
                      future: _fetch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text('Loading data....Please wait');
                        return Text('your name:  $userName');
                      }),
                  FutureBuilder(
                      future: _fetch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Text('Loading....');
                        }
                        return Text('shift time: ....nothing');
                      }),
                  FutureBuilder(
                      future: isBreakActive(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Text('Loading....');
                        }
                        return Text('$canIBreak');
                      })
                ],
              ),
            ),
/////////////////////////////////////////////////////////////////////////
            ///
            // this is the todays schedule button
            Container(
              alignment: Alignment(0, -1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Todays Schedule',
                    style: TextStyle(
                        color: Color.fromARGB(255, 1, 86, 54), fontSize: 24),
                  ),
                  SizedBox(
                    height: 50,
                    width: 260,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 0, 111, 70))),
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
                    height: 40,
                  ),
                  Text(
                    'Start Your Break Timer',
                    style: TextStyle(
                        color: Color.fromARGB(255, 1, 86, 54), fontSize: 24),
                  ),

                  //This is the Go on Break Button
                  StreamBuilder(
                      stream: _streamBreak,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          ////////////////////////////
                          DocumentSnapshot? test = snapshot.data;
                          ///////////////////////////////////////
                          ///
                          return SizedBox(
                            height: 50,
                            width: 260,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 0, 111, 70))),
                                onPressed: (() async {
                                  print(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      'this is the break activity from stream builder: ' +
                                          test!['isBreakActive'].toString());
                                  verify = test!['isBreakActive'];
                                  if (verify == true) {
                                    //since the break availabity
                                    Map<String, dynamic> breakToUpdate = {
                                      'isBreakActive': false,
                                    };
                                    breakRef.update(breakToUpdate);
                                    print('I AM THE BREAK BUTTON');
                                    //Create a Map with the input data
                                    Map<String, dynamic> dataToUpdate = {
                                      'break': timeIsNow,
                                    };
                                    //update the break TimeStamp in the database with now
                                    realRef.update(dataToUpdate);
                                    //on push bring us to the timer screen
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Timer()));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: null,
                                            content: Text(
                                                'Sorry, someone else is taking a break right now :('),
                                          );
                                        });
                                  }
                                }),
                                child: Text(
                                  'Go On Break',
                                  style: TextStyle(fontSize: 23),
                                )),
                          );
                        } else {
                          return SizedBox(
                            height: 50,
                            width: 260,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 0, 111, 70))),
                                onPressed: (() async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('no connection'),
                                          content: Text(
                                              'there seems to be no connection, please verify your connection and try again later'),
                                        );
                                      });
                                }),
                                child: Text(
                                  'Go On Break',
                                  style: TextStyle(fontSize: 23),
                                )),
                          );
                        }
                      }),
                  // SizedBox(
                  //   height: 50,
                  //   width: 260,
                  //   child: ElevatedButton(
                  //       style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.all(
                  //               Color.fromARGB(255, 0, 111, 70))),
                  //       onPressed: (() async {
                  //         if (canIBreak!) {
                  //           //since the break availabity
                  //           Map<String, dynamic> breakToUpdate = {
                  //             'isBreakActive': false,
                  //           };
                  //           breakRef.update(breakToUpdate);
                  //           print('I AM THE BREAK BUTTON');
                  //           //Create a Map with the input data
                  //           Map<String, dynamic> dataToUpdate = {
                  //             'break': timeIsNow,
                  //           };
                  //           //update the break TimeStamp in the database with now
                  //           realRef.update(dataToUpdate);
                  //           //on push bring us to the timer screen
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => Timer()));
                  //         } else {
                  //           showDialog(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return AlertDialog(
                  //                   title: null,
                  //                   content: Text(
                  //                       'Sorry, someone else is taking a break right now :('),
                  //                 );
                  //               });
                  //         }
                  //       }),
                  //       child: Text(
                  //         'Go On Break',
                  //         style: TextStyle(fontSize: 23),
                  //       )),
                  // ),
                ],
              ),
            ),

            //this is the toggleable breakActivity button
            Container(
              alignment: Alignment(.92, .988),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 0, 111, 70))),
                  onPressed: () async {
                    Map<String, dynamic> breakToUpdate = {
                      'isBreakActive': false,
                    };
                    breakRef.update(breakToUpdate);

                    if (canIBreak!) {
                      print('the break is true!!!!');
                    } else {
                      print('the break is false!!!!');
                    }
                  },
                  child: Text('Toggle breakActivity')),
            ),

            //this is the Log out Button
            Container(
              alignment: Alignment(-.92, .988),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 0, 111, 70))),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    });
                  },
                  child: Text('Log Out')),
            ),
          ],
        ));
  }

  //function to fetch the users name
  _fetch() async {
    // ignore: await_only_futures
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

//function to check if someone is on break or not
  isBreakActive() async {
    // ignore: await_only_futures
    await FirebaseFirestore.instance
        .collection('Shoppers')
        .doc('breakActivity')
        .get()
        .then((ds) {
      canIBreak = ds.data()!['isBreakActive'];
    });
  }
}

// Text(
//                       'Hello! $userName',
//                       style: GoogleFonts.montserrat(fontSize: 30),
//                     );

/*

 User? user = FirebaseAuth.instance.currentUser;
    final realRef =
        FirebaseFirestore.instance.collection("Shoppers").doc(user!.uid).get();
*/

/* Future builder idea
FutureBuilder(
                              future: isBreakActive(),
                              builder: (context, snapshot) {
                                
                              });
*/