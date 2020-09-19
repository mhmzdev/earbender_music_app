/*

  All functions related to the 'main' feature that include interaction with
  any local form of local storage.

*/

import 'package:earbender/core/error/exceptions.dart';
import 'package:earbender/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainLocalDataSource {
  // Returns are cached music file paths for file saved in the device file system
  Future<List<String>> getAllSavedMusicPaths();

  // Add a path if not already cached. Remove is already present in the list of cached paths
  Future<bool> updateOrRemoveMusicPath(String path);

  // Check if a path has already been cached
  Future<bool> checkIfMusicIsSaved(String path);
}

class MainLocalDataSourceImpl extends MainLocalDataSource {
  final SharedPreferences sharedPreferences;

  MainLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<String>> getAllSavedMusicPaths() {
    final pathsList = sharedPreferences.getStringList(CACHE_SAVED_MUSIC_PATHS);

    if (pathsList != null) {
      // Has never been cached
      return Future.value(pathsList);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> updateOrRemoveMusicPath(String path) async {
    dynamic currentPathsList =
        sharedPreferences.getStringList(CACHE_SAVED_MUSIC_PATHS);

    bool isSaved = true;

    if (currentPathsList == null) {
      // Never been cached hence the first time
      currentPathsList = [path];
      return sharedPreferences.setStringList(
          CACHE_SAVED_MUSIC_PATHS, currentPathsList);
    } else {
      if ((currentPathsList as List<String>).contains(path)) {
        // Path already present in cached paths list
        (currentPathsList as List<String>).remove(path);
        isSaved = false;
      } else {
        // New path hence added to the list and then cached
        (currentPathsList as List<String>).add(path);
      }
    }

    sharedPreferences.setStringList(CACHE_SAVED_MUSIC_PATHS, currentPathsList);
    return Future.value(isSaved);
  }

  @override
  Future<bool> checkIfMusicIsSaved(String path) async {
    dynamic currentPathsList =
        sharedPreferences.getStringList(CACHE_SAVED_MUSIC_PATHS);

    if (currentPathsList != null) {
      return Future.value((currentPathsList as List<String>)
          .contains(path)); // Check for path existence in cached paths list
    } else {
      // List has not been cached
      return Future.value(false);
    }
  }
}
