import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/constants/asset_paths.dart';
import 'package:whos_that_pkmn/models/play_record.dart';
import 'package:whos_that_pkmn/services/audio_player.dart';
import 'package:whos_that_pkmn/utils/extensions.dart';

class HistoryItem extends StatelessWidget {
  final PlayRecord playRecord;
  final AudioService audioService;

  const HistoryItem(this.playRecord, this.audioService, {Key? key})
      : super(key: key);

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
            audioService.playOneShot(AssetPaths.SFX_CLICK);
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor: _bgColor(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAlias,
                    titlePadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              audioService.playOneShot(AssetPaths.SFX_CLICK);
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              AssetPaths.ICON_CLOSE,
                              height: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Gen ${playRecord.generation.toString()}",
                          style: _textStyle(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          playRecord.pokemon.name.capitalize(),
                          style: _textStyle(),
                        ),
                        _image(250),
                        (playRecord.wasCorrect)
                            ? Text(
                                "You Got This Correct!",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.TEXT_DARK),
                              )
                            : Text("You Got This Wrong",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Row(
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.65,
                  widthFactor: 0.65,
                  child: _image(80),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(playRecord.pokemon.name.capitalize()),
              )),
              Image.asset(
                playRecord.wasCorrect
                    ? AssetPaths.ICON_CORRECT
                    : AssetPaths.ICON_WRONG,
                height: 30,
              )
            ],
          )),
    );
  }

  Widget _image(double height) {
    return CachedNetworkImage(
      imageUrl: playRecord.sprite_url,
      height: height,
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: CircularProgressIndicator(),
      ),
      fit: BoxFit.fill,
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Color _bgColor() {
    return playRecord.wasCorrect
        ? AppColors.PRIMARY_GREEN
        : AppColors.PRIMARY_RED;
  }

  TextStyle _textStyle() {
    return TextStyle(
        color: playRecord.wasCorrect ? AppColors.TEXT_DARK : Colors.white);
  }
}
