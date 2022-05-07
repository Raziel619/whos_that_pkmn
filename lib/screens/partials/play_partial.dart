import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/models/play_record.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';
import 'package:whos_that_pkmn/widgets/buttons/primary_button.dart';
import '../../constants/app_arrays.dart';

class PlayPartial extends StatefulWidget {
  PokeProvider pokeProvider;

  PlayPartial(this.pokeProvider, {Key? key}) : super(key: key);

  @override
  State<PlayPartial> createState() => _PlayPartialState();
}

class _PlayPartialState extends State<PlayPartial> with WidgetsBindingObserver {
  double? _textFieldWidth;
  bool _textFieldEnabled = true;
  bool _showName = false;
  Color _bgColor = Colors.white;
  String _image = "";
  ColorFilter _bw_filter = ColorFilter.matrix(AppArrays.BW_FILTER);
  bool _isKeyboardOpen = false;
  final _textEditingController = TextEditingController();
  late PlayRecord _currentPokeGuess;

  @override
  void initState() {
    super.initState();
    _currentPokeGuess = widget.pokeProvider.currentPokeQuiz()!;
    _image = _currentPokeGuess.sprite_url;
    _textFieldWidth = _currentPokeGuess.pokemon.name.length > 6 ? 30 : null;
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
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
            child: Text("1/3", style: TextStyle(height: 1.5, fontSize: 18)),
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
                      ? Text(_currentPokeGuess.pokemon.name,
                          style: TextStyle(color: _cardTxtColor()))
                      : SizedBox.shrink(),
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: _bw_filter,
                      child: FadeInImage.memoryNetwork(
                        //width: (MediaQuery.of(context).size.width * 0.6),
                        placeholder: widget.pokeProvider.pokeballIcon,
                        placeholderScale: 0.1,
                        fit: BoxFit.fitHeight,
                        image: _image,
                      ),
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
                      enabled: _textFieldEnabled,
                      appContext: context,
                      cursorColor: AppColors.TEXT_DARK,
                      length: _currentPokeGuess.pokemon.name.length,
                      onChanged: (String value) {},
                      onCompleted: (String value) {
                        final wasCorrect = widget.pokeProvider.attemptPokeGuess(
                            _currentPokeGuess.pokemon.name, value);
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

  Color _cardTxtColor() {
    return _bgColor == AppColors.PRIMARY_RED
        ? Colors.white
        : AppColors.TEXT_DARK;
  }

  Widget _resultText() {
    if (_bgColor == Colors.white) {
      return SizedBox.shrink();
    } else if (_bgColor == AppColors.PRIMARY_GREEN) {
      return Text("Yay! You got it Correct!",
          style: TextStyle(color: AppColors.TEXT_DARK), textAlign: TextAlign.center,);
    }

    return Text("Awwww, Better luck next time.",
        style: TextStyle(color: AppColors.PRIMARY_RED), textAlign: TextAlign.center,);
  }

  Widget _nextBtn(PokeProvider pokeProvider) {
    final widgets = pokeProvider.isTodayQuizzesComplete()
        ? [
            Text(
              "Daily Quiz Complete!\n\nCome Back Tomorrow",
              textAlign: TextAlign.center,
            )
          ]
        : [
          _resultText(),
      SizedBox(height: 10,),
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
