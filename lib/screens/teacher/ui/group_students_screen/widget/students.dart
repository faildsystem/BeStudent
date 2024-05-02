// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// class AllStudents extends StatefulWidget {
//   const AllStudents({super.key});

//   @override
//   State<AllStudents> createState() => _AllStudentsState();
// }

// class _AllStudentsState extends State<AllStudents> {
//   @override
//   Widget build(BuildContext context) {
//     return SfDataGrid(
//       // columnWidthMode: ColumnWidthMode.fitByCellValue,
//       controller: widget._dataGridController,
//       showCheckboxColumn: true,
//       selectionMode: SelectionMode.multiple,
//       source: widget._studentDataSource,
//       horizontalScrollController: ScrollController(),
//       verticalScrollController: ScrollController(),
//       columns: [
//         GridColumn(
//             columnName: 'name',
//             label: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 alignment: Alignment.centerLeft,
//                 child: const Text(
//                   'الأسم الكامل',
//                   overflow: TextOverflow.ellipsis,
//                 ))),
//         GridColumn(
//             columnName: 'email',
//             label: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 alignment: Alignment.centerRight,
//                 child: const Text(
//                   'البريد الإلكتروني',
//                   overflow: TextOverflow.ellipsis,
//                 ))),
//       ],
//     );
//   }
// }
