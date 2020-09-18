part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends MainState {}

class UpdateMusic extends MainState {
  final String musicPath;

  UpdateMusic({this.musicPath}) : super([musicPath]);
}
