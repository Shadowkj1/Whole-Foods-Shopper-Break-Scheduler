// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, dead_code, unrelated_type_equality_checks, non_constant_identifier_names

import 'package:amazonbreak/animation_test.dart';
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
  bool? breakTakenToday;

  DateTime? shift;

  final timeIsNow = DateTime.now();

  DocumentReference breakRefforStream = FirebaseFirestore.instance
      .collection("BreakActivity")
      .doc("breakActivity");

  DocumentReference breakTimeRefforStream = FirebaseFirestore.instance
      .collection("Shoppers")
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());

  late Stream<DocumentSnapshot> breakActivityStream;
  late Stream<DocumentSnapshot> breakTimeStream;

  @override
  void initState() {
    super.initState();
    breakActivityStream = breakRefforStream.snapshots();
    breakTimeStream = breakTimeRefforStream.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    User? aUser = FirebaseAuth.instance.currentUser;
    String UID = aUser!.uid;

    //making an reference to the instance
    DocumentReference realRef =
        FirebaseFirestore.instance.collection("Shoppers").doc(UID);

    DocumentReference breakRef = FirebaseFirestore.instance
        .collection("BreakActivity")
        .doc("breakActivity");

    //this is literally just to update the breakTakenToday in the database
    DocumentReference breakTakenTodayRef =
        FirebaseFirestore.instance.collection('Shoppers').doc(UID);

////////////////////////////////////////
    // get User (or so we may say~)

////////////////////////////////////////////////
    //UI
    return StreamBuilder(
        //if this works I dont know why I didnt do this in the beginning :/
        stream: breakTimeStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          DocumentSnapshot? shopperDocument = snapshot.data;

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

                  //The Welcome text
                  StreamBuilder(
                      stream: breakTimeStream,
                      builder:
                          ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          DocumentSnapshot? document = snapshot.data;

                          DateTime breakTimeRaw =
                              document!['officialBreakTime'].toDate();

                          String name = document['name'];
                          String emptySpace = '                ';
                          verify = document['breakTakenToday'];

                          String breakTimeString =
                              DateFormat.Hm().format(breakTimeRaw);

                          if (verify == false) {
                            return Container(
                                alignment: Alignment(0, -.5),
                                decoration: BoxDecoration(),
                                child: Text(
                                  'Your Break is Scheduled for: \n $emptySpace $breakTimeString Today',
                                  style: GoogleFonts.lato(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500),
                                ));
                          } else {
                            return Container(
                                alignment: Alignment(0, -.5),
                                decoration: BoxDecoration(),
                                child: Text(
                                  '          You have already  \n taken your break for today',
                                  style: GoogleFonts.lato(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500),
                                ));
                          }
                        } else {
                          return Text('data');
                        }
                      })),

/////////////////////////////////////////////////////////////////////
                  //this is all the junk text at the top of the screen
                  Container(
                    alignment: Alignment(0, -1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text(
                            "Auth User (Logged${aUser == null ? " out" : " in"})"),
                        SizedBox(),
                        Text("Uid = " + (aUser == null ? " out" : aUser.uid)),
                        FutureBuilder(
                            future: _fetch(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done)
                                return Text('Loading data....Please wait');
                              return Text('your name:  $userName');
                            }),
                        FutureBuilder(
                            future: _fetch(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Text('Loading....');
                              }
                              return Text('shift time: ....nothing');
                            }),
                        FutureBuilder(
                            future: isBreakActive(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
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
                              color: Color.fromARGB(255, 1, 86, 54),
                              fontSize: 24),
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
                              child: Text('Schedule',
                                  style: TextStyle(fontSize: 23))),
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Start Your Break Timer',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 86, 54),
                              fontSize: 24),
                        ),

                        //This is the Go on Break Button
                        StreamBuilder(
                            stream: breakActivityStream,
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                ////////////////////////////
                                DocumentSnapshot? test = snapshot.data;
                                ///////////////////////////////////////
                                ///
                                return SizedBox(
                                  // return a stream builder here and it should work. put the sized box and all of its logic inside of it. //////////////////////////////////////////////////////////////////////////////////////////
                                  height: 50,
                                  width: 260,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 0, 111, 70))),
                                      onPressed: (() async {
                                        showDialog(
                                            // show dialog is what helps make this work, thank god ;-;
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Are You Sure?'),
                                                content: Text(
                                                    'Are you sure you want to go on break right now?'),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('No')),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        breakTakenToday =
                                                            shopperDocument![
                                                                'breakTakenToday'];
                                                        //Verify the user hasnt already used all of their breaks
                                                        if (breakTakenToday ==
                                                            false) {
                                                          verify = test![
                                                              'isBreakActive'];
                                                          if (verify == true) {
                                                            //update the break availability
                                                            Map<String, dynamic>
                                                                breakToUpdate =
                                                                {
                                                              'isBreakActive':
                                                                  false,
                                                            };
                                                            Map<String, dynamic>
                                                                breakTakenToUpdate =
                                                                {
                                                              'breakTakenToday':
                                                                  true,
                                                            };

                                                            breakTakenTodayRef
                                                                .update(
                                                                    breakTakenToUpdate);

                                                            breakRef.update(
                                                                breakToUpdate);
                                                            print(
                                                                'I AM THE BREAK BUTTON');
                                                            //Create a Map with the input data
                                                            Map<String, dynamic>
                                                                dataToUpdate = {
                                                              'break':
                                                                  timeIsNow,
                                                            };
                                                            //update the break TimeStamp in the database with now
                                                            realRef.update(
                                                                dataToUpdate);
                                                            //on push bring us to the timer screen
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Timer()));
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: null,
                                                                    content: Text(
                                                                        'Sorry, someone else is taking a break right now :('),
                                                                  );
                                                                });
                                                          }
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: null,
                                                                  content: Text(
                                                                      'you already took your breaks for the day'),
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: Text('Yes'))
                                                ],
                                              );
                                            });
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
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 0, 111, 70))),
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
                      ],
                    ),
                  ),

                  //this is the toggleable breakActivity button
                  StreamBuilder(
                      stream: breakActivityStream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          DocumentSnapshot? test1 = snapshot.data;
                          return Container(
                            alignment: Alignment(.92, .988),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 0, 111, 70))),
                                onPressed: () async {
                                  verify = test1!['isBreakActive'];
                                  if (verify == false) {
                                    Map<String, dynamic> breakToUpdate = {
                                      'isBreakActive': true,
                                    };
                                    breakRef.update(breakToUpdate);
                                  } else {
                                    Map<String, dynamic> breakToUpdate = {
                                      'isBreakActive': false,
                                    };
                                    breakRef.update(breakToUpdate);
                                  }
                                },
                                child: Text('Toggle breakActivity')),
                          );
                        } else {
                          return Text('null');
                          // DocumentSnapshot? test2 = snapshot.data;
                          // return Container(
                          //   alignment: Alignment(.92, .988),
                          //   child: ElevatedButton(
                          //       style: ButtonStyle(
                          //           backgroundColor: MaterialStateProperty.all(
                          //               Color.fromARGB(255, 0, 111, 70))),
                          //       onPressed: () async {
                          //         if (test2 == false) {
                          //           Map<String, dynamic> breakToUpdate = {
                          //             'isBreakActive': true,
                          //           };
                          //           breakRef.update(breakToUpdate);
                          //         }
                          //         if (test2 == true) {
                          //           Map<String, dynamic> breakToUpdate = {
                          //             'isBreakActive': false,
                          //           };
                          //           breakRef.update(breakToUpdate);
                          //         }
                          //       },
                          //       child: Text('Toggle breakActivity')),
                          // );
                        }
                      }),

                  //this is the Log out Button
                  Container(
                    alignment: Alignment(-.92, .988),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 0, 111, 70))),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut().then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          });
                        },
                        child: Text('Log Out')),
                  ),
                  //the animation test screen button
                  Container(
                    alignment: Alignment(0, .8),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 0, 111, 70))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnimationBackground()));
                        },
                        child: Text('Animation Test Screen')),
                  ),
                ],
              ));
        });
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
        .collection('BreakActivity')
        .doc('breakActivity')
        .get()
        .then((ds) {
      canIBreak = ds.data()!['isBreakActive'];
    });
  }
}

/*
Container(
                        alignment: Alignment(0, -.5),
                        decoration: BoxDecoration(),
                        child: Text(
                          'Your Break is Scheduled for: \n $emptySpace $breakTimeString Today',
                          style: GoogleFonts.lato(
                              fontSize: 23, fontWeight: FontWeight.w500),
                        ));
*/