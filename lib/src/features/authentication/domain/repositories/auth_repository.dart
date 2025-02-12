import '../models/auth_request_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> createUser(AuthRequestModel request);
}
