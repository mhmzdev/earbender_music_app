/*

  A wrapper to decide what is shown from either 'My Drawer' or 'My Saved Music'

*/

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
    // A Bloc Builder is triggered when the state changes and plays the part
    // of setState hence the widget can be still defined as stateless without any issues
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
