import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:earbender/core/utils/constant.dart';
import 'package:earbender/features/main/presentation/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class PlayingPanel extends StatefulWidget {
  final BuildContext blocContext;

  const PlayingPanel({Key key, this.blocContext}) : super(key: key);

  @override
  _PlayingPanelState createState() => _PlayingPanelState();
}

class _PlayingPanelState extends State<PlayingPanel> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration totalDuration; // total Duration of the audio
  bool isPlaying = false;
  bool isShuffle = false;
  bool isLoop = false;
  String _musicPath = 'assets/audios/song1.mp3';

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

  // configure the Audio Player
  _setupAudio() {
    // fetch the audio from assets and load it for playing
    assetsAudioPlayer.open(Audio(_musicPath),
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

  // Update player with new Audio
  _updateAudio() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.open(Audio.file(_musicPath),
        autoStart: false, showNotification: true);
  }

  // convert Duration to String with mm:ss formatting
  String _formatDurationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocListener<MainBloc, MainState>(
      listenWhen: (prevState, currentState) {
        return true;
      },
      listener: (context, state) {
        if (state is UpdateMusic) {
          // Update Music File
          setState(() {
            _musicPath = state.musicPath;
            _updateAudio();
          });
        } else if (state is SaveMusic) {
          BlocProvider.of<MainBloc>(widget.blocContext)
              .add(SaveMusicLocallyEvent(musicPath: _musicPath));
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height * 0.33,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(0, 0),
                    blurRadius: 15)
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
                            color: isShuffle ? Colors.black : Colors.grey[500],
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
                              color: isLoop ? Colors.black : Colors.grey[500]),
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
      ),
    );
  }
}
