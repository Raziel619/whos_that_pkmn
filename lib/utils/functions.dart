import 'package:intl/intl.dart';

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
    final playRecord = PlayRecord(record, "");
    playRecords.add(playRecord);
  }

  return playRecords;
}
