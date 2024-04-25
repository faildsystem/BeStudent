import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingSlider(
        headerBackgroundColor: ColorsManager.white(context),
        skipTextButton: Text(
          'Skip',
          style: TextStyles.font14Blue400Weight,
        ),
        trailing: Text(
          'Login',
          style: TextStyles.font14Blue400Weight,
        ),
        controllerColor: ColorsManager.mainBlue(context),
        centerBackground: true,
        finishButtonText: 'Register',
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
          Image.asset('assets/images/slide_1.png', scale: 1.5),
          Image.asset('assets/images/slide_2.png', scale: 3),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child:  Column(
              children: <Widget>[
                SizedBox(
                  height: 420.h,
                ),
                const Text(
                    "Hey there, eager learner! 🎓 Welcome to BeStudent, where your academic journey gets an upgrade! We're thrilled to have you on board. Let's kickstart this adventure together! Tap 'Next' to continue."),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child:  Column(
              children: <Widget>[
                SizedBox(
                  height: 420.h,
                ),
                const Text('Description Text 2'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
