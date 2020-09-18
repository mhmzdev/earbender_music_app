import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(Initial());

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is ChangeCurrentMusicEvent) {
      yield UpdateMusic(musicPath: event.musicPath);
    } else if (event is ResetEvent) {
      yield Initial();
    }
  }
}
