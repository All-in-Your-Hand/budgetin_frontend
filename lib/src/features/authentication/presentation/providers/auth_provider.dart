import 'package:flutter/material.dart';
import '../../domain/models/auth_request_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = AuthRequestModel(
        email: email,
        password: password,
        name: name,
      );

      // ignore: unused_local_variable
      final response = await _repository.createUser(request);
      _isLoading = false;
      notifyListeners();

      // Handle successful signup
      // You might want to store the auth token, navigate to next screen, etc.
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add other auth methods like signIn, signOut, etc.
}
