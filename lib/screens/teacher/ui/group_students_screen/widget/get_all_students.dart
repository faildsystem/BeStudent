import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../core/widgets/classes/student.dart';
import '../../../../../core/widgets/firestore_functions.dart';

List<PlutoColumn> columns = [
  PlutoColumn(
    enableFilterMenuItem: true,
    enableRowChecked: true,
    enableContextMenu: true,
    title: 'الاسم الكامل',
    field: 'fullName',
    type: PlutoColumnType.text(),
    readOnly: true,
  ),
  PlutoColumn(
    title: 'الايميل',
    field: 'email',
    type: PlutoColumnType.text(),
    readOnly: true,
  ),
];

Future<List<PlutoRow>> getStudentsRows(String groupId) async {
  final List<Student> students =
      await FireStoreFunctions.fetchGroupStudents(groupId);
  List<PlutoRow> rows = [];
  for (final student in students) {
    rows.add(
      PlutoRow(
        cells: {
          'fullName':
              PlutoCell(value: '${student.firstName} ${student.lastName}'),
          'email': PlutoCell(value: student.email),
        },
      ),
    );
  }
  return rows;
}
