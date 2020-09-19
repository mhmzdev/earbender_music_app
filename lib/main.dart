import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/main/presentation/bloc/main_bloc.dart';
import 'features/main/presentation/pages/now_playing.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  // To let flutter know that whereever the injector has been used,
  // it should initialize all of those, before starting the app fully
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Wait for the injector to finish defining all dependents
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
