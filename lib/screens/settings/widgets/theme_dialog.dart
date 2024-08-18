import 'dart:developer';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:student/helpers/extensions.dart';
import '../../../routing/routes.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({Key? key, required this.isTeacher}) : super(key: key);
  final bool isTeacher;

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  @override
  Widget build(BuildContext context) {
    // Determine if the current theme should be dark
    bool isDarkTheme;

    final themeMode = EasyDynamicTheme.of(context).themeMode;
    if (themeMode == ThemeMode.system) {
      final brightness = MediaQuery.of(context).platformBrightness;
      isDarkTheme = brightness == Brightness.dark;
    } else {
      isDarkTheme = themeMode == ThemeMode.dark;
    }

    log(isDarkTheme.toString());

    return SimpleDialog(
      title: const Text(
        'المظهر',
        textAlign: TextAlign.center,
      ),
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: const Text('فاتح'),
                  trailing: !isDarkTheme ? const Icon(Icons.check) : null,
                  onTap: () {
                    EasyDynamicTheme.of(context).changeTheme(dark: false);
                    setState(() {
                      isDarkTheme = false;
                    });
                    if (widget.isTeacher) {
                      context.pushNamedAndRemoveUntil(Routes.teacherScreen,
                          arguments: 3, predicate: (route) => false);
                    } else {
                      context.pushNamedAndRemoveUntil(Routes.studentScreen,
                          arguments: 3, predicate: (route) => false);
                    }
                  },
                ),
                ListTile(
                  title: const Text('داكن'),
                  trailing: isDarkTheme ? const Icon(Icons.check) : null,
                  onTap: () {
                    EasyDynamicTheme.of(context).changeTheme(dark: true);
                    setState(() {
                      isDarkTheme = true;
                    });
                    if (widget.isTeacher) {
                      context.pushNamedAndRemoveUntil(Routes.teacherScreen,
                          arguments: 3, predicate: (route) => false);
                    } else {
                      context.pushNamedAndRemoveUntil(Routes.studentScreen,
                          arguments: 3, predicate: (route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
