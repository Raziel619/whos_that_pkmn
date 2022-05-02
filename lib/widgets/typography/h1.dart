import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String text;

  const H1(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        height: 1.4,
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }
}
