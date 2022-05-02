import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;

  PrimaryButton(this.text, this.onTap,
      {Key? key,
      this.backgroundColor = AppColors.PRIMARY_YELLOW,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 55),
      backgroundColor: backgroundColor,
      primary: textColor,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );

    return TextButton(
        onPressed: () {
          onTap();
        },
        style: _flatButtonStyle,
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ));
  }
}
