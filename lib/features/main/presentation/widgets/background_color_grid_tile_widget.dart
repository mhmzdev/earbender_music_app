import 'package:flutter/material.dart';

class ColoredTiles extends StatelessWidget {
  final Color tileColor;
  ColoredTiles({this.tileColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileColor,
    );
  }
}
