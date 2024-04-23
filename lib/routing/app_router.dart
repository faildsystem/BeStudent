import 'package:flutter/material.dart';
import 'package:student/screens/profile/ui/profile_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/join_group_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/qr_screen.dart';
import 'package:student/screens/student/ui/groups_screen/ui/student_groups_screen.dart';
import 'package:student/screens/student/ui/student_navigator.dart';
import 'package:student/screens/onboarding/ui/onboarding_screen.dart';
import 'package:student/screens/settings/ui/settings_screen.dart';
import 'package:student/screens/splash/ui/splash_screen.dart';
import 'package:student/screens/teacher/screens/teacher_navigator.dart';

import '../screens/create_password/ui/create_password.dart';
import '../screens/forget/ui/forget_screen.dart';
import '../screens/login/ui/login_screen.dart';
import '../screens/signup/ui/sign_up_sceen.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.forgetScreen:
        return MaterialPageRoute(
          builder: (_) => const ForgetScreen(),
        );

      case Routes.createPassword:
        final arguments = settings.arguments;
        if (arguments is List) {
          return MaterialPageRoute(
            builder: (_) => CreatePassword(
              googleUser: arguments[0],
              credential: arguments[1],
            ),
          );
        }
        return null;
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnBoarding(),
        );

      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case Routes.joinCourseScreen:
        return MaterialPageRoute(
          builder: (_) => const JoinCourseScreen(),
        );

      case Routes.studentCourseScreen:
        return MaterialPageRoute(
          builder: (_) => const StudentCourseScreen(),
        );

      case Routes.studentScreen:
        final int? index = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => StudentNavigator(
            currentIndex: index ?? 0,
          ),
        );

      case Routes.qrScannerScreen:
        return MaterialPageRoute(
          builder: (_) => const QRScannerScreen(),
        );

      case Routes.teacherCourseScreen:
        final int? index = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => TeacherNavigator(
            currentIndex: index ?? 0,
          ),
        );
        
      case Routes.teacherScreen:
        final int? index = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => TeacherNavigator(
            currentIndex: index ?? 0,
          ),
        );
    }
    return null;
  }
}
