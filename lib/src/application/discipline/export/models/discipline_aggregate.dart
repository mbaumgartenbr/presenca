import 'package:intl/intl.dart';

import '../../../../domain/attendance.dart';
import '../../../../domain/discipline.dart';
import '../../../../domain/student.dart';

class DisciplineAggregate {
  static final RegExp fileNameRegEx = RegExp(r'[^\w\p{L}]', unicode: true);
  static final DateFormat dateFormat = DateFormat('dd/MM HH:mm');

  const DisciplineAggregate({
    required this.discipline,
    required this.students,
    required this.attendances,
  });

  final List<Student> students;
  final List<Attendance> attendances;
  final Discipline discipline;

  String get fileName => discipline.name
      .replaceAll(' ', '_')
      .replaceAll(fileNameRegEx, '')
      .toLowerCase();

  List<List<String>> toCsv() {
    return [
      _buildHeader(),
      ..._generateBody(),
      _buildNoteRow(),
    ];
  }

  List<String> _buildHeader() {
    final header = <String>['Nome'];

    for (final attendance in attendances) {
      header.add(dateFormat.format(attendance.date));
    }

    return header;
  }

  List<String> _buildNoteRow() {
    final notes = <String>['Anotações'];

    for (final attendance in attendances) {
      notes.add(attendance.note);
    }

    return notes;
  }

  Iterable<List<String>> _generateBody() sync* {
    // TODO: cache attendance.attendedStudentIds removing already checked ids.
    for (final student in students) {
      final name = student.active ? student.name : '${student.name} (Inativo)';
      final studentRow = [name];

      for (final attendance in attendances) {
        if (attendance.attendedStudentIds.contains(student.id)) {
          studentRow.add('Presente');
        } else {
          studentRow.add('');
        }
      }

      yield studentRow;
    }
  }
}
