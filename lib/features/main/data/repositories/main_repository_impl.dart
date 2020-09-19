import 'package:earbender/core/error/exceptions.dart';
import 'package:earbender/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:earbender/features/main/data/datasources/main_local_data_source.dart';
import 'package:earbender/features/main/domain/repositories/main_repository.dart';
import 'package:flutter/material.dart';

class MainRepositoryImpl extends MainRepository {
  final MainLocalDataSource localDataSource;

  MainRepositoryImpl({@required this.localDataSource});

  @override
  Future<bool> checkIfMusicIsSaved(String path) async {
    return await localDataSource.checkIfMusicIsSaved(path);
  }

  @override
  Future<Either<Failure, List<String>>> getAllSavedMusicPaths() async {
    try {
      final musicPaths = await localDataSource.getAllSavedMusicPaths();
      return Right(musicPaths);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<bool> updateOrRemoveMusicPath(String path) async {
    return await localDataSource.updateOrRemoveMusicPath(path);
  }
}
