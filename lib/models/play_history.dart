import 'package:json_annotation/json_annotation.dart';
import 'package:whose_that_pkmn/models/play_record.dart';
import 'package:whose_that_pkmn/models/pokedex_record.dart';

part 'play_history.g.dart';

@JsonSerializable()
class PlayHistory{
  final List<PlayRecord> records;

  PlayHistory(this.records);

  factory PlayHistory.fromJson(Map<String, dynamic> json) => _$PlayHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PlayHistoryToJson(this);

}