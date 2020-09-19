import 'package:earbender/core/error/exceptions.dart';
import 'package:earbender/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainLocalDataSource {
  Future<List<String>> getAllSavedMusicPaths();
  Future<bool> updateOrRemoveMusicPath(String path);
  Future<bool> checkIfMusicIsSaved(String path);
}

class MainLocalDataSourceImpl extends MainLocalDataSource {
  final SharedPreferences sharedPreferences;

  MainLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<String>> getAllSavedMusicPaths() {
    final pathsList = sharedPreferences.getStringList(CACHE_SAVED_MUSIC_PATHS);

    if (pathsList != null) {
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
      currentPathsList = [path];
      return sharedPreferences.setStringList(
          CACHE_SAVED_MUSIC_PATHS, currentPathsList);
    } else {
      if ((currentPathsList as List<String>).contains(path)) {
        (currentPathsList as List<String>).remove(path);
        isSaved = false;
      } else {
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
      return Future.value((currentPathsList as List<String>).contains(path));
    } else {
      return Future.value(false);
    }
  }
}
