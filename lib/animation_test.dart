// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimationBackground extends StatelessWidget {
  AnimationBackground({super.key});

  final colorController = MovieTweenProperty<Color?>();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //the tweens
    final tween1 = MovieTween()
      ..scene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 3000))
      ..tween(
          colorController,
          ColorTween(
              begin: Color.fromARGB(255, 184, 196, 119),
              end: Color.fromARGB(255, 187, 11, 11)),
          duration: const Duration(seconds: 30))
      ..scene(
              begin: const Duration(seconds: 1),
              end: const Duration(seconds: 3))
          .tween(colorController, ColorTween(begin: Colors.yellow, end: Colors.blue));
    // .thenTween('color2',
    //     ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600),
    //     duration: const Duration(seconds: 3), curve: Curves.easeOut);

    //whats actually returned
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Animation screen')),
        backgroundColor: Colors.white,
        body: Center(
          child: MirrorAnimationBuilder<Movie>(
            tween: tween1,
            duration: tween1.duration,
            builder: (context, value, child) {
              return Container(
                width: 500,
                height: 800,
                color: colorController.from(value),
              );
            },
          ),
        ),
      ),
    );
  }
}
