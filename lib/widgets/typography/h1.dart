import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String text;
  final Color textColor;

  const H1(this.text, {this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        height: 1.4,
        fontSize: 20,
        color: textColor,
      ),
    );
  }
}
