

import 'package:flutter/material.dart';
import 'package:whose_that_pkmn/constants/app_colors.dart';
import 'package:whose_that_pkmn/constants/asset_paths.dart';

class LoadingScreen extends StatelessWidget{
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_PINK,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Populating PokeDex',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Image(image: AssetImage(AssetPaths.ICON_POKEBALL), width: 120,),
            ),
            Text('Please Wait...', style: TextStyle(fontSize: 16),)
          ],
        ),
      ),
    );
  }

}