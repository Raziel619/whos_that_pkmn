import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whose_that_pkmn/services/local_storage.dart';

import '../constants/asset_paths.dart';
import '../models/play_history.dart';
import '../models/pokedex_data.dart';

class PokeProvider with ChangeNotifier {
  late PlayHistory _playHistory;
  late PlayHistory _todayQuizzes;
  late PokedexData _pokedexData;

  Future<void> initialize() async {
    print("Initializing PokeProvider");

    // reading pokedex json file
    final jsonPokedex = await rootBundle.loadString(AssetPaths.JSON_POKEDEX);
    _pokedexData = PokedexData.fromJson(jsonDecode(jsonPokedex));

    try {
      // Reading PlayHistory
      final jsonPlayHistory = LocalStorage.retrieveLSKey(LSKey.playHistory);
      _playHistory = jsonPlayHistory == null
          ? PlayHistory({})
          : PlayHistory.fromJson(jsonDecode(jsonPlayHistory));

      // Reading Today Quizzes
      final jsonTodayQuizzes = LocalStorage.retrieveLSKey(LSKey.todayQuizzes);
      _todayQuizzes = jsonTodayQuizzes == null
          ? PlayHistory({})
          : PlayHistory.fromJson(jsonDecode(jsonTodayQuizzes));
    } catch (e) {
      print("Error initializing PlayHistory/TodayQuizzes");
      _playHistory = PlayHistory({});
      _todayQuizzes = PlayHistory({});
    }
  }
}
