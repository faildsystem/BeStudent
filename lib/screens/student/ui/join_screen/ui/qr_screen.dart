import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/helpers/app_regex.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String studentId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedCode = '';
  bool isFlashOn = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void toggleFlash() {
    if (controller != null) {
      controller!.toggleFlash();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        scannedCode = scanData.code!;
      });
      controller.stopCamera();
      controller.pauseCamera();

      final group = await FireStoreFunctions.getDoc(
          collection: 'group', field: 'groupCode', value: scannedCode);

      if (AppRegex.isCodeValid(scannedCode) && group != null) {
        final joinState = await FireStoreFunctions.sendJoinRequestNotification(
            group['creatorId'], group.id, studentId, group['groupName']);

        switch (joinState) {
          case 1:
            // ignore: use_build_context_synchronously
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              btnOkOnPress: () {
                controller.resumeCamera();
              },
              btnOkText: 'حسنا',
              title: 'تم ارسال طلب الانضمام ',
              desc:
                  'تم ارسال طلب الانضمام بنجاح، سيتم اعلامك بالرد عليه في اقرب وقت ممكن.',
            ).show();
            break;
          case 2:
            // ignore: use_build_context_synchronously
            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.bottomSlide,
              onDismissCallback: (type) => controller.resumeCamera(),
              btnOkOnPress: () {
                controller.resumeCamera();
              },
              btnOkText: 'حسنا',
              title: 'تنبيه',
              desc: 'انت بالفعل منضم لهذه المجموعة.',
            ).show();
            break;
          case 0:
            // ignore: use_build_context_synchronously
            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.bottomSlide,
              onDismissCallback: (type) => controller.resumeCamera(),
              btnOkOnPress: () {
                controller.resumeCamera();
              },
              btnOkText: 'طلب الانضمام قيد الانتظار.',
              title: 'تنبيه',
              desc:
                  'طلب الانضمام قيد الانتظار، سيتم اعلامك بالرد عليه في اقرب وقت ممكن.',
            ).show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          onDismissCallback: (type) => controller.resumeCamera(),
          btnCancelOnPress: () {
            controller.resumeCamera();
          },
          btnCancelText: 'حاول مرة اخرى',
          title: 'خطأ',
          desc:
              'الكود الذي قمت بمسحه غير صحيح، يرجى التأكد من الكود والمحاولة مرة اخرى.',
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Scanner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              child: QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
              ),
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
              onPressed: toggleFlash,
            ),
          ],
        ),
      ),
    );
  }
}
