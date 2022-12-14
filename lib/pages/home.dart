// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, dead_code, unrelated_type_equality_checks, non_constant_identifier_names

import 'package:amazonbreak/notification_api.dart';
import 'package:amazonbreak/pages/login.dart';
import 'package:amazonbreak/pages/schedule.dart';
import 'package:amazonbreak/pages/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
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
  DateTime? officialBreakTime;

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
    tz.initializeTimeZones();
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
    return SafeArea(
      child: StreamBuilder(
          //if this works I dont know why I didnt do this in the beginning :/
          stream: breakTimeStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> quickshot) {
            DocumentSnapshot? shopperDocument = quickshot.data;
            userName = shopperDocument?['name'];

            return Scaffold(
                backgroundColor: Color.fromARGB(255, 0, 158, 98),
                body: Stack(
                  children: [
                    Container(
                      alignment: /*Alignment(0, -.5 */ Alignment(-.94, -.95),
                      child: Image(
                          height: 70,
                          width: 70,
                          image: AssetImage('assets/WFCircleLogo.png')),
                    ),

                    //The Welcome text
                    Container(
                      alignment: Alignment(-.04, -.53),
                      child: StreamBuilder(
                          stream: breakTimeStream,
                          builder: ((context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                              DateTime officialBreakTime =
                                  shopperDocument!['officialBreakTime']
                                      .toDate();
                              breakTakenToday =
                                  shopperDocument['breakTakenToday'];

                              if (verify == true) {
                                return Container(
                                    alignment: Alignment(0, -.5),
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      '          You have already  \n taken your break for today',
                                      style: GoogleFonts.lato(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w500),
                                    ));
                              } else if (officialBreakTime
                                      .compareTo(timeIsNow) <
                                  0) {
                                return Container(
                                    alignment: Alignment(0, -.5),
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      'Your break time has already passed!',
                                      style: GoogleFonts.lato(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w500),
                                    ));
                              } else if (officialBreakTime
                                      .compareTo(timeIsNow) >
                                  0) {
                                return Container(
                                    alignment: Alignment(0, -.5),
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      'Your Break is Scheduled for: \n $emptySpace $breakTimeString Today',
                                      style: GoogleFonts.lato(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w500),
                                    ));
                              }

                              return Text('data failed all checks');
                            } else {
                              return Text('There seems to be no connection');
                            }
                          })),
                    ),
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
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 201, 224, 215),
                                                  title: Text('Are You Sure?'),
                                                  content: Text(
                                                      'Are you sure you want to go on break right now?'),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            111,
                                                                            70))),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('No')),
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            111,
                                                                            70))),
                                                        onPressed: () {
                                                          breakTakenToday =
                                                              shopperDocument![
                                                                  'breakTakenToday'];
                                                          //Verify the user hasnt already used all of their breaks
                                                          if (breakTakenToday ==
                                                              false) {
                                                            verify = test![
                                                                'isBreakActive'];
                                                            if (verify ==
                                                                true) {
                                                              //update the break availability
                                                              Map<String,
                                                                      dynamic>
                                                                  breakToUpdate =
                                                                  {
                                                                'isBreakActive':
                                                                    false,
                                                              };
                                                              Map<String,
                                                                      dynamic>
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
                                                              Map<String,
                                                                      dynamic>
                                                                  dataToUpdate =
                                                                  {
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
                                                                      backgroundColor: Color.fromARGB(
                                                                          255,
                                                                          201,
                                                                          224,
                                                                          215),
                                                                      title:
                                                                          null,
                                                                      content: Text(
                                                                          'Sorry, someone else is taking a break right now :('),
                                                                    );
                                                                  });
                                                            }
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            201,
                                                                            224,
                                                                            215),
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
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 201, 224, 215),
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
                          /////////////////////////////////////////////////////////////////////////////
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Set an Alarm For Your Break',
                            style: TextStyle(
                                color: Color.fromARGB(255, 1, 86, 54),
                                fontSize: 24),
                          ),

                          //Schedule your break alarm 5 minutes before break OR schedule for a certain interval of time 0-0
                          SizedBox(
                            height: 50,
                            width: 260,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 0, 111, 70))),
                                onPressed: () {
                                  DateTime officialBreakTime =
                                      shopperDocument!['officialBreakTime']
                                          .toDate();
                                  breakTakenToday =
                                      shopperDocument['breakTakenToday'];

                                  if (officialBreakTime.compareTo(timeIsNow) >
                                      0) {
                                    if (breakTakenToday == false) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 201, 224, 215),
                                              title: Text(
                                                  'Set an alarm prior to your break'),
                                              content: Text(
                                                  'How much time would you like?'),
                                              actions: [
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        111,
                                                                        70))),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      try {
                                                        NotificationApi.showScheduledNotification(
                                                            title:
                                                                'This is your 10 second alarm',
                                                            body:
                                                                'Your break is coming at breakneck speeds of 10 seconds',
                                                            payload:
                                                                '5_min_notif',
                                                            scheduledDate:
                                                                officialBreakTime
                                                                    .subtract(Duration(
                                                                        seconds:
                                                                            10)));
                                                      } on Exception catch (e) {
                                                        print(e);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        201,
                                                                        224,
                                                                        215),
                                                                title: null,
                                                                content: Text(
                                                                    'Invalid Username or Password'),
                                                              );
                                                            });
                                                      }

                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                            'Alarm Scheduled for 10 seconds prior',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  1,
                                                                  86,
                                                                  54));
                                                      ScaffoldMessenger.of(
                                                          context)
                                                        ..removeCurrentSnackBar()
                                                        ..showSnackBar(
                                                            snackBar);
                                                    },
                                                    child: Text('10 secs')),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        111,
                                                                        70))),
                                                    onPressed: () {},
                                                    child: Text('10 mins')),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        111,
                                                                        70))),
                                                    onPressed: () {},
                                                    child: Text('15 mins')),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        111,
                                                                        70))),
                                                    onPressed: () {},
                                                    child: Text('20 mins'))
                                              ],
                                            );
                                          });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 201, 224, 215),
                                              title: null,
                                              content: Text(
                                                  'You have already taken your break for today. There is no need to schedule an alarm'),
                                            );
                                          });
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Color.fromARGB(
                                                255, 201, 224, 215),
                                            title: null,
                                            content: Text(
                                                'Your scheduled break time has already passed. There is no need to set an alarm. Use the "Go On Break" button before your shift ends.'),
                                          );
                                        });
                                  }
                                },
                                child: Text(
                                  'Set Alarm',
                                  style: TextStyle(fontSize: 24),
                                )),
                          ),
                        ],
                      ),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            });
                          },
                          child: Text('Log Out')),
                    ),
                    //User you are signed in as

                    Container(
                      alignment: Alignment(.91, .98),
                      child: Text(
                        'Signed in as: $userName',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ));
          }),
    );
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
