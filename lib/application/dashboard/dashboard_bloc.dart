import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDashboardEvent>((event, emit) async {
      final currentMonth = event.month ?? DateTime.now().month;
      final currentYear = event.year ?? DateTime.now().year;
      final cacheKey = 'dashboard_summary_${currentMonth}_$currentYear';

      // 1. Local Cache Fetch
      final localData = await repository.getLocalDashboardData(cacheKey);

      if (localData != null) {
        emit(DashboardLoaded(data: localData, isOfflineData: true));
      } else {
        emit(DashboardLoading());
      }

      // 2. Remote API Fetch
      try {
        final freshData = await repository.getRemoteDashboardData(
          cacheKey,
          month: event.month,
          year: event.year,
        );

        // Equatable Magic: Agar API se exact same data aaya jo Local me tha,
        // toh BLoC UI ko rebuild nahi karega! Zero lag!
        emit(DashboardLoaded(data: freshData, isOfflineData: false));
      } catch (e) {
        if (localData == null) {
          emit(DashboardError(message: e.toString()));
        }
      }
    });
  }
}
