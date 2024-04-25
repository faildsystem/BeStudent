import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:student/theming/colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../widget/teacher.dart';

// ignore: must_be_immutable
class AllStudentsScreen extends StatefulWidget {
  AllStudentsScreen({super.key});
  late EmployeeDataSource _employeeDataSource;
  final DataGridController _dataGridController = DataGridController();
  List<Employee> _employees = <Employee>[];

  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  @override
  void initState() {
    super.initState();
    widget._employees = getEmployeeData();
    widget._employeeDataSource =
        EmployeeDataSource(employees: widget._employees);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Index of the checked item
            int selectedIndex = widget._dataGridController.selectedIndex;

            //CheckedRow
            DataGridRow? selectedRow = widget._dataGridController.selectedRow;

            //Collection of checkedRows
            List<DataGridRow> selectedRows =
                widget._dataGridController.selectedRows;

            log(selectedIndex.toString());
            log(selectedRow.toString());
            log(selectedRows.toString());
          },
          child: const Icon(Icons.check),
        ),
        body: SfDataGrid(
          columnWidthMode: ColumnWidthMode.fitByCellValue,
          controller: widget._dataGridController,
          showCheckboxColumn: true,
          selectionMode: SelectionMode.multiple,
          source: widget._employeeDataSource,
          horizontalScrollController: ScrollController(),
          verticalScrollController: ScrollController(),
          columns: [
            GridColumn(
                columnName: 'id',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'ID',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'name',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Name',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'designation',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Designation',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'salary',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Salary',
                      overflow: TextOverflow.ellipsis,
                    ))),
          ],
        ),
      ),
    );
  }
}

List<Employee> getEmployeeData() {
  return [
    Employee(10001, 'James', 'Project Lead', 20000),
    Employee(10002, 'Kathryn', 'Manager', 30000),
    Employee(10003, 'Lara', 'Developer', 15000),
    Employee(10004, 'Michael', 'Designer', 15000),
    Employee(10005, 'Martin', 'Developer', 15000),
    Employee(10006, 'Newberry', 'Developer', 15000),
    Employee(10007, 'Balnc', 'Developer', 15000),
    Employee(10008, 'Perry', 'Developer', 15000),
    Employee(10009, 'Gable', 'Developer', 15000),
    Employee(10010, 'Grimfffffffffffffes', 'Developer', 15000)
  ];
}
