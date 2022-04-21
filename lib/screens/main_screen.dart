import 'dart:typed_data';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:whose_that_pkmn/constants/app_arrays.dart';

import '../constants/asset_paths.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  String _image =
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/132.png";
  ColorFilter _bw_filter = ColorFilter.matrix(AppArrays.BW_FILTER);
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
        // _image =
        //     "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png";
        _bw_filter = ColorFilter.mode(
          Colors.transparent,
          BlendMode.multiply,
        );
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardOpen = value > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.IMG_BG_MAIN), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _isKeyboardOpen
                  ? SizedBox.shrink()
                  : DelayedDisplay(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 30),
                        child: Text(
                          "Who's That\nPkmn?!",
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 1.5, fontSize: 22),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text("1/3", style: TextStyle(height: 1.5, fontSize: 18)),
              ),
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    )),
                child: ColorFiltered(
                  colorFilter: _bw_filter,
                  child: FadeInImage.memoryNetwork(
                    width: (MediaQuery.of(context).size.width * 0.6),
                    placeholder: Uint8List(256),
                    fit: BoxFit.fitHeight,
                    image: _image,
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
