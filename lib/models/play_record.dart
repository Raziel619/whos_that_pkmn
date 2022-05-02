// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:whose_that_pkmn/models/pokedex_record.dart';

part 'play_record.g.dart';

@JsonSerializable()
class PlayRecord {
  final PokedexRecord pokemon;
  final String sprite_url;
  bool attempted;
  bool wasCorrect;

  PlayRecord(this.pokemon, this.sprite_url,
      {this.attempted = false, this.wasCorrect = false});

  factory PlayRecord.fromJson(Map<String, dynamic> json) =>
      _$PlayRecordFromJson(json);

  Map<String, dynamic> toJson() => _$PlayRecordToJson(this);

  @override
  String toString() {
    return "(${pokemon.name} - $sprite_url)";
  }
}
