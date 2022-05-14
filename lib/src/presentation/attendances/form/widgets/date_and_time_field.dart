import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/attendances/form/bloc.dart';
import '../../../../shared/shared.dart';

class DateAndTimeField extends StatelessWidget {
  const DateAndTimeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(flex: 3, child: DateSelector()),
        SizedBox(width: 8),
        Expanded(flex: 2, child: TimeSelector()),
      ],
    );
  }
}

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) {
    final firstDate = DateTime(initialDate.year);
    final lastDate = DateTime(initialDate.year + 1);

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DateOrTimeSelector(
      icon: Icons.schedule_rounded,
      label: BlocBuilder<AttendanceFormBloc, AttendanceFormState>(
        buildWhen: (p, c) => p.didDateChange(c),
        builder: (context, state) {
          return Text(
            state.formattedDate(context.l10n.localeName),
          );
        },
      ),
      onPressed: () async {
        final bloc = context.read<AttendanceFormBloc>();

        final date = await _pickDate(context, bloc.state.date);

        if (date != null) {
          bloc.add(AttendanceFormEvent.dateChanged(date));
        }
      },
    );
  }
}

class TimeSelector extends StatelessWidget {
  const TimeSelector({super.key});

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime initialDate) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DateOrTimeSelector(
      icon: Icons.schedule_rounded,
      label: BlocBuilder<AttendanceFormBloc, AttendanceFormState>(
        buildWhen: (p, c) => p.didTimeChange(c),
        builder: (context, state) {
          return Text(
            state.formattedTime(context.l10n.localeName),
          );
        },
      ),
      onPressed: () async {
        final bloc = context.read<AttendanceFormBloc>();

        final time = await _pickTime(context, bloc.state.date);

        if (time != null) {
          bloc.add(
            AttendanceFormEvent.timeChanged(
              hour: time.hour,
              minute: time.minute,
            ),
          );
        }
      },
    );
  }
}

// TODO: maybe extract to `.../shared`
class DateOrTimeSelector extends StatelessWidget {
  const DateOrTimeSelector({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final Widget label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final backgroundColor = theme.colorScheme.secondaryContainer;

    return Material(
      type: MaterialType.card,
      color: backgroundColor,
      borderRadius: kDefaultBorderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: kDefaultBorderRadius,
        splashColor: color.withOpacity(.1),
        child: Padding(
          padding: AppPadding.allSmall,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: DefaultTextStyle(
                  style: theme.textTheme.titleMedium!.copyWith(color: color),
                  child: label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
