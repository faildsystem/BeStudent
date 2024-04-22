import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';

class CustomDialog {
  static void showDialog({
    required BuildContext context,
    required DialogType type,
    required String title,
    required String message,
    required int argument,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      btnOk: TextButton(
        onPressed: () {
          context.pushNamedAndRemoveUntil(
            Routes.studentScreen,
            arguments: argument,
            predicate: (route) => false,
          );
        },
        child: const Text('حسنا'),
      ),
      title: title,
      desc: message,
    ).show();
  }
}
