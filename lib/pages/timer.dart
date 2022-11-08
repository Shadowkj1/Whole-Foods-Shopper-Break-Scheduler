import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  DateTime shift = DateTime.now();
  var userRef = FirebaseFirestore.instance.collection('Shopper');
  User? aUser = FirebaseAuth.instance.currentUser;

  void initState() {
    //_fetch2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
                alignment: Alignment(0, -1),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: _fetch2(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Text('Loading....');
                            }
                            return Text('shift time: $shift');
                          })
                    ])),
            Container(
              alignment: Alignment(.92, .988),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 6, 87, 8))),
                  onPressed: () async {},
                  child: Text('Set Break Time')),
            )
          ],
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 6, 87, 8),
          title: Text('Timer'),
        ));
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
