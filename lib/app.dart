import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/providers/ad_provider.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';
import 'package:whos_that_pkmn/screens/loading_screen.dart';
import 'package:whos_that_pkmn/screens/main_screen.dart';
import 'package:whos_that_pkmn/services/local_storage.dart';
import 'package:flutter_app_popup_ad/flutter_app_popup_ad.dart';

class App extends StatefulWidget {
  const App({Key? key,}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late PokeProvider _pokeProvider;
  late AdProvider _adProvider;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final flutterAppPopupAd = FlutterAppPopupAd();
      flutterAppPopupAd.thisAppId = "com.raziel619.whos_that_pkmn";
      await flutterAppPopupAd
          .initializeWithUrl("https://dev.raziel619.com/ariel/api/getpreviews");
      await flutterAppPopupAd.determineAndShowAd(context, freq: 3);
    });
    _pokeProvider = Provider.of<PokeProvider>(context, listen: false);
    _adProvider = Provider.of<AdProvider>(context, listen: false);
    initialize().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> initialize() async {
    await LocalStorage.initialize();
    await LocalStorage.deleteAll();
    await _adProvider.initialize();
    await _pokeProvider.initialize();
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Who's That Pkmn?!",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: AppColors.TEXT_DARK,
          displayColor: AppColors.TEXT_DARK,
        ),
      ),
      home: _isLoading ? const LoadingScreen() : MainScreen(),
    );
  }
}
