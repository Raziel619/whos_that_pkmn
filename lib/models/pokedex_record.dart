import 'package:json_annotation/json_annotation.dart';

part 'pokedex_record.g.dart';

@JsonSerializable()
class PokedexRecord{
  final String name;
  final String url;

  PokedexRecord(this.name, this.url);

  factory PokedexRecord.fromJson(Map<String, dynamic> json) => _$PokedexRecordFromJson(json);

  Map<String, dynamic> toJson() => _$PokedexRecordToJson(this);

}