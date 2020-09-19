/*

  Define Trigger Actions and State in 'State Management'

*/

part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends MainState {}

class UpdateMusic extends MainState {
  final String musicPath;
  final bool isSaved;

  UpdateMusic({this.isSaved, this.musicPath}) : super([isSaved, musicPath]);
}

class OpenMain extends MainState {}

class OpenSaved extends MainState {}

class SaveMusic extends MainState {}

class Saved extends MainState {
  final bool isSaved;

  Saved({this.isSaved}) : super([isSaved]);
}

class LoadingSavedMusic extends MainState {}

class LoadedSavedMusic extends MainState {
  final List<String> musicPaths;

  LoadedSavedMusic({this.musicPaths}) : super([musicPaths]);
}

class Error extends MainState {}
