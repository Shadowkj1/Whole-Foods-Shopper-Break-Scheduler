// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

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
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                  querySnapshot.docs;
              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document =
                      listQueryDocumentSnapshot[index];
                  /////////////////////////////////////////
                  ///Where the logic happens
                  DateTime sStart, sEnd, bStart, bEnd, test;

                  //we will only need to take in the 'shift' time because we can just do all the math
                  //with that one variable (maybe)
                  sStart = document['shift'].toDate();
                  String shiftStart = DateFormat.Hm().format(sStart);

                  //we are gonna wanna randomize it but for now all breaks start
                  //an hour and 30 minutes in
                  bStart = sStart.add(Duration(hours: 1, minutes: 30));
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
                  //////////////////////////////////////
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 107, 185, 248),
                              border: Border.all(
                                  color: Color.fromARGB(255, 5, 98, 204))),
                          //color: Colors.green,
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment(-.97, -.97),
                                  child: Text(
                                    document['job'] + ":",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment(-.65, -.97),
                                  child: Text(
                                    document['name'],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                //Text(document['shift'].toString()),
                                //Top Text
                                Container(
                                    alignment: Alignment(-.4, -.4),
                                    child: Text(
                                      "Shift Start: $shiftStart -> $breakStart",
                                      style: TextStyle(fontSize: 19),
                                    )),
                                //Middle text
                                Container(
                                    alignment: Alignment(-.43, 0.1),
                                    child: Text(
                                        "Break Start:  $breakStart -> $breakEnd",
                                        style: TextStyle(fontSize: 19))),
                                //Bottom text
                                Container(
                                    alignment: Alignment(-.55, .55),
                                    child: Text(
                                        "Shift Ends: $breakEnd -> $shiftEnd",
                                        style: TextStyle(fontSize: 19))),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
          title: Text('Schedule'),
        ));
  }
}

/*
Column(
                    children: [
                      Stack(
                        children: [],
                      ),
                      Text(
                        document['job'],
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      Text(
                        document['name'],
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      Text(document['shift'].toString()),
                      Text("Shift Start: " + ho.toString()),
                      Text("Shift End: " + end.toString()),
                      Text("This is the Test Time:  " + formattedTime),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  );
*/