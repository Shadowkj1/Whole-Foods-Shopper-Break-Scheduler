// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                child: Column(
          children: [
            Text('this is the schedule screen'),
            DataTable(columns: [
              DataColumn(label: Text('data1')),
              DataColumn(label: Text('data2'))
            ], rows: [
              DataRow(cells: [
                DataCell(Text('datarow1,1')),
                DataCell(Text('datarow1,2'))
              ]),
              DataRow(cells: [
                DataCell(Text('datarow2,1')),
                DataCell(Text('datarow2,2'))
              ])
            ])
          ],
        ))),
        appBar: AppBar(
          title: Text('k'),
        ));
  }
}
