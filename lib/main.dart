// ignore_for_file: prefer_const_constructors

import 'package:amazonbreak/pages/login2.dart';
import 'package:amazonbreak/pages/schedule.dart';
import 'package:amazonbreak/pages/timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: 
    
    
    )
  }
}


//The simple Material app return just to get to one screen at a time
/*
MaterialApp(
      home: Login(),
    );
*/

//Ye olde Routing Approach, we might have to come back here 
/*
initialRoute: '/Login', routes: {
    '/': (context) => Home(),
    '/Schedule': (context) => Schedule(),
    '/Login': (context) => Login(),
    '/Timer': (context) => Timer(),
  }

*/
/*builder: (context, child) => Scaffold(
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Home();
                  } else {
                    return Login();
                  }
                }),
          ))*/