import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isNewUser = 'isNewUser';
  static const String _userDataKey = 'user_data';
  static const String _biometricOptOutKey = 'biometric_opt_out';
  static const String _biometricEnabledKey = 'biometric_enabled';
  // static const String _deviceIdKey = 'device_id';

  // Save Tokens
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }

  // Get Tokens
  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  Future<void> saveIsNewUser({required bool isNewUserStr}) async {
    await _storage.write(
      key: _isNewUser,
      value: isNewUserStr ? "true" : "false",
    );
  }

  Future<String?> getIsNewUser() async => await _storage.read(key: _isNewUser);

  // ---------------------------------------------------------
  // 👤 USER DATA STORAGE
  // ---------------------------------------------------------

  // Save User Data (Map -> JSON String)
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    // SDE3 Trick: Secure storage sirf String leta hai, toh Map ko String bana do
    final String jsonString = jsonEncode(userData);
    await _storage.write(key: _userDataKey, value: jsonString);
  }

  // Retrieve User Data (JSON String -> Map)
  Future<Map<String, dynamic>?> getUserData() async {
    final String? jsonString = await _storage.read(key: _userDataKey);

    if (jsonString != null) {
      // Wapas Map mein convert karo taaki UI aaram se data nikal sake
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null; // Agar koi data nahi hai
  }

  // Get specific flags safely (Helper Methods)
  Future<bool> isSetupComplete() async {
    final userData = await getUserData();
    if (userData != null && userData.containsKey('SetupComplete')) {
      return userData['SetupComplete'] == true;
    }
    return false;
  }

  // ---------------------------------------------------------
  // 🫆 Biometric Setup
  // ---------------------------------------------------------

  Future<void> setBiometricOptOut(bool value) async {
    await _storage.write(key: _biometricOptOutKey, value: value.toString());
  }

  Future<bool> hasBiometricOptedOut() async {
    final val = await _storage.read(key: _biometricOptOutKey);
    return val == 'true';
  }

  // 2. Opt-in (User successfully scanned fingerprint)
  Future<void> setBiometricEnabled(bool value) async {
    await _storage.write(key: _biometricEnabledKey, value: value.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _biometricEnabledKey);
    return val == 'true';
  }

  // Clear Vault (Kill Switch / Logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
