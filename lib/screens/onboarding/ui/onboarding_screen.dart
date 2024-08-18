import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/theming/colors.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingSlider(
        headerBackgroundColor: ColorsManager.white(context),
        pageBackgroundColor: ColorsManager.white(context),
        controllerColor: ColorsManager.mainBlue(context),
        centerBackground: true,
        finishButtonText: 'تسجيل',
        finishButtonStyle: FinishButtonStyle(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: ColorsManager.mainBlue(context),
        ),
        onFinish: () {
          context.pushNamedAndRemoveUntil(
            Routes.signupScreen,
            predicate: (route) => false,
          );
        },
        trailingFunction: () {
          context.pushNamedAndRemoveUntil(
            Routes.loginScreen,
            predicate: (route) => false,
          );
        },
        background: [
          Image.asset('assets/images/logo.png', scale: 1.5),
          Image.asset('assets/images/calendar.png', scale: 1.2),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 420.h,
                ),
                Text(
                  "مرحبًا بك في BeStudent، مساعدك الشخصي لتحقيق النجاح الأكاديمي! 🎓جاهز للتفوق؟ نحن هنا لدعمك في كل خطوة. دعنا نبدأ رحلتك التعليمية معًا! 🌟",
                  style: TextStyle(
                    color: ColorsManager.black(context),
                    fontSize: 16.sp,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 420.h,
                ),
                Text(
                  'نظّم وقتك بكفاءة مع BeStudent! 🗓️ خطط جدولك الدراسي بسهولة، وحدد أولوياتك، وابقَ دائمًا على المسار الصحيح لتحقيق أهدافك.',
                  style: TextStyle(
                    color: ColorsManager.black(context),
                    fontSize: 16.sp,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
