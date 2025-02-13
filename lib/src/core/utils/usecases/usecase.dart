import 'package:dartz/dartz.dart';
import '../../network/error/failures.dart';

/// Interface for all use cases in the application
///
/// Type parameters:
///   - Type: The type of the value returned by the use case
///   - Params: The type of the parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Special class for use cases that don't require parameters
class NoParams {
  const NoParams();
}
