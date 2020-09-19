import 'package:earbender/features/main/presentation/bloc/main_bloc.dart';
import 'package:earbender/features/main/presentation/pages/my_drawer.dart';
import 'package:earbender/features/main/presentation/pages/my_saved_music.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  final BuildContext blocContext;
  bool _isSaved = false;

  MainPage({Key key, this.blocContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is OpenMain) {
          _isSaved = false;
        } else if (state is OpenSaved || _isSaved) {
          _isSaved = true;
          return MySavedMusic(blocContext: blocContext);
        }

        return MyDrawer(blocContext: blocContext);
      },
    );
  }
}
