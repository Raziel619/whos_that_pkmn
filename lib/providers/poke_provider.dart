import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whos_that_pkmn/models/play_record.dart';
import 'package:whos_that_pkmn/models/pokedex_record.dart';
import 'package:whos_that_pkmn/services/local_storage.dart';

import '../constants/asset_paths.dart';
import '../models/play_history.dart';
import '../models/pokedex.dart';
import '../utils/functions.dart';

class PokeProvider with ChangeNotifier {
  late PlayHistory _playHistory;
  late PlayHistory _todayQuizzes;
  late Pokedex _remainingPokemon;
  late Uint8List _pokeballIcon;
  String todaysKey = buildIdFromDate(DateTime.now());

  Uint8List get pokeballIcon => _pokeballIcon;

  List<PlayRecord> get todayQuizzes => _todayQuizzes.records[todaysKey] ?? [];
  PlayHistory get playHistory => _playHistory;
  PlayHistory get todayQuizzesMap => _todayQuizzes;

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

      // Reading pokeball asset image to uintlist
      _pokeballIcon = (await rootBundle.load(AssetPaths.IMG_PLACEHOLDER))
          .buffer
          .asUint8List();

      await _buildTodayQuizzes();
    } catch (e) {
      print("Error initializing PlayHistory/TodayQuizzes - ${e.toString()}");
      _playHistory = PlayHistory({});
      _todayQuizzes = PlayHistory({});
    }
  }

  Future<dynamic> _getExamplePokemon() async {
    final jsonDitto = await rootBundle.loadString(AssetPaths.JSON_DITTO);
    return jsonDecode(jsonDitto);
  }

  //region Notify Listeners Methods

  bool attemptPokeGuess(String name, String guess) {
    name = name.toLowerCase();
    guess = guess.toLowerCase();
    final isCorrect = (name == guess);
    final index = todayQuizzes.indexWhere((e) => e.pokemon.name == name);
    _todayQuizzes.records[todaysKey]![index].attempted = true;
    _todayQuizzes.records[todaysKey]![index].wasCorrect = isCorrect;
    _saveTodayQuizzes();
    return isCorrect;
  }

  void rebuildListeners() {
    notifyListeners();
  }

  //endregion

  //region Play History
  Future<void> _savePlayHistory() async {
    final jsonString = jsonEncode(_playHistory.toJson());
    await LocalStorage.saveLSKey(LSKey.playHistory, jsonString);
  }

  Map<String, int> getPlayerStats(){
    final todayStats = todayQuizzesMap.getStats();
    final historyStats = playHistory.getStats();
    final correct = (todayStats["correct"] ?? 0) + (historyStats["correct"] ?? 0);
    final wrong = (todayStats["wrong"] ?? 0) + (historyStats["wrong"] ?? 0);
    return {
      "correct": correct,
      "wrong": wrong
    };
  }

  //endregion

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

  //region Today Quizzes
  bool isFirstQuiz(){
    return todayQuizzes[0].attempted;
  }

  PlayRecord? currentPokeQuiz() {
    return todayQuizzes.firstWhere((e) => !e.attempted);
  }

  bool isTodayQuizzesComplete() {
    return !(todayQuizzes.any((e) => !e.attempted));
  }

  Future<void> _buildTodayQuizzes() async {
    // Reading Today Quizzes
    final jsonTodayQuizzes = LocalStorage.retrieveLSKey(LSKey.todayQuizzes);
    _todayQuizzes = jsonTodayQuizzes == null
        ? PlayHistory({})
        : PlayHistory.fromJson(jsonDecode(jsonTodayQuizzes));

    // First check if today is a new data to build new quizzes

    if (_todayQuizzes.records.containsKey(todaysKey)) {
      return;
    } else {
      // New day, save todayQuizzes into history and clear it
      _playHistory.records.addAll(_todayQuizzes.records);
      _todayQuizzes = PlayHistory({});
      await _saveTodayQuizzes();
      await _savePlayHistory();
    }

    // Pull 3 random pokemon from pokedex for today
    final quizzes = List<PokedexRecord>.empty(growable: true);
    for (int i = 0; i < 3; i++) {
      final index = Random().nextInt(_remainingPokemon.pokemon.length);
      quizzes.add(_remainingPokemon.pokemon[index]);
      _remainingPokemon.pokemon.removeAt(index);
    }

    final playRecords = await convertDexToPlayRecords(quizzes);
    _todayQuizzes = PlayHistory({todaysKey: playRecords});

    // If the remaining pokemon count is less than 3, reset it
    if (_remainingPokemon.pokemon.length <= 3) {
      await _resetRemainingPokemon();
    }

    // Save object changes to local storage
    await _saveRemainingPokemon();
    await _saveTodayQuizzes();
  }

  Future<void> _saveTodayQuizzes() async {
    final jsonString = jsonEncode(_todayQuizzes.toJson());
    await LocalStorage.saveLSKey(LSKey.todayQuizzes, jsonString);
  }

  //endregion

  Future<Pokedex> _getFullPokedex() async {
    final jsonPokedex = await rootBundle.loadString(AssetPaths.JSON_POKEDEX);
    return Pokedex.fromJson(jsonDecode(jsonPokedex));
  }
}
