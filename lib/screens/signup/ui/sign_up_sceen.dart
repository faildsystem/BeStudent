import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/theming/colors.dart';


import '../../../core/widgets/already_have_account_text.dart';

import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../theming/styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.only(left: 30.w, right: 30.w, bottom: 5.h, top: 5.h),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إنشاء حساب',
                  style: TextStyles.font24Blue700Weight,
                ),
                Gap(0.001.sh),
                Text(
                  'اطلق العنان لإمكانياتك الكاملة مع بي ستودنت',
                  style: TextStyles.font13Grey400Weight,
                ),
                Gap(0.01.sh),
                TabBar(
                  indicatorColor: ColorsManager.mainBlue(context),
                  labelColor: ColorsManager.mainBlue(context),
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'مُعلم'),
                    Tab(text: 'طالب'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      EmailAndPassword(isSignUpPage: true),
                      EmailAndPassword(
                        isSignUpPage: true,
                        isStudent: true,
                      ),
                    ],
                  ),
                ),
                Gap(5.h),
                const Center(child: AlreadyHaveAccountText()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
