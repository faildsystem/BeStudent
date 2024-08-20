import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../../routing/routes.dart';
import '../../theming/styles.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamedAndRemoveUntil(
          Routes.loginScreen,
          predicate: (route) => false,
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'لديك حساب بالفعل؟',
              style: TextStyles.font11DarkBlue400Weight
                  .copyWith(color: const Color.fromARGB(255, 29, 221, 255)),
            ),
            TextSpan(
              text: ' تسجيل الدخول',
              style: TextStyles.font11Blue600Weight.copyWith(
                color: const Color.fromARGB(255, 29, 221, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
