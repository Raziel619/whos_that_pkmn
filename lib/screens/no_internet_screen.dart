import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/constants/asset_paths.dart';
import 'package:whos_that_pkmn/widgets/buttons/primary_button.dart';

import '../services/internet_checker.dart';
import '../widgets/typography/h1.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H1(
          "Who's That Pkmn?!",
          textColor: AppColors.TEXT_DARK,
        ),
        backgroundColor: AppColors.PRIMARY_PINK,
      ),
      body: Container(
        color: Colors.black.withOpacity(0.8),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
                child: Image.asset(AssetPaths.ICON_EGG),
              ),
            ),
            H1("No Internet Connection"),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "This app requires an active internet connection to provide you with the best of information",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, letterSpacing: 1.5, height: 1.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: PrimaryButton(
                "Try Again",
                  () async {
                    await InternetChecker.initialize();
                    Fluttertoast.showToast(
                        msg: InternetChecker.isConnected
                            ? "Restarting"
                            : "No Internet Connection",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: InternetChecker.isConnected
                            ? Colors.greenAccent
                            : Colors.grey,
                        textColor: Colors.black,
                        fontSize: 16.0);
                    if (InternetChecker.isConnected) {
                      Phoenix.rebirth(context);
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
