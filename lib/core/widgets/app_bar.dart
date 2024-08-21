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
                      AppUser user = await FireStoreFunctions.fetchUser(
                          FirebaseAuth.instance.currentUser!.uid);

                      return showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 36,
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.60,
                                width:
                                    MediaQuery.of(context).size.width * 0.860,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment(0.8, 1),
                                    colors: <Color>[
                                      Color(0xFFFEEDFC),
                                      Colors.white,
                                      Color(0xFFE4E6F7),
                                      Color(0xFFE2E5F5),
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      height: 240,
                                      width: 240,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment(0.8, 1),
                                          colors: <Color>[
                                            Colors.white,
                                            Color(0xFFE4E6F7),
                                            Colors.white,
                                          ],
                                          tileMode: TileMode.mirror,
                                        ),
                                      ),
                                      child: Center(
                                        child: QrImageView(
                                          data: user.id,
                                          size: 180,
                                          foregroundColor:
                                              const Color(0xFF8194FE),
                                        ),
                                      ),
                                    ),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Here your code!!',
                                          style: TextStyle(
                                            fontFamily: 'poppins_bold',
                                            fontSize: 28,
                                            color: Color(0xFF6565FF),
                                          ),
                                        ),
                                        Text(
                                          "This is your unique QR code for another person to scan",
                                          style: TextStyle(
                                            fontFamily: 'poppins_regular',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  _copyCode(context, user.id),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 32.0,
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  133,
                                                                  142,
                                                                  212)
                                                              .withOpacity(
                                                                  0.68),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  EvaIcons.copyOutline,
                                                  color: Color(0xFF6565FF),
                                                ),
                                              ),
                                            ),
                                            const Gap(8),
                                            const Text(
                                              "Copy",
                                              style: TextStyle(
                                                fontFamily: 'poppins_semi_bold',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(40),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 32.0,
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  133,
                                                                  142,
                                                                  212)
                                                              .withOpacity(
                                                                  0.68),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  EvaIcons.saveOutline,
                                                  color: Color(0xFF6565FF),
                                                ),
                                              ),
                                            ),
                                            const Gap(8),
                                            const Text(
                                              "Save",
                                              style: TextStyle(
                                                fontFamily: 'poppins_semi_bold',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
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

  void _copyCode(BuildContext context, String data) {
    // Unfocus any active text field to ensure the keyboard is dismissed
    FocusScope.of(context).unfocus();

    try {
      Clipboard.setData(ClipboardData(text: data))
          .then((value) => context.pop());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(child: Text('تم نسخ الكود ')),
          backgroundColor: ColorsManager.secondaryBlue(context),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('حدث خطأ أثناء نسخ الكود')),
          backgroundColor: ColorsManager.coralRed,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
