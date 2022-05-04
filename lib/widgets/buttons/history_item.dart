import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/constants/asset_paths.dart';
import 'package:whos_that_pkmn/models/play_record.dart';
import 'package:whos_that_pkmn/utils/extensions.dart';

class HistoryItem extends StatelessWidget {
  final PlayRecord playRecord;

  const HistoryItem(this.playRecord, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      //fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 55),
      backgroundColor: playRecord.wasCorrect
          ? AppColors.PRIMARY_GREEN
          : AppColors.PRIMARY_RED,
      primary: playRecord.wasCorrect ? AppColors.TEXT_DARK : Colors.white,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
          style: _flatButtonStyle,
          onPressed: () {
            print("pressed");
          },
          child: Row(
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.65,
                  widthFactor: 0.65,
                  child: CachedNetworkImage(
                    imageUrl: playRecord.sprite_url,
                    height: 80,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(playRecord.pokemon.name.capitalize()),
              )),
            ],
          )),
    );
  }
}
