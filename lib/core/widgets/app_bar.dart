import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/widgets/generate_qr.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/core/classes/user.dart';
import 'package:student/screens/profile/widgets/edit_profile_form.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isProfile;
  final bool isSettings;
  final bool isTeacher;

  MyAppBar(
      {Key? key,
      required this.title,
      this.isSettings = false,
      this.isProfile = false,
      this.isTeacher = false})
      : super(key: key);

  final Future<AppUser> user =
      FireStoreFunctions.fetchUser(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            title: Text(
              title,
              style: TextStyles.font18DarkBlue700Weight,
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            actions: [
              if (!isSettings)
                isTeacher
                    ? IconButton(
                        iconSize: 25,
                        icon: const Icon(Icons.notifications),
                        tooltip: 'Notifications',
                        onPressed: () {
                          context.pushNamed(
                            Routes.teacherNotificationsScreen,
                          );
                        },
                      )
                    : IconButton(
                        iconSize: 25,
                        icon: const Icon(Icons.notifications),
                        tooltip: 'Notifications',
                        onPressed: () {
                          context.pushNamed(
                            Routes.studentNotificationsScreen,
                          );
                        },
                      ),
              if (!isSettings)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: ColorsManager.mainBlue(context),
                  ),
                )
            ],
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            AppUser user = snapshot.data!;
            return AppBar(
              title: Text(
                title,
                style: TextStyles.font18DarkBlue700Weight,
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              actions: [
                if (isProfile)
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(FontAwesomeIcons.qrcode),
                    tooltip: 'QR Code',
                    onPressed: () async {
                      QrDialog().showQR(context, user.id);
                    },
                  ),
                if (isProfile)
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(Icons.edit),
                    tooltip: 'edit',
                    onPressed: () {
                      EditProfile.editProfileForm(context);
                    },
                  ),
                if (!isSettings && !isProfile)
                  isTeacher
                      ? IconButton(
                          iconSize: 25,
                          icon: const Icon(Icons.notifications),
                          tooltip: 'Notifications',
                          onPressed: () {
                            context.pushNamed(
                              Routes.teacherNotificationsScreen,
                            );
                          },
                        )
                      : IconButton(
                          iconSize: 25,
                          icon: const Icon(Icons.notifications),
                          tooltip: 'Notifications',
                          onPressed: () {
                            context.pushNamed(
                              Routes.studentNotificationsScreen,
                            );
                          },
                        ),
                if (!isSettings && !isProfile)
                  GestureDetector(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(
                        Routes.profileScreen,
                        predicate: (route) => true,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 17.w,
                        backgroundColor: ColorsManager.gray76(context),
                        child: CircleAvatar(
                          radius: 15.w,
                          backgroundImage: user.image != ''
                              ? NetworkImage(user.image!)
                              : null,
                          child: user.image == ''
                              ? Text(
                                  '${user.firstName[0]} ${user.lastName[0]}',
                                  style: TextStyles.font14DarkBlue500Weight,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
