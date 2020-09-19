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
  final CheckIfMusicIsSaved checkIfMusicIsSaved;
  final GetAllSavedMusicPaths getAllSavedMusicPaths;
  final UpdateOrRemoveMusicPath updateOrRemoveMusicPath;

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
      bool isSaved = await checkIfMusicIsSaved
          .callNoChoice(MusicParams(path: event.musicPath));

      yield UpdateMusic(musicPath: event.musicPath, isSaved: isSaved);
    } else if (event is SaveCurrentMusicEvent) {
      yield SaveMusic();
    } else if (event is SaveMusicLocallyEvent) {
      bool isSaved = await updateOrRemoveMusicPath
          .callNoChoice(MusicParams(path: event.musicPath));

      yield Saved(isSaved: isSaved);
    } else if (event is GetAllSavedMusicPathsEvent) {
      yield LoadingSavedMusic();
      final failureOrPaths = await getAllSavedMusicPaths(NoParams());
      yield failureOrPaths.fold(
          (failure) => Error(), (paths) => LoadedSavedMusic(musicPaths: paths));
    } else if (event is OpenMainEvent) {
      yield OpenMain();
    } else if (event is OpenSavedMusicEvent) {
      yield OpenSaved();
    } else if (event is ResetEvent) {
      yield Initial();
    }
  }
}
