import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:whose_that_pkmn/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(title: 'Flutter Demo Home Page'),
    );
  }
}

