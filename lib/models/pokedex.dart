import 'package:json_annotation/json_annotation.dart';
import 'package:whose_that_pkmn/models/pokedex_record.dart';

part 'pokedex.g.dart';

@JsonSerializable()
class Pokedex {
  final List<PokedexRecord> pokemon;

  Pokedex(this.pokemon);

  factory Pokedex.fromJson(Map<String, dynamic> json) =>
      _$PokedexFromJson(json);

  Map<String, dynamic> toJson() => _$PokedexToJson(this);

  List<String> names() {
    var names = List<String>.empty(growable: true);

    for (var el in pokemon) {
      names.add(el.name);
    }

    return names;
  }

  PokedexRecord search_records(String name) {
    return pokemon.firstWhere((el) => el.name == name);
  }
}
