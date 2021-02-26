import 'package:flutter/material.dart';

import 'package:speed_typer/pages/game_screen.dart';
import 'package:speed_typer/pages/result.dart';
import 'package:speed_typer/pages/catalog.dart';

import './theme.dart';

import './widgets/home_title.dart';
import './widgets/get_started.dart';

void main() {
  runApp(MaterialApp(
    theme: AppThemeDataFactory.prepareThemeData(),
    title: 'Speed Typer',
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      '/play': (context) => GameScreen(),
      '/result': (context) =>
          ResultScreen(ModalRoute.of(context).settings.arguments),
      '/catalog': (context) => Catalog()
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [HomeTitle(), GetStarted()],
      ),
    );
  }
}
