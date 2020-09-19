/*

  Bloc is one of the ways to implement State Management in flutter.

  It uses events as triggers and states as a way performing the action
  pertaining to the event.

  Listeners that have the same instance of the bloc as their master
  are all triggered at once when an event is trigerred.

*/

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/params.dart';
import '../../domain/usecases/check_if_music_is_saved.dart';
import '../../domain/usecases/get_all_saved_music_paths.dart';
import '../../domain/usecases/update_or_remove_music_path.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  // Define all required usecases
  final CheckIfMusicIsSaved checkIfMusicIsSaved;
  final GetAllSavedMusicPaths getAllSavedMusicPaths;
  final UpdateOrRemoveMusicPath updateOrRemoveMusicPath;

  // Null check inorder to correctly initialize the usecases
  MainBloc(
      {@required CheckIfMusicIsSaved isSaved,
      @required GetAllSavedMusicPaths allSaved,
      @required UpdateOrRemoveMusicPath updateOrRemove})
      : assert(isSaved != null),
        assert(allSaved != null),
        assert(updateOrRemove != null),
        checkIfMusicIsSaved = isSaved,
        getAllSavedMusicPaths = allSaved,
        updateOrRemoveMusicPath = updateOrRemove,
        super(Initial());

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is ChangeCurrentMusicEvent) {
      // Current Music To be Updated
      bool isSaved = await checkIfMusicIsSaved
          .callNoChoice(MusicParams(path: event.musicPath));

      yield UpdateMusic(musicPath: event.musicPath, isSaved: isSaved);
    } else if (event is SaveCurrentMusicEvent) {
      // Trigger to start save
      yield SaveMusic();
    } else if (event is SaveMusicLocallyEvent) {
      // Actual save as trigger recepient was a separate widget.
      bool isSaved = await updateOrRemoveMusicPath
          .callNoChoice(MusicParams(path: event.musicPath));

      yield Saved(isSaved: isSaved);
    } else if (event is GetAllSavedMusicPathsEvent) {
      // Even to load the list of cached paths
      yield LoadingSavedMusic(); // Show Loading
      final failureOrPaths = await getAllSavedMusicPaths(NoParams());
      yield failureOrPaths.fold(
          (failure) => Error(),
          (paths) => LoadedSavedMusic(
              musicPaths:
                  paths)); // Show error if something went wrong else return the list
    } else if (event is OpenMainEvent) {
      // Open 'My Drawer'
      yield OpenMain();
    } else if (event is OpenSavedMusicEvent) {
      // Open 'My Saved Music'
      yield OpenSaved();
    }
    // else if (event is ResetEvent) {
    //   yield Initial();
    // }
  }
}
