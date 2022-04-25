import 'package:flutter/material.dart';

import '../../../../domain/discipline.dart';
import '../../../app/router.dart';
import 'body/body.dart';

class DisciplineDetailsView extends StatelessWidget {
  const DisciplineDetailsView({
    Key? key,
    required this.discipline,
  }) : super(key: key);

  final Discipline discipline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(discipline.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                enableDrag: false,
                builder: (_) => DisciplineActionsSheet(discipline: discipline),
              );
            },
          ),
        ],
      ),
      body: DisciplineDetailsBody(discipline: discipline),
    );
  }
}

class DisciplineActionsSheet extends StatelessWidget {
  const DisciplineActionsSheet({
    Key? key,
    required this.discipline,
  }) : super(key: key);

  final Discipline discipline;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: const Icon(Icons.people_alt),
          title: const Text('Editar Alunos'),
          trailing: const Icon(Icons.arrow_forward_rounded),
          onTap: () {
            Navigator.pop(context);
            AppRouter.showStudentsForm(context, discipline);
          },
        ),
      ],
    );
  }
}
