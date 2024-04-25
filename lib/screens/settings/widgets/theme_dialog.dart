import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = EasyDynamicTheme.of(context).themeMode == ThemeMode.dark;
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
                  title: const Text('داكن'),
                  trailing: isDarkTheme ? const Icon(Icons.check) : null,
                  onTap: () {
                    EasyDynamicTheme.of(context).changeTheme(dark: true);
                    setState(() {
                      isDarkTheme = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('فاتح'),
                  trailing: !isDarkTheme ? const Icon(Icons.check) : null,
                  onTap: () {
                    EasyDynamicTheme.of(context).changeTheme(dark: false);
                    setState(() {
                      isDarkTheme = false;
                    });
                    Navigator.of(context).pop();
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
