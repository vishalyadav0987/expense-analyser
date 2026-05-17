import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../domain/models/request/initial_setup_request.dart';

class SetupApiService {
  final Dio dio;

  SetupApiService({required this.dio});

  Future<Map<String, dynamic>> submitInitialSetup(
    InitialSetupRequest request,
    String accessToken,
  ) async {
    final response = await dio.post(
      ApiEndpoints.initialSetup,
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response.data;
  }
}
