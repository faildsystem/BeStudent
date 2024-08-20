import 'package:flutter/material.dart';

import '../../../../helpers/extensions.dart';
import '../../../../routing/routes.dart';
import '../../../../theming/styles.dart';

class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.signupScreen);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'لا تمتلك حساب؟',
              style: TextStyles.font14Blue400Weight,
            ),
            TextSpan(
              text: ' أنشئ حسابك الآن',
              style: TextStyles.font14Blue400Weight,
            ),
          ],
        ),
      ),
    );
  }
}
