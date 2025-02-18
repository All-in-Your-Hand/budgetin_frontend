import 'package:flutter/foundation.dart';
import '../../domain/models/auth_request_model.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  AuthResponseModel? _user;
  String? _error;
  bool _isLoading = false;

  /// Creates a new [AuthProvider] instance
  AuthProvider({required AuthRepository repository}) : _repository = repository;

  /// Current user data
  AuthResponseModel? get user => _user;

  /// Error message if any
  String? get error => _error;

  /// Whether authentication is in progress
  bool get isLoading => _isLoading;

  /// Creates a new user
  Future<bool> createUser(AuthRequestModel request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.createUser(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _user = null;
      },
      (user) {
        _error = null;
        _user = user;
      },
    );

    _isLoading = false;
    notifyListeners();
    return result.isRight();
  }

  // Add other auth methods like signIn, signOut, etc.
}
