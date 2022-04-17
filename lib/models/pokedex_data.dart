import 'package:json_annotation/json_annotation.dart';
import 'package:whose_that_pkmn/models/pokedex_record.dart';

part 'pokedex_data.g.dart';

@JsonSerializable()
class PokedexData{
  final List<PokedexRecord> pokemon;

  PokedexData(this.pokemon);

  factory PokedexData.fromJson(Map<String, dynamic> json) => _$PokedexDataFromJson(json);

  Map<String, dynamic> toJson() => _$PokedexDataToJson(this);

}