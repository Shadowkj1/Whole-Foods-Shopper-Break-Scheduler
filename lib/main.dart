import 'package:amazonbreak/pages/login.dart';
import 'package:amazonbreak/pages/schedule.dart';
import 'package:amazonbreak/pages/timer.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => Home(),
    '/Schedule': (context) => Schedule(),
    '/Login': (context) => Login(),
    '/Timer': (context) => Timer(),
  }));
}
