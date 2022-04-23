import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/asset_paths.dart';
import '../models/pokedex_data.dart';

class PokeProvider with ChangeNotifier{
  Future<void> initialize() async {
    print("Initializing PokeProvider");

    // reading pokedex json file
    final jsonPokedex =
    await rootBundle.loadString(AssetPaths.JSON_POKEDEX);
    final pokedexData = PokedexData.fromJson(jsonDecode(jsonPokedex));

  }
}