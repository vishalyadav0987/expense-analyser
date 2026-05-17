import '../models/request/initial_setup_request.dart';

abstract class SetupRepository {
  Future<void> submitInitialSetup(InitialSetupRequest request);
}