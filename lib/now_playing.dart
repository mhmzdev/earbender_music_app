import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:earbender/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class NowPlaying extends StatefulWidget {
  final double maxSlide;
  NowPlaying({this.maxSlide});
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        child: mainScreen(),
        builder: (context, child) {
          double animValue = _animationController.value;
          final slideAmount = widget.maxSlide * animValue;
          final contentScale = 1.0 - (0.3 * animValue);
          return Stack(
            children: <Widget>[
              MyDrawer(),
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
      child: SafeArea(
        child: Stack(
          children: [
            BackgroundColors(),
            customBar(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width),
            ImageContainer(),
            PlayingPanel(),
          ],
        ),
      ),
    );
  }

  Widget customBar(double height, double width) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.menu,
                size: height * 0.03,
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
          IconButton(
              icon: Icon(
                Icons.favorite_border,
                size: height * 0.03,
                color: Colors.grey[500],
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}

class BackgroundColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
    );
  }
}

class ColoredTiles extends StatelessWidget {
  final Color tileColor;
  ColoredTiles({this.tileColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileColor,
    );
  }
}

class ImageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          SizedBox(height: height * 0.15),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: height * 0.25,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 15.0,
                      offset: Offset(10, 20),
                      spreadRadius: 8.0)
                ]),
            child: Image.asset('assets/images/music.png'),
          ),
          SizedBox(height: height * 0.1),
          Text("Janam Fida-e-Haideri", style: kSongNameStyle),
          SizedBox(height: height * 0.03),
          Text("Shahab Hussain", style: kSingerNameStyle),
        ],
      ),
    );
  }
}

class PlayingPanel extends StatefulWidget {
  @override
  _PlayingPanelState createState() => _PlayingPanelState();
}

class _PlayingPanelState extends State<PlayingPanel> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration totalDuration; // total Duration of the audio
  bool isPlaying = false;
  var isShuffle = false;
  var isLoop = false;

  @override
  initState() {
    super.initState();
    _setupAudio();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  /// configure the Audio Player
  _setupAudio() {
    // fetch the audio from assets and load it for playing
    assetsAudioPlayer.open(Audio('assets/audios/song1.mp3'),
        autoStart: false, showNotification: true);

    // listener to check whether the Player is playing any audio
    // true: playing, false: stopped/paused
    assetsAudioPlayer.isPlaying.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });

    // listener to check the current audio that's playing & fetch its total duration
    assetsAudioPlayer.current.listen((event) {
      if (event != null) {
        setState(() {
          totalDuration = event.audio.duration;
        });
      }
    });
  }

  /// convert Duration to String with mm:ss formatting
  String _formatDurationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height * 0.33,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200], offset: Offset(0, 0), blurRadius: 15)
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            )),
        child: Stack(
          children: [
            Positioned(
              top: height * 0.02,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<Duration>(
                      stream: assetsAudioPlayer.currentPosition,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData
                              ? _formatDurationToString(snapshot.data)
                              : "0:00",
                          style: kTimerStyle,
                        );
                      },
                    ),
                    StreamBuilder<Duration>(
                      stream: assetsAudioPlayer.currentPosition,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData && totalDuration != null
                              ? '-${_formatDurationToString(totalDuration - snapshot.data)}'
                              : '-:--',
                          style: kTimerStyle,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.04,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SliderTheme(
                  data: SliderThemeData(
                      trackHeight: height * 0.003,
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey[200],
                      thumbShape: RoundSliderThumbShape(
                          disabledThumbRadius: 0.0, enabledThumbRadius: 0.0)),
                  child: StreamBuilder(
                    stream: assetsAudioPlayer.currentPosition,
                    builder: (context, snapshot) {
                      return Slider(
                        min: 0,
                        value: snapshot.hasData
                            ? snapshot.data.inSeconds.ceilToDouble()
                            : 0,
                        max: totalDuration != null
                            ? totalDuration.inSeconds.ceilToDouble()
                            : 10,
                        onChanged: (double value) {
                          setState(() {
                            assetsAudioPlayer.seek(
                              Duration(
                                seconds: value.ceil(),
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: height * 0.1,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          size: height * 0.025,
                          color: isShuffle ? Colors.grey[500] : Colors.black,
                        ),
                        onPressed: () {
                          assetsAudioPlayer.toggleShuffle();
                          setState(() {
                            isShuffle = !isShuffle;
                          });
                          Toast.show(
                            isShuffle ? 'Shuffle off' : 'Shuffle',
                            context,
                            duration: 1,
                            backgroundRadius: 3.0,
                            backgroundColor: Colors.blue,
                          );
                        }),
                    Container(
                      child: Row(
                        children: [
                          RaisedButton(
                            elevation: 1.0,
                            color: Colors.white,
                            onPressed: () {
                              assetsAudioPlayer.next(keepLoopMode: true);
                            },
                            child: Icon(Icons.skip_previous),
                          ),
                          RaisedButton(
                            elevation: 1.0,
                            color: Colors.white,
                            onPressed: () {
                              assetsAudioPlayer.previous();
                            },
                            child: Icon(Icons.skip_next),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.loop,
                            size: height * 0.025,
                            color: isLoop ? Colors.grey[500] : Colors.black),
                        onPressed: () {
                          assetsAudioPlayer.toggleLoop();
                          setState(() {
                            isLoop = !isLoop;
                          });
                          Toast.show(isLoop ? 'Loop Off' : 'Loop On', context,
                              backgroundRadius: 3.0,
                              duration: 1,
                              backgroundColor: Colors.blue);
                        }),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.13),
                child: FloatingActionButton(
                  elevation: 3.0,
                  onPressed: () {
                    assetsAudioPlayer.playOrPause();
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Container(            
            width: width,
            height: height,
            child: Theme(
              data: ThemeData(
                accentColor: Colors.grey[600],
              ),
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  Text("Earbender",
                      style: GoogleFonts.lato(
                          color: Colors.grey[500], fontSize: height * 0.05)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
