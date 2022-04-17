import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/asset_paths.dart';

class PokeProvider with ChangeNotifier{
  Future<void> initialize() async {
    print("Initializing PokeProvider");

    // reading pokedex json file
    final jsonPokedex =
    await rootBundle.loadString(AssetPaths.POKEDEX);
    //allTokens = AllTokens.fromJson(jsonDecode(jsonTokensList));
  }
}