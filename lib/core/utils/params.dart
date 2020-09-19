import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// To pass the music file path to the usecase
class MusicParams extends Equatable {
  final String path;

  MusicParams({@required this.path});

  @override
  List<Object> get props => [path];
}
