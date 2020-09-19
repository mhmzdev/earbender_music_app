/*

  A repository acts as the layer between the Data Sources (Remote and Local) 
  and the View where all the interaction is handled through interface functions.

  The 'Impl' are concrete and buildup on their counterparts with the same 
  name but 'Impl' omitted.

*/

import 'package:earbender/core/error/exceptions.dart';
import 'package:earbender/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:earbender/features/main/data/datasources/main_local_data_source.dart';
import 'package:earbender/features/main/domain/repositories/main_repository.dart';
import 'package:flutter/material.dart';

class MainRepositoryImpl extends MainRepository {
  final MainLocalDataSource localDataSource;

  MainRepositoryImpl({@required this.localDataSource});

  // Checks in the local storage for saved path
  @override
  Future<bool> checkIfMusicIsSaved(String path) async {
    return await localDataSource.checkIfMusicIsSaved(path);
  }

  // Get all saved music paths from local storage
  @override
  Future<Either<Failure, List<String>>> getAllSavedMusicPaths() async {
    try {
      final musicPaths = await localDataSource.getAllSavedMusicPaths();
      return Right(musicPaths);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  // Add/Replace path in local storage
  @override
  Future<bool> updateOrRemoveMusicPath(String path) async {
    return await localDataSource.updateOrRemoveMusicPath(path);
  }
}
