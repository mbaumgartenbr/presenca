import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/students/import/bloc.dart';
import '../../../../shared/shared.dart';
import '../../../app/router.dart';

class StudentsImportBody extends StatelessWidget {
  const StudentsImportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsImportBloc, StudentsImportState>(
      listenWhen: (p, c) => p.students != c.students,
      listener: (context, state) {
        state.students.fold(
          () {},
          (students) {
            final discipline = context.read<StudentsImportBloc>().discipline;

            Navigator.pop(context);

            AppRouter.showStudentsForm(
              context: context,
              discipline: discipline,
              initialStudents: students,
            );
          },
        );
      },
      child: const PickFileView(),
    );
  }
}

class PickFileView extends StatelessWidget {
  const PickFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.allMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          BorderedColumn(
            children: [
              StudentsImportTitle(),
              SizedBox(height: 16),
              StudentsImportDescription(),
            ],
          ),
          SizedBox(height: 16),
          PickFileButton(),
        ],
      ),
    );
  }
}

class StudentsImportTitle extends StatelessWidget {
  const StudentsImportTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Importar Alunos',
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class StudentsImportDescription extends StatelessWidget {
  const StudentsImportDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        children: const [
          TextSpan(text: 'A importa????o possui somente suporte para '),
          TextSpan(
            text: 'arquivos CSV',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' no momento.\n\n',
          ),
          TextSpan(
            text: 'Ao importar uma planilha, apenas a primeira coluna ser?? '
                'utilizada, as outras ser??o ignoradas.'
                '\n\n',
          ),
          TextSpan(
            text: 'Aten????o! ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Ao realizar a importa????o, a lista de alunos dessa '
                'disciplina ser?? sobrescrita, mas voc?? ainda poder?? '
                'cancelar a importa????o ou at?? editar o nome de cada '
                'aluno individualmente ap??s selecionar o arquivo.',
          ),
        ],
      ),
    );
  }
}

class PickFileButton extends StatelessWidget {
  const PickFileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<StudentsImportBloc, StudentsImportState>(
      builder: (context, state) {
        return FadeUpwardsSwitcher(
          child: state.isLoading
              ? const _LoadingIndicator()
              : SizedBox(
                  height: kDefaultButtonHeight,
                  width: double.infinity,
                  child: MaterialButton(
                    color: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                    shape: kDefaultShapeBorder,
                    child: const Text('Selecionar Arquivo'),
                    onPressed: () => context
                        .read<StudentsImportBloc>()
                        .add(const StudentsImportEvent.pickFilePressed()),
                  ),
                ),
        );
      },
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      shape: kDefaultShapeBorder,
      child: SizedBox(
        height: kDefaultButtonHeight,
        child: Row(
          children: [
            const SizedBox(width: 16),
            const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Importando...',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
