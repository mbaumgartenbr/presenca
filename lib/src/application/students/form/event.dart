part of 'bloc.dart';

@freezed
class StudentsFormEvent with _$StudentsFormEvent {
  const factory StudentsFormEvent.started({
    required Discipline discipline,
  }) = _Started;

  const factory StudentsFormEvent.selected({
    required Student student,
  }) = _Selected;

  const factory StudentsFormEvent.editingComplete({
    required String name,
  }) = _EditingComplete;

  const factory StudentsFormEvent.activeToggled({
    required Student student,
  }) = _ActiveToggled;

  const factory StudentsFormEvent.submitted() = _Submitted;
}