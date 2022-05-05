import 'package:flutter/material.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/models/play_history.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';
import 'package:whos_that_pkmn/widgets/buttons/history_item.dart';

import '../../models/play_record.dart';
import '../../widgets/typography/h1.dart';

class HistoryPartial extends StatelessWidget {
  PokeProvider pokeProvider;

  HistoryPartial(this.pokeProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_PINK,
        centerTitle: true,
        title: H1(
          "History",
          textColor: AppColors.TEXT_DARK,
        ),
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizedBox(height: 20), ..._buildBody()],
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> widgets = List.empty(growable: true);

    if (pokeProvider.todayQuizzes.any((e) => e.attempted == true)) {
      widgets.addAll(_playHistoryWidgets(pokeProvider.todayQuizzesMap,
          onlyShowAttempted: true));
    }

    widgets.addAll(_playHistoryWidgets(pokeProvider.playHistory));

    return widgets;
  }

  List<Widget> _playHistoryWidgets(PlayHistory playHistory,
      {bool onlyShowAttempted = false}) {
    List<Widget> widgets = List.empty(growable: true);
    playHistory.records.forEach((key, records) {
      widgets.add(Text(
        " $key",
        style: TextStyle(color: Colors.white),
      ));

      for (PlayRecord record in records) {
        if (onlyShowAttempted && !record.attempted) continue;
        widgets.add(HistoryItem(record));
      }
      widgets.add(SizedBox(height: 20));
    });

    return widgets;
  }
}
