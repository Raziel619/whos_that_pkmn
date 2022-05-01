import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whose_that_pkmn/providers/poke_provider.dart';
import 'package:whose_that_pkmn/screens/loading_screen.dart';
import 'package:whose_that_pkmn/screens/main_screen.dart';
import 'package:whose_that_pkmn/services/local_storage.dart';
import 'package:flutter_app_popup_ad/flutter_app_popup_ad.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final flutterAppPopupAd = FlutterAppPopupAd();
      flutterAppPopupAd.thisAppId = "com.raziel619.whose_that_pkmn";
      await flutterAppPopupAd
          .initializeWithUrl("https://dev.raziel619.com/ariel/api/getpreviews");
      await flutterAppPopupAd.determineAndShowAd(context, freq: 3);
    });
    _pokeProvider = Provider.of<PokeProvider>(context, listen: false);
    initialize().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> initialize() async {
    await LocalStorage.initialize();
    await _pokeProvider.initialize();
    print(_pokeProvider.todayQuizzes.toJson());
    await Future.delayed(Duration(seconds: 3));
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
      home: _isLoading ? const LoadingScreen() : MainScreen(),
    );
  }
}
