import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

final class FetchDashboardEvent extends DashboardEvent {
  final int? month;
  final int? year;

  const FetchDashboardEvent({this.month, this.year});

  @override
  List<Object?> get props => [month, year];
}
