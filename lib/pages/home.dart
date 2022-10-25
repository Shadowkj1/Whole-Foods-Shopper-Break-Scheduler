// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Schedule');
                    },
                    child: Text('button 1'))),
            SizedBox(
              height: 15,
            ),
            SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {}, child: Text('just for github test'))),
            SizedBox(
              height: 5,
            ),
          ])
        ],
      )),
    );
  }
}
