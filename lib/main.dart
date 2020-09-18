import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/main/presentation/bloc/main_bloc.dart';
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
      home: BlocProvider(
        create: (context) => MainBloc(),
        child: Builder(
          builder: (context) => NowPlaying(
            blocContext: context,
            maxSlide: MediaQuery.of(context).size.width * 0.9,
          ),
        ),
      ),
    );
  }
}
