import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/routing/routes.dart';

class MoreButton extends StatelessWidget {
  const MoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset.fromDirection(1.h, 50.h),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'settings',
          child: Text("Settings"),
        ),
      ],
      onSelected: (value) {
        if (value == "settings") {
          Navigator.pushNamed(context, Routes.settingsScreen);
        }
      },
    );
  }
}
