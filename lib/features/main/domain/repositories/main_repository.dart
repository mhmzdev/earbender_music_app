/*

  Abstract definer for the repository functions.

*/

import 'package:dartz/dartz.dart';
import 'package:earbender/core/error/failures.dart';

abstract class MainRepository {
  Future<Either<Failure, List<String>>> getAllSavedMusicPaths();
  Future<bool> updateOrRemoveMusicPath(String path);
  Future<bool> checkIfMusicIsSaved(String path);
}
