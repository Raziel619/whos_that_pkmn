import 'dart:convert';
import 'package:numerus/numerus.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:whos_that_pkmn/constants/urls.dart';
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
    // Getting sprite url
    final pokemonData = await http.get(Uri.parse(record.url));
    final spriteUrl = extractSpriteUrl(jsonDecode(pokemonData.body));

    // Getting generation
    final speciesUrl = Urls.POKEAPI_SPECIES + record.name;
    final pokemonSpecies = await http.get(Uri.parse(speciesUrl));
    final gen = extractGeneration(jsonDecode(pokemonSpecies.body));
    final playRecord = PlayRecord(record, spriteUrl ?? "", gen);
    playRecords.add(playRecord);
  }

  return playRecords;
}

int? extractGeneration(dynamic response) {
  String gen = response["generation"]["name"];
  gen = gen.replaceAll("generation-", "").toUpperCase();
  return gen.toRomanNumeralValue();
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
