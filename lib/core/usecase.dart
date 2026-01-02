import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:grow_first/core/errors/failure.dart';

/// Abstract UseCase class with contract to implement call method.
///
/// Implementor has to provide implementation for call() with [params].
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
