import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:whose_that_pkmn/providers/poke_provider.dart';
import '../../constants/app_arrays.dart';

class PlayPartial extends StatefulWidget {
  PokeProvider pokeProvider;

  PlayPartial(this.pokeProvider, {Key? key}) : super(key: key);

  @override
  State<PlayPartial> createState() => _PlayPartialState();
}

class _PlayPartialState extends State<PlayPartial> with WidgetsBindingObserver {
  String _image = "";
  ColorFilter _bw_filter = ColorFilter.matrix(AppArrays.BW_FILTER);
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    _image = widget.pokeProvider.todayQuizzes[0].sprite_url;
    WidgetsBinding.instance?.addObserver(this);
    // Future.delayed(const Duration(milliseconds: 10000), () {
    //   setState(() {
    //     _bw_filter = ColorFilter.mode(
    //       Colors.transparent,
    //       BlendMode.multiply,
    //     );
    //   });
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance?.window.viewInsets.bottom ?? 0;
    setState(() {
      _isKeyboardOpen = value > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(top: 30),
            child: Text("1/3", style: TextStyle(height: 1.5, fontSize: 18)),
          ),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            child: ColorFiltered(
              colorFilter: _bw_filter,
              child: FadeInImage.memoryNetwork(
                width: (MediaQuery.of(context).size.width * 0.6),
                placeholder: widget.pokeProvider.pokeballIcon,
                placeholderScale: 0.1,
                fit: BoxFit.fitHeight,
                image: _image,
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ],
      ),
    );
  }
}