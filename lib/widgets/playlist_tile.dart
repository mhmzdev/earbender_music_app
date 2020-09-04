import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:earbender/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayListTile extends StatelessWidget {
  final File musicFile;
  PlayListTile({this.musicFile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.music_note),
        title: Text(musicFile.path.split('/').last),
        onTap: () {
          showDialog(
              context: context,
              child: SongDetails(
                  songPath: musicFile.path,
                  songName: musicFile.path.split('/').last));
        },
      ),
    );
  }
}

class SongDetails extends StatefulWidget {
  final String songName;
  final String songPath;
  SongDetails({this.songName, this.songPath});

  @override
  _SongDetailsState createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    playAudio();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  playAudio() {
    assetsAudioPlayer.open(Audio(widget.songPath), showNotification: true);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ScaleTransition(
      scale: scaleAnimation,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            width: width * 0.75,
            height: height * 0.2,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Song Name', style: kHeadingStyle),
                Text(
                  widget.songName,
                  style: GoogleFonts.lato(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                      child: IconButton(
                          color: Colors.black,
                          onPressed: () {
                            assetsAudioPlayer.playOrPause();
                          },
                          icon: Icon(
                            Icons.play_arrow,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.05,
                      child: IconButton(
                          color: Colors.red,
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.delete,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.05,
                      child: IconButton(
                          color: Colors.green,
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.done,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
