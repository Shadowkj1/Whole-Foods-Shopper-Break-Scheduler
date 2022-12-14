// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shadow/shadow.dart';

class Schedule extends StatefulWidget {
  Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  //this reference is basically pointing to our firestore.
  //it is a reference of the firestore database itself
  CollectionReference _referenceShoppers =
      FirebaseFirestore.instance.collection('Shoppers');
  late Stream<QuerySnapshot> _streamShoppers;

  //we cant call the reference inside the build function because it will constantly rebuild everything.
  // so we assigned it to the Stream Shoppers outside

  @override
  void initState() {
    super.initState();
    _streamShoppers = _referenceShoppers.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: _streamShoppers,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //if there is an error printing it to console
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            //checking that the connection is active
            if (snapshot.connectionState == ConnectionState.active) {
              //Query all the documents in the collection
              QuerySnapshot querySnapshot = snapshot.data;
              //put the documents of said query in a List
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                  querySnapshot.docs;
              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document =
                      listQueryDocumentSnapshot[index];
                  /////////////////////////////////////////
                  ///Where the logic happens
                  ///A problem with putting all of the logic here is that it requires that I
                  ///have the exact same fields in each document...
                  ///I could fix that... I am lazy
                  DateTime sStart, sEnd, bStart, bEnd, test;
                  DateTime breakTakenTime;
                  bool breakTakenToday;

                  //binding the document name and job to variables
                  String youTookYourBreak, name, job;
                  breakTakenToday = document['breakTakenToday'];
                  name = document['name'];
                  job = document['job'];

                  ////

                  breakTakenTime = document['break'].toDate();
                  String breakTimeTakenString =
                      DateFormat.Hm().format(breakTakenTime);

                  //we will only need to take in the 'shift' time because we can just do all the math
                  //with that one variable (maybe)
                  sStart = document['shift'].toDate();
                  String shiftStart = DateFormat.Hm().format(sStart);

                  //we are gonna wanna randomize it but for now all breaks start
                  //an hour and 30 minutes in
                  bStart = document['officialBreakTime'].toDate();
                  String breakStart = DateFormat.Hm().format(bStart);

                  //shifts are going to be 4 hours and 30 minutes long
                  sEnd = sStart.add(Duration(hours: 4, minutes: 30));
                  String shiftEnd = DateFormat.Hm().format(sEnd);

                  //the breaks will always be 10 minutes long so we will just add 10 minutes
                  //to the break start time
                  bEnd = bStart.add(Duration(minutes: 10));
                  String breakEnd = DateFormat.Hm().format(bEnd);

                  //this is just a test for the formatting
                  test = sStart;
                  String formattedTime = DateFormat.Hm().format(test);

                  if (breakTakenToday == true) {
                    youTookYourBreak =
                        "Break Taken at: \n        $breakTimeTakenString";
                  } else {
                    youTookYourBreak = 'Break Not Taken';
                  }
                  //////////////////////////////////////
                  return Container(
                    color: Color.fromARGB(255, 222, 245, 236),
                    child: Shadow(
                      options: ShadowOptions(scale: .2),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color.fromARGB(232, 126, 197, 170),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 26, 122, 86))),
                              //color: Colors.green,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 140,
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment(-.97, -.97),
                                      child: Text(" $job: $name",
                                          style: GoogleFonts.yantramanav(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w500,
                                            textStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  240, 19, 19, 19),
                                            ),
                                          )),
                                    ),
                                    Container(
                                        alignment: Alignment(.96, -.95),
                                        child: Text(youTookYourBreak,
                                            style: GoogleFonts.yantramanav(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 19, 19, 19))))),
                                    //an attempt to make all the times condensed into one text widget
                                    Container(
                                        alignment: Alignment(-0.9, .4),
                                        child: Text(
                                            " $shiftStart   >  $breakStart \n $breakStart   >  $breakEnd  \n $breakEnd   >  $shiftEnd                   ",
                                            style: GoogleFonts.yantramanav(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 19, 19, 19))))),
                                    Container(
                                        alignment: Alignment(-0.93, .4),
                                        child: Text(
                                            "                            Shopping\n                            Break \n                            Shopping",
                                            style: GoogleFonts.yantramanav(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        100, 19, 19, 19))))),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 8, 97, 63),
          title: Text('Today\'s Schedule'),
        ));
  }
}
