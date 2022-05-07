import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whos_that_pkmn/app.dart';
import 'package:whos_that_pkmn/providers/ad_provider.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
      title: "Who's That Pkmn?!",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(),
    );
  }
}

