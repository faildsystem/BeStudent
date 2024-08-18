import 'package:flutter/material.dart';

class ColorsManager {
  static Color mainBlue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF247CFF)
        : const Color(0xFF247CFF);
  }

  static Color secondaryBlue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF6789CA)
        : const Color(0xFF6789CA);
  }

  static Color gray(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : const Color(0xFF757575);
  }

  static Color gray93Color(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : const Color(0xFFEDEDED);
  }

  static Color gray76(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : const Color(0xFFC2C2C2);
  }

  static Color darkBlue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0BA88B)
        : const Color(0xFF242424);
  }

  static Color lightShadeOfGray(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 32, 38, 43)
        : const Color(0xFFFDFDFF);
  }

  static Color mediumLightShadeOfGray(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : const Color(0xFF9E9E9E);
  }

  static Color purple(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.purple
        : const Color(0xFF9C27B0);
  }

  static Color white(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF242424)
        : const Color(0xFFF4F6F7);
  }

  static Color black(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF313131);
  }

  static const Color coralRed = Color(0xFFFF4C5E);
  static const Color mainBlueColor = Color(0xFF247CFF);
  static const Color green = Color(0xFF0BA88B);
}

  // static const Color secondaryBlue = Color(0xFF6789CA);
  // static const Color gray = Color(0xFF757575);
  // static const Color gray93Color = Color(0xFFEDEDED);
  // static const Color gray76 = Color(0xFFC2C2C2);
  // static const Color darkBlue = Color(0xFF242424);
  // static const Color lightShadeOfGray = Color(0xFFFDFDFF);
  // static const Color mediumLightShadeOfGray = Color(0xFF9E9E9E);
  // static const Color purple = Color(0xFF9C27B0);
  // static const Color white = Color(0xFFF4F6F7);
  // static const Color black = Color(0xFF313131);