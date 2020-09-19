import 'dart:io';

import 'package:earbender/core/utils/constant.dart';
import 'package:earbender/features/main/presentation/bloc/main_bloc.dart';
import 'package:earbender/features/main/presentation/widgets/playlist_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class MySavedMusic extends StatefulWidget {
  final BuildContext blocContext;

  const MySavedMusic({Key key, this.blocContext}) : super(key: key);

  @override
  _MySavedMusicState createState() => _MySavedMusicState();
}

class _MySavedMusicState extends State<MySavedMusic> {
  MainBloc _mainBloc;
  List<String> _musicPaths = [];

  @override
  void initState() {
    _mainBloc = sl<MainBloc>();

    _mainBloc.add(GetAllSavedMusicPathsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: height * 0.1,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.grey[600]),
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: height * 0.04,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        BlocProvider.of<MainBloc>(context).add(OpenMainEvent());
                      }),
                  Text(
                    'Saved Music',
                    textAlign: TextAlign.center,
                    style: kHeadingStyle,
                  ),
                ],
              ),
            ),
          ),
          body: BlocBuilder<MainBloc, MainState>(
            // States for loading, error, and loaded (none and > 0)
            cubit: _mainBloc,
            builder: (context, state) {
              if (state is LoadingSavedMusic) {
                return Container(
                  alignment: Alignment.center,
                  child: Text("Loading..."),
                );
              } else if (state is Error) {
                return _noneWidget(width);
              } else if (state is LoadedSavedMusic) {
                _musicPaths = state.musicPaths;
              }

              return getLocalMusic(width);
            },
          ),
        ),
      ),
    );
  }

  Widget getLocalMusic(double width) {
    return _musicPaths.length > 0
        ? new ListView(
            children: _musicPaths
                .map((path) => new PlayListTile(
                    blocContext: widget.blocContext, musicFile: File(path)))
                .toList())
        : _noneWidget(width);
  }

  // When the loaded list has no elements
  Widget _noneWidget(double width) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.35,
              child: Image.asset('assets/images/no_fav.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "Add music that you like\nto your list of favourites.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 17,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
