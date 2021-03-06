import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/students/form/bloc.dart';
import '../../../domain/discipline.dart';
import '../../../domain/student.dart';
import '../../../shared/shared.dart';
import 'widgets/students_form_view.dart';

class StudentsFormPage extends StatelessWidget {
  const StudentsFormPage({
    super.key,
    required this.discipline,
    this.initialStudents = const <Student>[],
  });

  final Discipline discipline;
  final List<Student> initialStudents;

  static Route<void> route({
    required Discipline discipline,
    List<Student> initialStudents = const [],
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => StudentsFormPage(
        discipline: discipline,
        initialStudents: initialStudents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentsFormBloc>(
      create: (_) {
        final bloc = StudentsFormBloc(
          discipline: discipline,
          studentsRepository: context.read<StudentsRepository>(),
        );

        final formStarted = StudentsFormEvent.started(
          initialStudents: initialStudents,
        );

        return bloc..add(formStarted);
      },
      child: BlocListener<StudentsFormBloc, StudentsFormState>(
        listenWhen: (p, c) {
          return p.failureOrSuccessOption != c.failureOrSuccessOption;
        },
        listener: (BuildContext context, StudentsFormState state) {
          state.failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
              (failure) => failure.whenOrNull(
                unableToUpdate: () {
                  SnackBarHelper.showError(
                    context,
                    'Não foi possível salvar lista de alunos.',
                  );
                },
              ),
              (_) {
                Navigator.pop(context);
                SnackBarHelper.showSuccess(
                  context,
                  'As alterações foram salvas.',
                );
              },
            ),
          );
        },
        child: Stack(
          children: [
            StudentsFormView(title: discipline.name),
            const _Overlay(),
          ],
        ),
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<StudentsFormBloc, StudentsFormState>(
      buildWhen: (p, c) => p.isSaving != c.isSaving,
      builder: (BuildContext context, StudentsFormState state) {
        return IgnorePointer(
          ignoring: !state.isSaving,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color: state.isSaving
                ? Colors.black.withOpacity(0.5)
                : Colors.transparent,
            width: screenSize.width,
            height: screenSize.height,
            child: Visibility(
              visible: state.isSaving,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Salvando Lista de Alunos...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
