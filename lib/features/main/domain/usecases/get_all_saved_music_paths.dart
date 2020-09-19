import 'package:earbender/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:earbender/core/usecases/usecases.dart';
import 'package:earbender/features/main/domain/repositories/main_repository.dart';

class GetAllSavedMusicPaths implements UseCase<List<String>, NoParams> {
  final MainRepository repository; // Instance of repository

  GetAllSavedMusicPaths(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getAllSavedMusicPaths();
  }

  // No need to be implemented as depending upon a condition/exception, the return type may vary
  @override
  Future callNoChoice(NoParams params) {
    return null;
  }
}
