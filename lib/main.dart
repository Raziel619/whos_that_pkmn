import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whos_that_pkmn/app.dart';
import 'package:whos_that_pkmn/providers/ad_provider.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<PokeProvider>(
        create: (context) => PokeProvider()),
    ChangeNotifierProvider<AdProvider>(create: (context) => AdProvider())
  ], child: const MyApp()),);
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

