import 'package:json_annotation/json_annotation.dart';
import 'package:whose_that_pkmn/models/play_record.dart';

part 'play_history.g.dart';

@JsonSerializable()
class PlayHistory {
  final Map<String, List<PlayRecord>> records;

  PlayHistory(this.records);

  factory PlayHistory.fromJson(Map<String, dynamic> json) =>
      _$PlayHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PlayHistoryToJson(this);

  List<String> record_names() {
    var names = List<String>.empty(growable: true);

    records.forEach((date, pkmns) {
      for (var el in pkmns) {
        names.add(el.pokemon.name);
      }
    });

    return names;
  }
}
