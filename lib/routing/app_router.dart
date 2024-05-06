import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/screens/profile/ui/profile_screen.dart';
import 'package:student/screens/student/ui/groups_screen/ui/qr_code_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/join_group_screen.dart';
import 'package:student/screens/student/ui/join_screen/ui/qr_screen.dart';
import 'package:student/screens/student/ui/groups_screen/ui/student_groups_screen.dart';
import 'package:student/screens/student/ui/student_navigator.dart';
import 'package:student/screens/onboarding/ui/onboarding_screen.dart';
import 'package:student/screens/settings/ui/settings_screen.dart';
import 'package:student/screens/splash/ui/splash_screen.dart';
import 'package:student/screens/teacher/ui/create_group_screen/ui/create_course_screen.dart';
import 'package:student/screens/teacher/ui/groups_screen/ui/teacher_groups_screen.dart';
import 'package:student/screens/teacher/ui/notification_screen/ui/notifications_screen.dart';
import 'package:student/screens/teacher/ui/teacher_navigator.dart';

import '../screens/create_password/ui/create_password.dart';
import '../screens/forget/ui/forget_screen.dart';
import '../screens/login/ui/login_screen.dart';
import '../screens/signup/ui/sign_up_sceen.dart';
import '../screens/teacher/ui/group_students_screen/ui/show_all_students_screen.dart';
import 'routes.dart';

class AppRouter {
  // Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  //   if (settings.name == Routes.forgetScreen) {
  //     return MaterialPageRoute(
  //       builder: (_) => const ForgetScreen(),
  //     );
  //   }
  // }

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

      case Routes.joinGroupScreen:
        return MaterialPageRoute(
          builder: (_) => const JoinCourseScreen(),
        );

      case Routes.studentGroupsScreen:
        return MaterialPageRoute(
          builder: (_) => const StudentGroupsScreen(),
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

      case Routes.studentQrCodeScreen:
        return MaterialPageRoute(
          builder: (_) => QrCodeScreen(),
        );

      case Routes.teacherScreen:
        final int? index = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => TeacherNavigator(
            currentIndex: index ?? 0,
          ),
        );

      case Routes.createGroupScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateGroupScreen(),
        );

      case Routes.teacherGroupsScreen:
        return MaterialPageRoute(
          builder: (_) => const TeacherGroupsScreen(),
        );

      case Routes.teacherNotificationsScreen:
        return MaterialPageRoute(
          builder: (_) => TeacherNotificationsScreen(),
        );
      case Routes.allStudentsScreen:
        final List<String> group = settings.arguments as List<String>;

        return MaterialPageRoute(
          builder: (_) =>
              AllStudentsScreen(groupId: group[0], groupName: group[1]),
        );
    }
    return null;
  }
}
