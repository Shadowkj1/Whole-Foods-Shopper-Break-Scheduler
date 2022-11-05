import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [],
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 6, 87, 8),
          title: Text('Timer'),
        ));
  }
}
