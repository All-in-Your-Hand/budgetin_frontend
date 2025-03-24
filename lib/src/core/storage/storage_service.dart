import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Abstract class defining storage operations
abstract class StorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

/// Implementation of StorageService that uses the appropriate storage mechanism
/// based on the platform (secure storage for mobile, shared preferences for web)
class StorageServiceImpl implements StorageService {
  final FlutterSecureStorage? _secureStorage;
  SharedPreferences? _sharedPrefs;

  StorageServiceImpl() : _secureStorage = kIsWeb ? null : const FlutterSecureStorage();

  Future<SharedPreferences> get _prefs async => _sharedPrefs ??= await SharedPreferences.getInstance();

  @override
  Future<void> write({required String key, required String value}) async {
    if (kIsWeb) {
      final prefs = await _prefs;
      await prefs.setString(key, value);
    } else {
      await _secureStorage?.write(key: key, value: value);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    if (kIsWeb) {
      final prefs = await _prefs;
      return prefs.getString(key);
    } else {
      return await _secureStorage?.read(key: key);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    if (kIsWeb) {
      final prefs = await _prefs;
      await prefs.remove(key);
    } else {
      await _secureStorage?.delete(key: key);
    }
  }

  @override
  Future<void> deleteAll() async {
    if (kIsWeb) {
      final prefs = await _prefs;
      await prefs.clear();
    } else {
      await _secureStorage?.deleteAll();
    }
  }
}
