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

class ResetEvent extends MainEvent {}
