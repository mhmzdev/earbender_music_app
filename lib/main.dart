import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/main/presentation/bloc/main_bloc.dart';
import 'features/main/presentation/pages/now_playing.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
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
        create: (context) => sl<MainBloc>(),
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
