import 'package:dartz/dartz.dart';
import 'package:earbender/core/error/failures.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
  Future<dynamic> callNoChoice(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
