import 'package:earbender/now_playing.dart';
import 'package:flutter/material.dart';

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
