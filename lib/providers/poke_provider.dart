import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whose_that_pkmn/models/pokedex_record.dart';
import 'package:whose_that_pkmn/services/local_storage.dart';

import '../constants/asset_paths.dart';
import '../models/play_history.dart';
import '../models/pokedex.dart';
import '../utils/functions.dart';

class PokeProvider with ChangeNotifier {
  late PlayHistory _playHistory;
  late PlayHistory _todayQuizzes;
  late Pokedex _remainingPokemon;

  Future<void> initialize() async {
    print("Initializing PokeProvider");

    try {
      // Build reaming pokemon
      await _buildRemainingPokemon();

      // Reading PlayHistory
      final jsonPlayHistory = LocalStorage.retrieveLSKey(LSKey.playHistory);
      _playHistory = jsonPlayHistory == null
          ? PlayHistory({})
          : PlayHistory.fromJson(jsonDecode(jsonPlayHistory));

      await _buildTodayQuizzes();
    } catch (e) {
      print("Error initializing PlayHistory/TodayQuizzes");
      _playHistory = PlayHistory({});
      _todayQuizzes = PlayHistory({});
    }
  }

  //region Remaining Pokemon

  /// Fetches remaining pokemon from local storage
  /// If it is null, load full pokedex
  Future<void> _buildRemainingPokemon() async {
    final jsonRemainingPokemon =
        LocalStorage.retrieveLSKey(LSKey.remainingPokemon);
    if (jsonRemainingPokemon == null) {
      await _resetRemainingPokemon();
    } else {
      _remainingPokemon = Pokedex.fromJson(jsonDecode(jsonRemainingPokemon));
    }
  }

  Future<void> _resetRemainingPokemon() async {
    _remainingPokemon = await _getFullPokedex();
    await _saveRemainingPokemon();
  }

  Future<void> _saveRemainingPokemon() async {
    final jsonString = jsonEncode(_remainingPokemon.toJson());
    await LocalStorage.saveLSKey(LSKey.remainingPokemon, jsonString);
  }

  //endregion

  Future<void> _buildTodayQuizzes() async {
    // Reading Today Quizzes
    final jsonTodayQuizzes = LocalStorage.retrieveLSKey(LSKey.todayQuizzes);
    _todayQuizzes = jsonTodayQuizzes == null
        ? PlayHistory({})
        : PlayHistory.fromJson(jsonDecode(jsonTodayQuizzes));
    // First check if today is a new data to build new quizzes

    // Pull 3 random pokemon from pokedex for today
    final quizzes = List<PokedexRecord>.empty(growable: true);
    for (int i = 0; i < 3; i++) {
      final index = Random().nextInt(_remainingPokemon.pokemon.length);
      quizzes.add(_remainingPokemon.pokemon[index]);
      _remainingPokemon.pokemon.removeAt(index);
    }

    final key = buildIdFromDate(DateTime.now());
    final playRecords = await convertDexToPlayRecords(quizzes);
    _todayQuizzes = PlayHistory({key: playRecords});

    print(_remainingPokemon.pokemon);
  }

  Future<Pokedex> _getFullPokedex() async {
    final jsonPokedex = await rootBundle.loadString(AssetPaths.JSON_POKEDEX);
    return Pokedex.fromJson(jsonDecode(jsonPokedex));
  }
}
