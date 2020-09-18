import 'package:flutter/material.dart';

import 'features/main/presentation/pages/now_playing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: Builder(
        builder: (context) => NowPlaying(
          maxSlide: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
