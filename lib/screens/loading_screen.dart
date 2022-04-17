

import 'package:flutter/material.dart';
import 'package:whose_that_pkmn/constants/app_colors.dart';

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
              'Loading',
            ),
          ],
        ),
      ),
    );
  }

}