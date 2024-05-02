import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// class Employee {
//   Employee(this.id, this.name, this.designation, this.salary);
//   final int id;
//   final String name;
//   final String designation;
//   final int salary;
// }

class Student {
  Student({
    required this.fullName,
    required this.email,
  });

  final String fullName;

  final String email;
}

class StudentDataSource extends DataGridSource {
  StudentDataSource({required List<Student> students}) {
    dataGridRows = students
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'lastName', value: dataGridRow.fullName),
              DataGridCell<String>(
                  columnName: 'email', value: dataGridRow.email),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'fullName')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}

// class EmployeeDataSource extends DataGridSource {
//   EmployeeDataSource({required List<Employee> employees}) {
//     dataGridRows = employees
//         .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
//               DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
//               DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
//               DataGridCell<String>(
//                   columnName: 'designation', value: dataGridRow.designation),
//               DataGridCell<int>(
//                   columnName: 'salary', value: dataGridRow.salary),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> dataGridRows = [];

//   @override
//   List<DataGridRow> get rows => dataGridRows;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((dataGridCell) {
//       return Container(
//           alignment: (dataGridCell.columnName == 'id' ||
//                   dataGridCell.columnName == 'salary')
//               ? Alignment.centerRight
//               : Alignment.centerLeft,
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             dataGridCell.value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ));
//     }).toList());
//   }
// }
