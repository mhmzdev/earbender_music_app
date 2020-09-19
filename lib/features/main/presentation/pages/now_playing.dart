import 'dart:io';

import 'package:earbender/features/main/presentation/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constant.dart';
import '../widgets/background_colors_grid_widget.dart';
import '../widgets/current_music_image_container_widget.dart';
import '../widgets/playing_panel_widget.dart';
import 'main_page.dart';

class NowPlaying extends StatefulWidget {
  final BuildContext blocContext;
  final double maxSlide;

  NowPlaying({this.maxSlide, @required this.blocContext});

  @override
  _NowPlayingState createState() => _NowPlayingState();

  static _NowPlayingState of(BuildContext context) =>
      context.findAncestorStateOfType<_NowPlayingState>();
}

class _NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  // static const double maxSlide = 300;
  static const double minDragStartEdge = 60;
  AnimationController _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _NowPlayingState.toggleDuration,
    );
  }

  void close() => _animationController.reverse();

  void open() => _animationController.forward();

  void toggleDrawer() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: new Text(
              "Exit Application",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: new Text("Are You Sure?"),
            actions: <Widget>[
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  "No",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _animationController,
          child: mainScreen(),
          builder: (context, child) {
            double animValue = _animationController.value;
            final slideAmount = widget.maxSlide * animValue;
            final contentScale = 1.0 - (0.7 * animValue);
            return Stack(
              children: <Widget>[
                MainPage(blocContext: widget.blocContext),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale, contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _animationController.isCompleted ? close : null,
                    child: child,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx >
            (widget.maxSlide -
                16); // maxSlideDrag chagned to (widget.maxSlide-16);

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / widget.maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  Widget mainScreen() {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      elevation: 4.0,
      shadowColor: Colors.blue,
      child: SafeArea(
        child: Stack(
          children: [
            BackgroundColors(),
            customBar(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width),
            ImageContainer(
              blocContext: widget.blocContext,
            ),
            PlayingPanel(
              blocContext: widget.blocContext,
            ),
          ],
        ),
      ),
    );
  }

  Widget customBar(double height, double width) {
    bool _isSaved = false;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: height * 0.04,
                color: Colors.grey[500],
              ),
              onPressed: () {
                toggleDrawer();
              }),
          Text(
            'Now Playing',
            textAlign: TextAlign.center,
            style: kHeadingStyle,
          ),
          // For defining the state of the favourite button
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              IconData icon = Icons.favorite_border;

              if (state is UpdateMusic) {
                // When music updated, check if curernt music was previously cached and if yes then update icon
                _isSaved = state.isSaved;
                if (state.isSaved) icon = Icons.favorite;
              } else if (state is Saved) {
                // If saved by clicking after load
                _isSaved = state.isSaved;
                if (state.isSaved) icon = Icons.favorite;
              }

              // For persistence
              if (_isSaved) {
                icon = Icons.favorite;
              }

              return IconButton(
                icon: Icon(
                  icon,
                  size: height * 0.03,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  BlocProvider.of<MainBloc>(context)
                      .add(SaveCurrentMusicEvent());
                },
              );
            },
          )
        ],
      ),
    );
  }
}
