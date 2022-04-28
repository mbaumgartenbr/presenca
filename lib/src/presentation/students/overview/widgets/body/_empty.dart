part of 'body.dart';

class _EmptyStudents extends StatelessWidget {
  const _EmptyStudents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          const Text(
            'Essa disciplina ainda não possui alunos.',
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
          PrimaryButton.wide(
            label: 'CADASTRAR ALUNOS',
            onPressed: () {
              final bloc = context.read<StudentsOverviewBloc>();
              AppRouter.showStudentsForm(
                context: context,
                discipline: bloc.discipline,
              );
            },
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
