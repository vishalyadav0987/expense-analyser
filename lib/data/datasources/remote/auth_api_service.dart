import 'package:dio/dio.dart';
import 'package:expense_analyser/core/constants/api_endpoints.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService({required this.dio});

  Future<Map<String, dynamic>> requestOtp(String email, String password) async {
    final response = await dio.post(
      ApiEndpoints.requestOtp,
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await dio.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> setupMpin(
    String mpin,
    String otpAcessToken,
  ) async {
    final response = await dio.post(
      ApiEndpoints.setupMpin,
      data: {'mpin': mpin},
      options: Options(headers: {'Authorization': 'Bearer $otpAcessToken'}),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> loginMpin(String email, String mpin) async {
    final response = await dio.post(
      ApiEndpoints.loginMpin,
      data: {"email": email, 'mpin': mpin},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> biometricLogin(String refreshToken) async {
    final response = await dio.post(
      ApiEndpoints.biometricLogin,
      data: {'refreshToken': refreshToken},
    );
    return response.data;
  }
}
