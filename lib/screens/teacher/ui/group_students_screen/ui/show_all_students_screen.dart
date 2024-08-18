import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../../core/classes/student.dart';
import '../../../../../core/widgets/firestore_functions.dart';

class AllStudentsScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const AllStudentsScreen(
      {Key? key, required this.groupId, required this.groupName})
      : super(key: key);

  @override
  _AllStudentsScreenState createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<Student> students = [];
  QRViewController? qrController;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    List<Student> fetchedStudents =
        await FireStoreFunctions.fetchGroupStudents(widget.groupId);
    setState(() {
      students = fetchedStudents;
    });
  }

  void onQRViewCreated(QRViewController controller) {
    this.qrController = controller;
    controller.scannedDataStream.listen((scanData) async {
      String scannedId = scanData.code!;

      try {
        // Attempt to find the student by ID
        Student student =
            students.firstWhere((student) => student.id == scannedId);

        if (student.isPresent) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            title: 'تم المسح مسبقًا',
            desc: 'تم مسح هذا الرمز QR مسبقًا.',
            btnOkOnPress: () {
              qrController?.resumeCamera();
            },
            onDismissCallback: (type) => qrController?.resumeCamera(),
          ).show();
          qrController?.pauseCamera();
        } else {
          qrController?.pauseCamera();
          setState(() {
            student.isPresent = true;
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'نجاح',
              desc: 'تم تسجيل حضور الطالب ${student.fullName}.',
              btnOkOnPress: () {
                qrController?.resumeCamera();
              },
              onDismissCallback: (type) => qrController?.resumeCamera(),
            ).show();
          });
        }
      } catch (e) {
        // If the student is not found
        qrController?.pauseCamera();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'فشل',
          desc: 'الطالب غير مسجل.',
          btnOkOnPress: () {
            qrController?.resumeCamera();
          },
          onDismissCallback: (type) => qrController?.resumeCamera(),
        ).show();
      }
    });
  }

  Future<int> fetchStudentAttendanceCount(String studentId) async {
    // Fetch the count of attendance records for the given student in the group
    // return await FireStoreFunctions.getAttendanceCountForStudent(
    //     widget.groupId, studentId);
    return 0;
  }

  Future<void> showStudentProfileDialog(
      BuildContext context, String studentId) async {
    final profileData = await FireStoreFunctions.fetchStudentProfile(studentId);
    final attendanceData =
        await FireStoreFunctions.fetchStudentAttendance(studentId);

    if (profileData.isEmpty) {
      // Handle empty profile data
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 15.w,
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profileData['imageUrl'] != null)
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profileData['imageUrl']),
                        radius: 50.r,
                      ),
                    ),
                  SizedBox(height: 20.h),
                  Text(
                    profileData['fullName'] ?? 'No Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'عدد أيام الحضور: ${attendanceData['count']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ExpansionTile(
                    title: Text(
                      'تواريخ الحضور',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    children: attendanceData['dates']
                        .map<Widget>((date) => ListTile(
                              title: Text(
                                date.split(' ')[0], // Show only the date part
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إغلاق',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  void saveAttendance() async {
    // Check network connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // If there is no network connection, show a dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'لا يوجد اتصال بالإنترنت',
        desc: 'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
        btnOkOnPress: () {},
        onDismissCallback: (type) => qrController?.resumeCamera(),
      ).show();
      return;
    }
    List<String> presentStudents = students
        .where((student) => student.isPresent)
        .map((student) => student.id)
        .toList();
    await FireStoreFunctions.saveAttendance(presentStudents, widget.groupId);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'تم الحفظ',
      desc: 'تم حفظ الحضور بنجاح.',
      btnOkOnPress: () {},
      onDismissCallback: (type) => qrController?.resumeCamera(),
    ).show();
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            widget.groupName,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (students.isNotEmpty)
              ? Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                              ),
                              children: [
                                _buildHeaderCell('حاضر'),
                                _buildHeaderCell('الاسم'),
                              ],
                            ),
                            for (var student in students)
                              TableRow(
                                children: [
                                  _buildTableCell(
                                    child: Checkbox(
                                      value: student.isPresent,
                                      onChanged: (value) {
                                        setState(() {
                                          student.isPresent = value!;
                                        });
                                      },
                                      checkColor: Colors.white,
                                      activeColor: Colors.lightBlue,
                                    ),
                                  ),
                                  _buildTableCell(
                                    child: InkWell(
                                      onTap: () => showStudentProfileDialog(
                                          context, student.id),
                                      child: Text(student.fullName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text('لا يوجد طلاب متاحين',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              onPressed: () => showQRScannerDialog(),
              label: const Text('مسح QR'),
              icon: const Icon(Icons.qr_code_scanner),
              backgroundColor: Colors.blueAccent,
            ),
            FloatingActionButton.extended(
              onPressed: saveAttendance,
              label: const Text('حفظ'),
              icon: const Icon(Icons.save),
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.blue.shade200,
        child: Center(
          child: Text(text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
        ),
      ),
    );
  }

  Widget _buildTableCell({required Widget child}) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: child),
      ),
    );
  }

  void showQRScannerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح رمز QR'),
        content: SizedBox(
          width: 300.w,
          height: 300.h,
          child: QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Center(
              child: const Text('إلغاء',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
          ),
        ],
      ),
    ).then((_) {
      qrController?.resumeCamera();
    });
  }
}
