import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/no_internet.dart';
import '../../../theming/colors.dart';
import '../../../core/widgets/divided_text.dart';
import '../../../helpers/google_sign_in.dart';
import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../theming/styles.dart';
import 'widgets/do_not_have_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? _loginPage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainBlue,
          ),
        ),
      ),
    );
  }

  Widget _loginPage(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: 30.w, right: 30.w, bottom: 15.h, top: 15.h),
          child: SingleChildScrollView(
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تسجيل الدخول ',
                  style: TextStyles.font24Blue700Weight,
                ),
                Gap(0.02.sh),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "سجل الدخول لتستمر في تعلمك وتطوير مهاراتك",
                        style: TextStyles.font13Grey400Weight,
                      ),
                    ],
                  ),
                ),
                Gap(0.02.sh),
                EmailAndPassword(),
                Gap(0.02.sh),
                const Center(child: DoNotHaveAccountText()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

