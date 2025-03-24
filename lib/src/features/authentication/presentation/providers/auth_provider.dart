import 'package:flutter/foundation.dart';
import '../../domain/models/auth_request_model.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/storage_service.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  final StorageService _storage;
  AuthResponseModel? _user;
  String? _error;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  /// Creates a new [AuthProvider] instance
  AuthProvider({
    required AuthRepository repository,
    required StorageService storage,
  })  : _repository = repository,
        _storage = storage;

  /// Current user data
  AuthResponseModel? get user => _user;

  /// Error message if any
  String? get error => _error;

  /// Whether authentication is in progress
  bool get isLoading => _isLoading;

  /// Whether user is authenticated
  bool get isAuthenticated => _isAuthenticated;

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

  /// Signs in a user
  Future<bool> signIn(AuthRequestModel request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.login(request);

    final success = await result.fold(
      (failure) async {
        _error = failure.message;
        _user = null;
        _isAuthenticated = false;
        return false;
      },
      (response) async {
        _error = null;
        _user = response;
        _isAuthenticated = true;

        // Store tokens securely
        if (response.token != null) {
          await _storage.write(key: 'access_token', value: response.token!);
        }
        if (response.refreshToken != null) {
          await _storage.write(key: 'refresh_token', value: response.refreshToken!);
        }
        return true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Signs out the current user
  Future<void> signOut() async {
    _isAuthenticated = false;
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  /// Checks if there's a valid token stored
  Future<bool> checkAuthStatus() async {
    final token = await _storage.read(key: 'access_token');
    _isAuthenticated = token != null;
    notifyListeners();
    return _isAuthenticated;
  }
}
