import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:student/core/widgets/no_internet.dart';
import 'package:student/theming/colors.dart';

class MyOfflineBuilder extends StatelessWidget {
  final Widget page;
  const MyOfflineBuilder({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected ? page : const BuildNoInternet();
      },
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorsManager.mainBlue,
        ),
      ),
    );
  }
}
