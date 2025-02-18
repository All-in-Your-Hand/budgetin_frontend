import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../models/auth_request_model.dart';
import '../models/auth_response_model.dart';

/// Repository interface for authentication-related operations
abstract class AuthRepository {
  /// Creates a new user
  ///
  /// Returns a [Future] that resolves to an [Either] containing either:
  /// - Left: [NetworkException] if the operation fails
  /// - Right: [AuthResponseModel] if successful
  Future<Either<NetworkException, AuthResponseModel>> createUser(AuthRequestModel request);
}
