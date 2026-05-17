import 'dart:io'; // To check platform
import 'package:dio/dio.dart';
import 'package:expense_analyser/application/auth/auth_bloc.dart';
import 'package:expense_analyser/application/setup/setup_bloc.dart';
import 'package:expense_analyser/core/constants/api_endpoints.dart';
import 'package:expense_analyser/data/datasources/local/database/app_database.dart';
import 'package:expense_analyser/data/datasources/local/storage/secure_storage_service.dart';
import 'package:expense_analyser/data/datasources/remote/auth_api_service.dart';
import 'package:expense_analyser/data/datasources/remote/setup_api_service.dart';
import 'package:expense_analyser/data/repositories/auth_repository_impl.dart';
import 'package:expense_analyser/data/repositories/setup_repository_impl.dart';
import 'package:expense_analyser/domain/repositories/auth_repository.dart';
import 'package:expense_analyser/domain/repositories/setup_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Services & Datasources
  setupAppServices();

  // Repositories
  setupAppRepos();

  // Blocs
  setupAppBlocs();
}

void setupAppServices() {
  // Register Secure Storage
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(locator<FlutterSecureStorage>()),
  );

  locator.registerLazySingleton<AppDatabase>(() => AppDatabase.instance);

  locator.registerLazySingleton<SetupApiService>(
    () => SetupApiService(dio: locator<Dio>()),
  );

  // Register Network Client (Dio)
  locator.registerLazySingleton<Dio>(() {
    String baseUrl = ApiEndpoints.baseUrl;

    // Android Emulator Fix
    if (Platform.isAndroid && baseUrl.contains('localhost')) {
      baseUrl = baseUrl.replaceAll('localhost', '10.0.2.2');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    return dio;
  });

  // Register Datasources
  locator.registerLazySingleton<AuthApiService>(
    () => AuthApiService(dio: locator<Dio>()),
  );
}

void setupAppRepos() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthApiService>(),
      secureStorage: locator<SecureStorageService>(),
    ),
  );

  locator.registerLazySingleton<SetupRepository>(
    () => SetupRepositoryImpl(
      remoteDataSource: locator<SetupApiService>(),
      appDatabase: locator<AppDatabase>(),
      secureStorage: locator<SecureStorageService>(),
    ),
  );
}

void setupAppBlocs() {
  // AuthBloc is a Singleton because its state is global across the app
  locator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: locator<AuthRepository>(),
      secureStorage: locator<SecureStorageService>(),
    ),
  );

  locator.registerLazySingleton<SetupBloc>(
    () => SetupBloc(setupRepository: locator<SetupRepository>()),
  );
}
