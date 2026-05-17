import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/models/request/initial_setup_request.dart';

@immutable
sealed class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object?> get props => [];
}

final class SubmitInitialSetupEvent extends SetupEvent {
  final InitialSetupRequest requestPayload;

  const SubmitInitialSetupEvent({required this.requestPayload});

  @override
  List<Object?> get props => [requestPayload];
}
