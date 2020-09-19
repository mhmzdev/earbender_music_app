import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MusicParams extends Equatable {
  final String path;

  MusicParams({@required this.path});

  @override
  List<Object> get props => [path];
}
