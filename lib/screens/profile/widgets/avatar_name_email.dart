import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/screens/profile/widgets/edit_profile_form.dart';
import 'package:student/screens/profile/widgets/update_profile_pic.dart';
import 'package:student/core/widgets/classes/user.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late Future<AppUser> user;

  @override
  void initState() {
    super.initState();
    user = FireStoreFunctions.fetchUser(FirebaseAuth.instance.currentUser!.uid);
  }


  final ProfilePic profilePic = ProfilePic();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final user = snapshot.data!;
          return _buildProfileAvatar(user);
        }
      },
    );
  }

  Widget _buildProfileAvatar(AppUser user) {
    return Column(
      children: [
        Gap(15.h),
        GestureDetector(
          onTap: () {
            profilePic.pickUploadPic().then((imageUrl) {
              setState(() {
                user.image = imageUrl;
              });
            });
          },
          child: CircleAvatar(
            radius: 60.w,
            backgroundColor: ColorsManager.gray,
            child: CircleAvatar(
              radius: 57.w,
              backgroundImage: user.image != null
                  ? NetworkImage(user.image!)
                  : null,
              child: user.image == null
                  ? Text(
                      ('${user.firstName[0]} ${user.lastName[0]}'),
                      style: TextStyles.font18DarkBlue700Weight,
                    )
                  : null,
            ),
          ),
        ),
        Gap(15.h),
        Text(
          ('${user.firstName} ${user.lastName}'),
          style: TextStyles.font17DarkBlue700Weight,
        ),
        Gap(5.h),
        Text(user.email, style: TextStyles.font11DarkBlue600Weight),
        Gap(10.h),
        Column(
          children: [
            IconButton(
              onPressed: () {
                EditProfile.editProfileForm(context);
              },
              icon: const Icon(
                Icons.edit,
                color: ColorsManager.darkBlue,
              ),
            ),
          ],
        )
      ],
    );
  }
}
