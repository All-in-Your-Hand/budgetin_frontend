import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../domain/models/auth_request_model.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

/// Implementation of [AuthRepository] that handles the coordination between
/// remote data sources and implements the business logic for authentication operations.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  /// Creates a new [AuthRepositoryImpl] instance.
  ///
  /// Requires an [AuthRemoteDataSource] for handling network operations.
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkException, AuthResponseModel>> createUser(AuthRequestModel request) async {
    final response = await _remoteDataSource.createUser(request);

    return response.fold(
      (failure) => Left(failure),
      (authResponse) => Right(authResponse),
    );
  }

  @override
  Future<Either<NetworkException, AuthResponseModel>> login(AuthRequestModel request) async {
    final response = await _remoteDataSource.loginUser(request);

    return response.fold(
      (failure) => Left(failure),
      (authResponse) => Right(authResponse),
    );
  }
}
