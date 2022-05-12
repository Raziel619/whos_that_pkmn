import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/models/play_history.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';
import 'package:whos_that_pkmn/services/audio_player.dart';
import 'package:whos_that_pkmn/widgets/buttons/history_item.dart';

import '../../models/play_record.dart';
import '../../widgets/typography/h1.dart';

class HistoryPartial extends StatelessWidget {
  PokeProvider pokeProvider;
  AudioService audioService;

  HistoryPartial(this.pokeProvider, this.audioService, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerStats = pokeProvider.getPlayerStats();
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
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.PRIMARY_GREEN.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: AutoSizeText(
                    "Correct: ${playerStats["correct"] ?? 0}",
                    maxLines: 1,
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.PRIMARY_RED.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: AutoSizeText(
                    "Wrong: ${playerStats["wrong"] ?? 0}",
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
              ],
            ),
            SizedBox(height: 20),
            ..._buildBody()
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> widgets = List.empty(growable: true);

    if (pokeProvider.todayQuizzes.any((e) => e.attempted == true)) {
      widgets.addAll(_playHistoryWidgets(pokeProvider.todayQuizzesMap));
    }

    widgets.addAll(_playHistoryWidgets(pokeProvider.playHistory));

    return widgets;
  }

  List<Widget> _playHistoryWidgets(PlayHistory playHistory) {
    List<Widget> widgets = List.empty(growable: true);
    playHistory.records.forEach((key, records) {
      if (records.any((element) => element.attempted)) {
        widgets.add(Text(
          " $key",
          style: TextStyle(color: Colors.white),
        ));

        for (PlayRecord record in records) {
          if (record.attempted) {
            widgets.add(HistoryItem(record));
          }
        }
        widgets.add(SizedBox(height: 20));
      }
    });

    return widgets;
  }
}
