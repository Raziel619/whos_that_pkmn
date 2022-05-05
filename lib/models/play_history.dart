import 'package:json_annotation/json_annotation.dart';
import 'package:whos_that_pkmn/models/play_record.dart';

part 'play_history.g.dart';

@JsonSerializable()
class PlayHistory {
  final Map<String, List<PlayRecord>> records;

  PlayHistory(this.records);

  factory PlayHistory.fromJson(Map<String, dynamic> json) =>
      _$PlayHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PlayHistoryToJson(this);

  List<String> recordNames() {
    var names = List<String>.empty(growable: true);

    records.forEach((date, pkmns) {
      for (var el in pkmns) {
        names.add(el.pokemon.name);
      }
    });

    return names;
  }

  Map<String, int> getStats() {
    Map<String, int> stats = {"correct": 0, "wrong": 0};

    records.forEach((key, value) {
      for (var e in value) {
        if (e.attempted) {
          final key = e.wasCorrect ? "correct" : "wrong";
          stats[key] = stats[key]! + 1;
        }
      }
    });

    return stats;
  }
}
