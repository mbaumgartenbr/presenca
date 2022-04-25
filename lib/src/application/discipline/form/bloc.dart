import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/discipline.dart';

part 'bloc.freezed.dart';
part 'event.dart';
part 'state.dart';

class DisciplineFormBloc
    extends Bloc<DisciplineFormEvent, DisciplineFormState> {
  DisciplineFormBloc({
    required DisciplinesRepository disciplinesRepository,
  })  : _disciplinesRepository = disciplinesRepository,
        super(DisciplineFormState.initial()) {
    on<DisciplineFormEvent>(_onEvent);
  }

  final DisciplinesRepository _disciplinesRepository;

  Future<void> _onEvent(
    DisciplineFormEvent event,
    Emitter<DisciplineFormState> emit,
  ) async {
    await event.map(
      started: (event) => _onStarted(event, emit),
      nameChanged: (event) => _onNameChanged(event, emit),
      submitted: (event) => _onSubmitted(event, emit),
    );
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<DisciplineFormState> emit,
  ) async {
    event.initialDisciplineOption.fold(
      () {},
      (initialDiscipline) {
        emit(
          state.copyWith(
            discipline: initialDiscipline,
            isEditing: true,
            saveFailureOrSuccessOption: const None(),
          ),
        );
      },
    );
  }

  Future<void> _onNameChanged(
    _NameChanged event,
    Emitter<DisciplineFormState> emit,
  ) async {
    final String name = event.name.trim();

    if (name.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Por favor, informe um nome.',
          saveFailureOrSuccessOption: const None(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          discipline: state.discipline.copyWith(name: name),
          errorMessage: null,
          saveFailureOrSuccessOption: const None(),
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<DisciplineFormState> emit,
  ) async {
    emit(
      state.copyWith(
        isSaving: true,
        saveFailureOrSuccessOption: const None(),
        errorMessage: null,
      ),
    );

    Either<DisciplineFailure, Unit>? failureOrSuccess;

    final discipline = state.discipline;

    if (discipline.name.isNotEmpty) {
      failureOrSuccess = await _disciplinesRepository.save(discipline);
    }

    emit(
      state.copyWith(
        discipline: discipline,
        isSaving: false,
        errorMessage: null,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
