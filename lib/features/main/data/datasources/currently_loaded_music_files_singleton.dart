import 'dart:io';

class CurrentlyLoadedMusicFilesSingleton {
  static final CurrentlyLoadedMusicFilesSingleton _instance =
      CurrentlyLoadedMusicFilesSingleton._internal();

  factory CurrentlyLoadedMusicFilesSingleton() => _instance;

  CurrentlyLoadedMusicFilesSingleton._internal() {
    musicFiles = List<File>();
  }

  List<File> musicFiles;
}
