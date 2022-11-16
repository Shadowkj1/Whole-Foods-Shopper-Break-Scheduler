// ignore_for_file: prefer_const_constructors

import 'package:amazonbreak/notification_api.dart';
import 'package:amazonbreak/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  DateTime shift = DateTime.now();

//
  var userRef = FirebaseFirestore.instance.collection('Shopper');

//
  User? aUser = FirebaseAuth.instance.currentUser;

//
  var isBreakOverFireStore =
      FirebaseFirestore.instance.collection('Shopper').doc('breakActivity');

//
  bool isBreakOver = false;

//
  bool? canIBreak;

//
  DocumentReference breakRef = FirebaseFirestore.instance
      .collection("BreakActivity")
      .doc("breakActivity");

  void initState() {
    //_fetch2();
    // NotificationApi.init();
    // listenNotifications();
    super.initState();
  }

  // void listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen(onClickedNotification);

  // void onClickedNotification(String? payload) => Navigator.of(context)
  //     .push(MaterialPageRoute(builder: ((context) => Home())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              //this will be the actual timer widget
              child: TimerCountdown(
                format: CountDownTimerFormat.minutesSeconds,
                endTime: DateTime.now().add(Duration(minutes: 0, seconds: 5)),
                onEnd: () {
                  NotificationApi.showNotification(
                    title: 'Hey!!',
                    body: 'Break time is over buddy!',
                    payload: 'test',
                  );
                  createAlertDialog(context);
                  Map<String, dynamic> breakToUpdate = {
                    'isBreakActive': true,
                  };
                  breakRef.update(breakToUpdate);
                },
              ),
            ),
            Container(
              alignment: Alignment(.92, .988),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 0, 111, 70))),
                  onPressed: () async {},
                  child: Text('Set Break Time')),
            )
          ],
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 111, 70),
          title: Text('Break Time'),
        ));
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        // show dialog is what helps make this work, thank god ;-;
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: null,
            content: Text('get back to work :)'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text('ok :('))
            ],
          );
        });
  }

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

  _fetch2() async {
    // ignore: await_only_futures
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('Shoppers')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        shift = ds.data()?['shift'];
        print('this is the shift: $shift');
      });
    }
  }
}

/*


*/
