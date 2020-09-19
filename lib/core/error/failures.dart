/*

  Failures are instance of classes that are returned as a way of expressing what error occurred. 
  
  Failures are essentially different from Exceptions in a way that exception can only be thrown 
  in order to return a failure object, where a failure is concrete and an exception is not and just
  an implementataion of the Exception class.


*/

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

// To account for any failures that are related to data being stored locally on the device and failing
class CacheFailure extends Failure {}
