import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
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
  Set<String> scannedIds = {}; // Track scanned student IDs

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

      // Check if the QR code has already been scanned
      if (scannedIds.contains(scannedId)) {
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
        scannedIds.add(scannedId); // Mark this QR code as scanned

        bool studentExists = students.any((student) => student.id == scannedId);
        if (studentExists) {
          qrController?.pauseCamera();
          setState(() {
            var student =
                students.firstWhere((student) => student.id == scannedId);
            if (!student.isPresent) {
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
            }
          });
        } else {
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
      }
    });
  }

  void saveAttendance() async {
    List<String> presentStudents = students
        .where((student) => student.isPresent)
        .map((student) => student.id)
        .toList();
    await FireStoreFunctions.saveAttendance(presentStudents);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'تم الحفظ',
      desc: 'تم حفظ الحضور بنجاح.',
      btnOkOnPress: () {},
      onDismissCallback: (type) => qrController?.resumeCamera(),
    ).show();
  }

  Color getColor(double attendance) {
    if (attendance >= .75) return Colors.green;
    if (attendance >= .50) return Colors.yellow;
    return Colors.red;
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
        title: Text(
          '${widget.groupName}',
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(1.5),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                        ),
                        children: [
                          _buildHeaderCell('حاضر'),
                          _buildHeaderCell('الاسم'),
                          _buildHeaderCell('الحضور'),
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
                                    // Remove student ID from scannedIds if unchecked
                                    if (!student.isPresent) {
                                      scannedIds.remove(student.id);
                                    }
                                  });
                                },
                                checkColor: Colors.white,
                                activeColor: Colors.lightBlue,
                              ),
                            ),
                            _buildTableCell(
                              child: Text(student.fullName,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                            _buildTableCell(
                              child: Text(
                                '${(student.attendance * 100).round()}%',
                                style: TextStyle(
                                  color: getColor(student.attendance),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (students.isEmpty)
                Center(
                  child: Text('لا يوجد طلاب متاحين',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
            ],
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
          width: 300,
          height: 300,
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
