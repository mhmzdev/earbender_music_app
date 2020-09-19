/*

  A usecase represents an action based functionality

*/

import 'package:dartz/dartz.dart';
import 'package:earbender/core/error/failures.dart';
import 'package:equatable/equatable.dart';

// In UseCase<Type, Params> - Type is the return type of the usecase and
// Params are any parameters passed to the usecase through the Params object instance
abstract class UseCase<Type, Params> {
  // When the returned value type is conditional and from a choice
  Future<Either<Failure, Type>> call(Params params);

  // When the returned value is of a single type and not from a choice or either this or that
  Future<dynamic> callNoChoice(Params params);
}

// Used when the usecase has no need for extra parameters to define the action
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
