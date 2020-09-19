import 'package:earbender/core/utils/no_glow_scholl_behavior.dart';
import 'package:flutter/material.dart';

import 'background_color_grid_tile_widget.dart';

class BackgroundColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          children: [
            ColoredTiles(tileColor: Colors.grey[50]),
            ColoredTiles(tileColor: Colors.white),
            ColoredTiles(tileColor: Colors.white),
            ColoredTiles(tileColor: Colors.grey[50]),
            ColoredTiles(tileColor: Colors.grey[50]),
            ColoredTiles(tileColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
