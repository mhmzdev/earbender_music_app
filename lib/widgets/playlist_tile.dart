import 'package:flutter/material.dart';

class PlayListTile extends StatelessWidget {
  final String songName;
  PlayListTile({this.songName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.music_note),
        title: Text(songName),
      ),
    );
  }
}
