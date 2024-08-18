import 'dart:developer';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/core/classes/user.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/firebase_options.dart';
import 'routing/app_router.dart';
import 'routing/routes.dart';

late String initialRoute;
late int? initScreen;
late AppUser currentUser;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null || !user.emailVerified) {
    initialRoute = initScreen == 0 || initScreen == null
        ? Routes.onboardingScreen
        : Routes.loginScreen;
  } else {
    try {
      currentUser = await FireStoreFunctions.fetchUser(user.uid);
      initialRoute = currentUser.type == 'student'
          ? Routes.studentScreen
          : Routes.teacherScreen;
    } catch (e) {
      log("Error fetching user: $e");
      initialRoute = Routes.loginScreen;
    }
  }
  await ScreenUtil.ensureScreenSize();
  FlutterNativeSplash.remove();

  runApp(EasyDynamicThemeWidget(child: MyApp(router: AppRouter())));
}

class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({super.key, required this.router});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'BeStudent',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: EasyDynamicTheme.of(context).themeMode,
          onGenerateRoute: router.generateRoute,
          initialRoute: initialRoute,
        );
      },
    );
  }
}
