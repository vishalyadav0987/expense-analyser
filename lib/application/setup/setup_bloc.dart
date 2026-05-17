import 'package:expense_analyser/application/setup/setup_event.dart';
import 'package:expense_analyser/application/setup/setup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/setup_repository.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupRepository setupRepository;

  SetupBloc({required this.setupRepository}) : super(SetupInitial()) {
    on<SubmitInitialSetupEvent>((event, emit) async {
      emit(SetupLoading());

      try {
        // Repo operation
        await setupRepository.submitInitialSetup(event.requestPayload);

        // Success
        emit(
          const SetupSuccess(message: "Profile setup completed successfully!"),
        );
      } catch (e) {
        emit(SetupError(message: e.toString()));
      }
    });
  }
}
