import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:whose_that_pkmn/constants/app_arrays.dart';

import '../constants/asset_paths.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              const Padding(
                padding: EdgeInsets.only(top: 50, bottom: 30),
                child: Text(
                  "Who's That\nPkmn?!",
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5, fontSize: 22),
                ),
              ),
              Text("1/3", style: TextStyle(height: 1.5, fontSize: 18)),
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    )),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(AppArrays.BW_FILTER),
                  child: FadeInImage.memoryNetwork(
                    width: (MediaQuery.of(context).size.width * 0.7),
                    placeholder: Uint8List(2),
                    fit: BoxFit.fitHeight,
                    image:
                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/132.png",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
