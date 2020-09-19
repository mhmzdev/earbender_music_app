import 'package:earbender/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:earbender/core/usecases/usecases.dart';
import 'package:earbender/features/main/domain/repositories/main_repository.dart';

class GetAllSavedMusicPaths implements UseCase<List<String>, NoParams> {
  final MainRepository repository;

  GetAllSavedMusicPaths(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getAllSavedMusicPaths();
  }

  @override
  Future callNoChoice(NoParams params) {
    return null;
  }
}
