/*

  A singleton based approach to temporarily storing audio files that have been
  selected from the file picker and loaded onto the list.

  Provides persistence for when the list screen has been moved away from.

*/

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
