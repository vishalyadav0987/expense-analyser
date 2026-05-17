import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object?> get props => [];
}

final class SetupInitial extends SetupState {}

final class SetupLoading extends SetupState {}

final class SetupSuccess extends SetupState {
  final String message;
  const SetupSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SetupError extends SetupState {
  final String message;
  const SetupError({required this.message});

  @override
  List<Object?> get props => [message];
}
