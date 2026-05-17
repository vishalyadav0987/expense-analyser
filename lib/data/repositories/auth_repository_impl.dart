import 'package:expense_analyser/data/datasources/local/storage/secure_storage_service.dart';
import 'package:expense_analyser/data/datasources/remote/auth_api_service.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService remoteDataSource;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<void> requestOtp(String email, String password) async {
    await remoteDataSource.requestOtp(email, password);
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    final response = await remoteDataSource.verifyOtp(email, otp);

    // SDE3 Catch: Backend returns temporary tokens during verification
    final data = response['data'];
    await secureStorage.saveIsNewUser(isNewUserStr: data['isNewUser']);

    return data['otpAccessToken'];
  }

  @override
  Future<void> setupMpin(String mpin, String otpAccessToken) async {
    final response = await remoteDataSource.setupMpin(mpin, otpAccessToken);
    // Overwrite with the permanent tokens after MPIN setup
    final data = response['data'];
    await secureStorage.saveTokens(
      access: data['access_token'],
      refresh: data['refresh_token'],
    );
    if (data.containsKey('userData')) {
      await secureStorage.saveUserData(data['userData']);
    }
  }

  @override
  Future<void> loginMpin(String email, String mpin) async {
    final response = await remoteDataSource.loginMpin(email, mpin);
    final data = response['data'];
    await secureStorage.saveTokens(
      access: data['access_token'],
      refresh: data['refresh_token'],
    );
    if (data.containsKey('userData')) {
      await secureStorage.saveUserData(data['userData']);
    }
  }

  @override
  Future<void> biometricLogin() async {
    // 1. Get the refresh token from the vault
    final refreshToken = await secureStorage.getRefreshToken();
    if (refreshToken == null)
      throw Exception("No refresh token found. Login with MPIN.");

    // 2. Call the Biometric Endpoint
    final response = await remoteDataSource.biometricLogin(refreshToken);

    // 3. Save the new rotated tokens! (Defense in Depth)
    final data = response['data'];
    await secureStorage.saveTokens(
      access: data['access_token'],
      refresh: data['refresh_token'],
    );
    if (data.containsKey('userData')) {
      await secureStorage.saveUserData(data['userData']);
    }
  }

  @override
  Future<void> logout() async {
    await secureStorage.clearAll();
  }
}
