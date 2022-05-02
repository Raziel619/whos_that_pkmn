import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/constants/asset_paths.dart';

class LoadingScreen extends StatelessWidget{
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_PINK,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Populating PokeDex',
              style: TextStyle(fontSize: 16),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 30),
            //   child: Image(image: AssetImage(AssetPaths.ICON_POKEBALL), width: 120,),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 30),
              child: Lottie.asset(AssetPaths.LOTTIE_POKEBALL),
            ),
            const Text('Please Wait...', style: TextStyle(fontSize: 16),)
          ],
        ),
      ),
    );
  }

}