import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:whose_that_pkmn/constants/app_arrays.dart';

import '../constants/asset_paths.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _image =
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/132.png";
  ColorFilter _bw_filter = ColorFilter.matrix(AppArrays.BW_FILTER);

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetPaths.IMG_BG_MAIN),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.white.withOpacity(0.2),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  isKeyboardVisible
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 30),
                          child: Text(
                            "Who's That\nPkmn?!",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.5, fontSize: 22),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text("1/3",
                        style: TextStyle(height: 1.5, fontSize: 18)),
                  ),
                  Expanded(
                    child: Container(
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
                          placeholder: Uint8List(2),
                          fit: BoxFit.fitHeight,
                          image: _image,
                        ),
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
      },
    );
  }
}
