import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whos_that_pkmn/providers/poke_provider.dart';
import 'package:whos_that_pkmn/screens/partials/play_partial.dart';
import '../constants/app_colors.dart';
import '../constants/asset_paths.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.IMG_BG_MAIN), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.2),
        body: Consumer<PokeProvider>(builder: (context, pokeProvider, child) {
          final key = UniqueKey();
          switch (_selectedIndex) {
            case 0:
              return pokeProvider.isTodayQuizzesComplete()
                  ? Text("Quizzes complete")
                  : PlayPartial(
                      pokeProvider,
                      key: key,
                    );
            case 1:
              return Text("Leaderboard");
            default:
              return Text("History");
          }
        }),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: _selectedIndex == 0
              ? AppColors.GREY_1.withOpacity(0.85)
              : Colors.transparent,
          color: AppColors.PRIMARY_PINK_COMP,
          items: const <Widget>[
            Icon(Icons.question_mark_rounded, size: 30),
            Icon(Icons.leaderboard_rounded, size: 30),
            Icon(Icons.list_alt_rounded, size: 30)
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
