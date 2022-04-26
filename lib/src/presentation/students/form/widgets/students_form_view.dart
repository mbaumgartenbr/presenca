import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/students/form/bloc.dart';
import '../../../../shared/shared.dart';
import 'import_dialog.dart';
import 'discard_dialog.dart';
import 'students_form_body.dart';

class StudentsFormView extends StatelessWidget {
  const StudentsFormView({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool? discardPressed = await showDialog<bool>(
          context: context,
          builder: (_) => const DiscardDialog(),
        );

        if (discardPressed ?? false) {
          SnackBarHelper.showWarning(
            context,
            'As alterações foram descartadas.',
          );

          return true;
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(title),
        ),
        body: const StudentsFormBody(),
        bottomNavigationBar: const _ButtonBar(),
      ),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  const _ButtonBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                height: 40,
                label: 'IMPORTAR',
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const ImportDialog(),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PrimaryButton(
                height: 40,
                label: 'SALVAR',
                onPressed: () => context
                    .read<StudentsFormBloc>()
                    .add(const StudentsFormEvent.submitted()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
