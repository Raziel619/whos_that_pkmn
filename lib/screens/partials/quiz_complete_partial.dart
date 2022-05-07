import 'package:flutter/material.dart';
import 'package:whos_that_pkmn/constants/asset_paths.dart';
import 'package:whos_that_pkmn/widgets/buttons/primary_button.dart';

import '../../constants/app_colors.dart';
import '../../widgets/typography/h1.dart';

class QuizCompletePartial extends StatelessWidget {
  const QuizCompletePartial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            H1("Daily Quiz \n Complete!"),
            Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
              child: Image.asset(AssetPaths.ICON_SNORLAX),
            ),
            H1("See You \nTomorrow!"),
            Expanded(child: SizedBox.shrink()),
            PrimaryButton(
              "Share Result",
              () {
                print("Clicked");
              },
              textColor: Colors.white,
              backgroundColor: AppColors.PRIMARY_BLUE,
            ),
            SizedBox(
              height: 20,
            ),
            PrimaryButton("Leaderboard", () {
              print("Clicked");
            }),
          ],
        ),
      ),
    );
  }
}
