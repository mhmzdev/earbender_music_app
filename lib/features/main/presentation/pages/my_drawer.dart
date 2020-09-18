import 'dart:io';

import 'package:earbender/features/main/presentation/widgets/playlist_tile_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final BuildContext blocContext;

  const MyDrawer({Key key, @required this.blocContext}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // To store file path from local storage
  List<File> musicFiles = [];

  // To store names of music file and show them in playlist
  List<String> fileNames = [];

  // Getting local file path and file names and adding to respective Lists
  _gettingLocalMusicFile() async {
    File file = await FilePicker.getFile(type: FileType.audio);
    // This will get the file name e.g. song.mp3
    String fileName = file.path.split('/').last;
    setState(() {
      musicFiles.add(file);
      fileNames.add(fileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _gettingLocalMusicFile();
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.folder_open),
            foregroundColor: Colors.blue,
          ),
          appBar: AppBar(
            toolbarHeight: height * 0.1,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.grey[600]),
            titleSpacing: 0,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/headphones.png',
                  height: height * 0.06,
                ),
                SizedBox(width: width * 0.02),
                Text("Earbender",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                        fontSize: height * 0.04)),
              ],
            ),
          ),
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/headphones.png'),
                            scale: 0.2)),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Saved Music'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
          body: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Container(
              width: width,
              height: height,
              child: Theme(
                data: ThemeData(
                  accentColor: Colors.grey[600],
                ),
                child: Stack(
                  children: [
                    Container(child: getLocalMusic(width, musicFiles)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLocalMusic(double width, List<File> listOfMusicFiles) {
    return listOfMusicFiles.length > 0
        ? new ListView(
            children: listOfMusicFiles
                .map((item) => new PlayListTile(
                    blocContext: widget.blocContext, musicFile: item))
                .toList())
        : Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.35,
                    child: Image.asset('assets/images/no_music.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      "Oops!! Couldn't find any\nmusic locally",
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
