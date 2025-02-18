import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../domain/models/auth_request_model.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, AuthResponseModel>> createUser(AuthRequestModel request) async {
    try {
      final response = await remoteDataSource.createUser(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }
}
