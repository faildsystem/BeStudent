// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:student/core/widgets/firestore_functions.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import '../../../../../core/widgets/app_bar.dart';
// import '../widget/teacher.dart';

// // ignore: must_be_immutable
// class AllStudentsScreen extends StatefulWidget {
//   AllStudentsScreen({super.key});
//   late StudentDataSource _studentDataSource;
//   final DataGridController _dataGridController = DataGridController();

//   @override
//   State<AllStudentsScreen> createState() => _AllStudentsScreenState();
// }

// class _AllStudentsScreenState extends State<AllStudentsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     widget._studentDataSource = StudentDataSource(students: widget._students);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: MyAppBar(title: 'الطلاب'),
//         body: FutureBuilder(
//           future: FireStoreFunctions.fetchGroupStudents('1'),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('حدث خطأ ما'),
//               );
//             }
//             if (snapshot.data == null) {
//               return const Center(
//                 child: Text('لا توجد مواعيد'),
//               );
//             }

//             return StudentSchedule(appointments: snapshot.data);
//           },
//         ),
//       ),
//     );
//   }
// }



// // floatingActionButton: FloatingActionButton(
// //           onPressed: () {
// //             //Index of the checked item
// //             int selectedIndex = widget._dataGridController.selectedIndex;

// //             //CheckedRow
// //             DataGridRow? selectedRow = widget._dataGridController.selectedRow;

// //             //Collection of checkedRows
// //             List<DataGridRow> selectedRows =
// //                 widget._dataGridController.selectedRows;

// //             log(selectedIndex.toString());
// //             log(selectedRow.toString());
// //             log(selectedRows.toString());
// //           },
// //           child: const Icon(Icons.check),
// //         ),