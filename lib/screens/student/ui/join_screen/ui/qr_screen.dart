import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/widgets/dialog_message.dart';
import 'package:student/helpers/app_regex.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
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
      late int joinState;
      setState(() {
        scannedCode = scanData.code!;
      });
      controller.stopCamera();
      controller.pauseCamera();

      if (AppRegex.isCodeValid(scannedCode)) {
        final groupId = await FireStoreFunctions.getDocId(
            collection: 'group', field: 'groupCode', value: scannedCode);
        joinState = await FireStoreFunctions.groupJoinRequest(
          userId: userId,
          code: scannedCode,
          groupId: groupId,
        );

        switch (joinState) {
          case 1:
            // ignore: use_build_context_synchronously
            CustomDialog.showDialog(
              context: context,
              type: DialogType.success,
              title: 'تم الانضمام بنجاح',
              message:
                  'تم الانضمام بنجاح للمجموعة، يمكنك الان الانتقال لصفحة المواد.',
              argument: 1,
            );
            break;
          case 0:
            // ignore: use_build_context_synchronously
            CustomDialog.showDialog(
              context: context,
              type: DialogType.info,
              title: 'منضم مسبقاً',
              message: 'انت بالفعل منضم لهذه المجموعة.',
              argument: 0,
            );
            break;
          case -1:
            // ignore: use_build_context_synchronously
            CustomDialog.showDialog(
              context: context,
              type: DialogType.error,
              title: 'خطأ',
              message:
                  'الكود الذي قمت بمسحه غير صحيح، يرجى التأكد من الكود والمحاولة مرة اخرى.',
              argument: 0,
            );
        }
      } else {
        CustomDialog.showDialog(
          context: context,
          type: DialogType.error,
          title: 'خطأ',
          message:
              'الكود الذي قمت بمسحه غير صحيح، يرجى التأكد من الكود والمحاولة مرة اخرى.',
          argument: 0,
        );
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
