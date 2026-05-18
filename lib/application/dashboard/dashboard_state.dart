import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/response/dashboard_response.dart';

@immutable
sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final DashboardData data;
  final bool isOfflineData;

  const DashboardLoaded({required this.data, this.isOfflineData = false});

  @override
  List<Object?> get props => [data, isOfflineData];
}

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
