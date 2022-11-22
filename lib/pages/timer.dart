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
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/animation_builder/mirror_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

final colorController = MovieTweenProperty<Color?>();
final otherColorController = MovieTweenProperty<Color?>();

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
    //animated Color Background
    final tween1 = MovieTween()
      ..scene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 3000))
      ..tween(
          colorController,
          ColorTween(
              begin: Color.fromARGB(255, 68, 112, 173),
              end: Color.fromARGB(255, 204, 219, 238)),
          duration: const Duration(seconds: 5))
      ..scene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 3000))
      ..tween(
          otherColorController,
          ColorTween(
              begin: Color.fromARGB(255, 204, 219, 238),
              end: Color.fromARGB(255, 68, 112, 173)),
          duration: const Duration(seconds: 5));

    /////////////////////////////
    return Scaffold(
      body: Stack(
        children: [
          //Animated Background
          MirrorAnimationBuilder<Movie>(
            tween: tween1,
            duration: tween1.duration,
            builder: (context, value, child) {
              return Container(
                width: 500,
                height: 1000,
                color: colorController.from(value),
              );
            },
          ),
          //Image Asset of Gif
          Container(
            alignment: Alignment(0, -.8),
            child: SizedBox(
              height: 170,
              child: Image(image: AssetImage("assets/7uOr.gif")),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              height: 146,
              width: 345,
              child: MirrorAnimationBuilder<Movie>(
                tween: tween1,
                duration: tween1.duration,
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                        color: otherColorController.from(value),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  );
                },
              ),
            ),
          ),
          //Timer
          Container(
            alignment: Alignment.center,
            //this will be the actual timer widget
            child: TimerCountdown(
              format: CountDownTimerFormat.minutesSeconds,
              endTime: DateTime.now().add(Duration(minutes: 0, seconds: 5)),
              timeTextStyle:
                  TextStyle(fontStyle: FontStyle.italic, fontSize: 70),
              descriptionTextStyle:
                  TextStyle(fontSize: 40, color: Colors.black.withOpacity(.6)),
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
        ],
      ),
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 0, 111, 70),
      //   title: Text('Break Time!'),
      // )
    );
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
