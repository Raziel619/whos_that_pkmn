import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/constants/asset_paths.dart';
import 'package:whos_that_pkmn/models/play_record.dart';
import 'package:whos_that_pkmn/providers/ad_provider.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';
import 'package:whos_that_pkmn/services/audio_player.dart';
import 'package:whos_that_pkmn/utils/extensions.dart';
import 'package:whos_that_pkmn/widgets/buttons/primary_button.dart';
import '../../constants/app_arrays.dart';
import '../../services/push_notifications.dart';

class PlayPartial extends StatefulWidget {
  PokeProvider pokeProvider;

  PlayPartial(this.pokeProvider, {Key? key}) : super(key: key);

  @override
  State<PlayPartial> createState() => _PlayPartialState();
}

class _PlayPartialState extends State<PlayPartial> with WidgetsBindingObserver {
  final _audioService = AudioService();
  double? _textFieldWidth;
  bool _textFieldEnabled = true;
  bool _showName = false;
  Color _bgColor = Colors.white;
  String _image = "";
  String _guess = "";
  ColorFilter _bw_filter = ColorFilter.matrix(AppArrays.BW_FILTER);
  bool _isKeyboardOpen = false;
  late int _quizNum;
  late PlayRecord _currentPokeGuess;
  late AdProvider _adProvider;

  @override
  void initState() {
    super.initState();
    _adProvider = Provider.of<AdProvider>(context, listen: false);
    _currentPokeGuess = widget.pokeProvider.currentPokeQuiz()!;
    _quizNum = widget.pokeProvider.getCurrentQuizNumber();
    _image = _currentPokeGuess.sprite_url;
    _textFieldWidth = _currentPokeGuess.pokemon.name.length > 6 ? 30 : null;
    WidgetsBinding.instance?.addObserver(this);
    _audioService.playOneShot(AssetPaths.SFX_NEW_QUIZ);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    _audioService.dispose();
  }

  @override
  void didChangeMetrics() {
    final _isOpen =
        (WidgetsBinding.instance?.window.viewInsets.bottom ?? 0) > 0;

    if (_isKeyboardOpen != _isOpen) {
      setState(() {
        _isKeyboardOpen = _isOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pokeProvider.todayQuizzes);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _isKeyboardOpen
              ? SizedBox.shrink()
              : DelayedDisplay(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    child: Text(
                      "Who's That\nPkmn?!",
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5, fontSize: 22),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
                "${_quizNum}/${widget.pokeProvider.todayQuizzes.length}",
                style: TextStyle(height: 1.5, fontSize: 18)),
          ),
          Expanded(
            child: Container(
              width: (MediaQuery.of(context).size.width * 0.75),
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
              child: Column(
                children: [
                  if (_currentPokeGuess.generation != null)
                    Text(
                      "Gen ${_currentPokeGuess.generation.toString()}",
                      style: TextStyle(color: _cardTxtColor()),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  _showName
                      ? Text(_currentPokeGuess.pokemon.name.capitalize(),
                          style:
                              TextStyle(color: _cardTxtColor(), fontSize: 20))
                      : SizedBox.shrink(),
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: _bw_filter,
                      child: _imageWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isKeyboardOpen
              ? SizedBox.shrink()
              : SizedBox(
                  height: 30,
                ),
          Container(
              color: AppColors.GREY_1.withOpacity(0.85),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  left: 8, right: 8, bottom: _isKeyboardOpen ? 0 : 16),
              child: _showName
                  ? _nextBtn(widget.pokeProvider)
                  : PinCodeTextField(
                      autoFocus: widget.pokeProvider.isFirstQuiz(),
                      enabled: _textFieldEnabled,
                      appContext: context,
                      cursorColor: AppColors.TEXT_DARK,
                      length: _currentPokeGuess.pokemon.name.length,
                      onChanged: (String value) {
                        final audio = _guess.length > value.length
                            ? AssetPaths.SFX_CHAR_DELETE
                            : AssetPaths.SFX_CHAR_ADD;
                        _audioService.playOneShot(audio);
                        _guess = value;
                      },
                      onCompleted: (String value) {
                        if (widget.pokeProvider.isLastQuiz()) {
                          PushNotifications.cancelTodayNotification();
                          _adProvider.interstitialAd?.show();
                        }

                        final wasCorrect = widget.pokeProvider.attemptPokeGuess(
                            _currentPokeGuess.pokemon.name, value);
                        _audioService.playOneShot(wasCorrect
                            ? AssetPaths.SFX_GUESS_CORRECT
                            : AssetPaths.SFX_GUESS_WRONG);
                        setState(() {
                          _textFieldEnabled = false;
                          _showName = true;
                          _bw_filter = ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          );
                          _bgColor = wasCorrect
                              ? AppColors.PRIMARY_GREEN
                              : AppColors.PRIMARY_RED;
                        });
                      },
                      pinTheme: PinTheme(
                          fieldWidth: _textFieldWidth,
                          inactiveColor: AppColors.TEXT_DARK,
                          selectedColor: AppColors.TEXT_DARK),
                    )),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return FadeInImage.memoryNetwork(
      key: UniqueKey(),
      fadeInDuration: Duration(seconds: 1),
      placeholder: widget.pokeProvider.pokeballIcon,
      placeholderScale: 0.1,
      fit: BoxFit.fitWidth,
      image: _image,
    );
  }

  Color _cardTxtColor() {
    return _bgColor == AppColors.PRIMARY_RED
        ? Colors.white
        : AppColors.TEXT_DARK;
  }

  Widget _resultText() {
    if (_bgColor == Colors.white) {
      return SizedBox.shrink();
    } else if (_bgColor == AppColors.PRIMARY_GREEN) {
      return Text(
        "Yay! You got it Correct!",
        style: TextStyle(color: AppColors.TEXT_DARK),
        textAlign: TextAlign.center,
      );
    }

    return Text(
      "Awwww, Better luck on the next one.",
      style: TextStyle(color: AppColors.PRIMARY_RED),
      textAlign: TextAlign.center,
    );
  }

  Widget _nextBtn(PokeProvider pokeProvider) {
    final widgets = pokeProvider.isTodayQuizzesComplete()
        ? [
            Text(
              "Daily Quiz Complete!\n\nCome Back Tomorrow",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
          ]
        : [
            _resultText(),
            SizedBox(
              height: 10,
            ),
            PrimaryButton("Next", () {
              pokeProvider.rebuildListeners();
            })
          ];

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ...widgets,
      ],
    );
  }
}
