import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:student/theming/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/already_have_account_text.dart';
import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../theming/styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding:
                EdgeInsets.only(left: 30.w, right: 30.w, bottom: 5.h, top: 5.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إنشاء حساب',
                    style: TextStyles.font24Blue700Weight,
                  ),
                  Gap(0.001.sh),
                  Text(
                    'اطلق العنان لإمكانياتك الكاملة مع BeStudent ',
                    style: TextStyles.font13Grey400Weight,
                  ),
                  EmailAndPassword(
                    isSignUpPage: true,
                    isStudent: true,
                  ),
                  Gap(0.02.sh),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'مدرس؟  ',
                            style: TextStyles.font14Blue400Weight,
                          ),
                          TextSpan(
                            text: 'تواصل معنا',
                            style: TextStyles.font14Blue400Weight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(0.005.sh),
                  const Center(
                    child: IconButton(
                      onPressed: _launchWhatsappGroup,
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        size: 40,
                        color: ColorsManager.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  const Center(child: AlreadyHaveAccountText()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchWhatsappGroup() async {
  const String messageForm =
      'السلام عليكم أود إنشاء حساب معلم في تطبيق BeStudent';
  String url = 'https://wa.me/201011309251?text=$messageForm';

  // ignore: deprecated_member_use
  launch(url);
}
