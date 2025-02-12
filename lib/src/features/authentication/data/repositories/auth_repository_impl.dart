import '../../domain/models/auth_request_model.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponseModel> createUser(AuthRequestModel request) async {
    try {
      final response = await remoteDataSource.createUser(request);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
