import 'dart:io';
import 'dart:typed_data';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whose_that_pkmn/constants/app_arrays.dart';
import 'package:whose_that_pkmn/providers/poke_provider.dart';

import '../constants/app_colors.dart';
import '../constants/asset_paths.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  String _image = "";
  ColorFilter _bw_filter = ColorFilter.matrix(AppArrays.BW_FILTER);
  bool _isKeyboardOpen = false;
  late PokeProvider _pokeProvider;

  @override
  void initState() {
    super.initState();
    _pokeProvider = Provider.of<PokeProvider>(context, listen: false);
    _image = _pokeProvider.todayQuizzes[0].sprite_url;
    WidgetsBinding.instance?.addObserver(this);
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
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
                    placeholder: _pokeProvider.pokeballIcon,
                    placeholderScale: 0.1,
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
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: AppColors.PRIMAR_PINK_COMP,
          items: const <Widget>[
            Icon(Icons.question_mark_rounded, size: 30),
            Icon(Icons.leaderboard_rounded, size: 30),
            Icon(Icons.list_alt_rounded, size: 30)
          ],
          onTap: (index) {
            print("tapped");
          },
        ),
      ),
    );
  }
}
