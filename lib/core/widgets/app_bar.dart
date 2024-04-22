import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/core/widgets/classes/user.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isProfileOrSettings;

  MyAppBar({Key? key, required this.title, this.isProfileOrSettings = false})
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
              if (!isProfileOrSettings)
                IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.notifications),
                  tooltip: 'Notifications',
                  onPressed: () {},
                ),
              if (!isProfileOrSettings)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: ColorsManager.mainBlue,
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
                if (!isProfileOrSettings)
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(Icons.notifications),
                    tooltip: 'Notifications',
                    onPressed: () {},
                  ),
                if (!isProfileOrSettings)
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
                        backgroundColor: ColorsManager.gray76,
                        child: CircleAvatar(
                          radius: 15.w,
                          backgroundImage: user.image != null
                              ? NetworkImage(user.image!)
                              : null,
                          child: user.image == null
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
