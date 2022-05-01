import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/play_record.dart';
import '../models/pokedex_record.dart';

String buildIdFromDate(DateTime date) {
  return DateFormat('yMd').format(date);
}

int buildIdIntFromDate(DateTime date) {
  return int.tryParse(DateFormat('dMy').format(date)) ?? 0;
}

Future<List<PlayRecord>> convertDexToPlayRecords(
    List<PokedexRecord> records) async {
  List<PlayRecord> playRecords = List<PlayRecord>.empty(growable: true);
  for (var record in records) {
    final pokemonData = await http.get(Uri.parse(record.url));
    final spriteUrl = extractSpriteUrl(jsonDecode(pokemonData.body));
    final playRecord = PlayRecord(record, spriteUrl ?? "");
    playRecords.add(playRecord);
  }

  return playRecords;
}

String? extractSpriteUrl(dynamic response) {
  final keys = [
    "front_default",
    "front_female",
    "front_shiny",
    "front_shiny_female"
  ];

  for (final key in keys) {
    final url = response["sprites"][key];
    if (url != null) {
      return url;
    }
  }

  return null;
}
