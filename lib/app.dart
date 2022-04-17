import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whose_that_pkmn/providers/poke_provider.dart';
import 'package:whose_that_pkmn/screens/loading_screen.dart';

class App extends StatefulWidget {
  const App({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late PokeProvider _pokeProvider;

  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _pokeProvider = Provider.of<PokeProvider>(context, listen: false);
    _pokeProvider.initialize();


    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Who's That Pkmn?!",

      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: _isLoading ? const LoadingScreen(): Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}
