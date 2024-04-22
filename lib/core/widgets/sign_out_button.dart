import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/theming/colors.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('Sign Out',
          style: TextStyle(
            color: ColorsManager.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
      onPressed: () async {
        try {
          GoogleSignIn().disconnect();
          FirebaseAuth.instance.signOut();
          context.pushNamedAndRemoveUntil(
            Routes.loginScreen,
            predicate: (route) => false,
          );
        } catch (e) {
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Sign out error',
            desc: e.toString(),
          ).show();
        }
      },
    );
  }
}
