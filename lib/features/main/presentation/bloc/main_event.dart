/*

  Defines all the events that are used as triggers

*/

part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class ChangeCurrentMusicEvent extends MainEvent {
  final String musicPath;

  ChangeCurrentMusicEvent({this.musicPath}) : super([musicPath]);
}

class SaveCurrentMusicEvent extends MainEvent {}

class SaveMusicLocallyEvent extends MainEvent {
  final String musicPath;

  SaveMusicLocallyEvent({this.musicPath}) : super([musicPath]);
}

class GetAllSavedMusicPathsEvent extends MainEvent {}

class OpenMainEvent extends MainEvent {}

class OpenSavedMusicEvent extends MainEvent {}

// class ResetEvent extends MainEvent {}
