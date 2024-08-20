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
              style: TextStyles.font14DarkBlue500Weight
                  .copyWith(color: const Color.fromARGB(255, 29, 221, 255)),
            ),
            TextSpan(
              text: ' أنشئ حسابك الآن',
              style: TextStyles.font11Blue600Weight
                  .copyWith(color: const Color.fromARGB(255, 29, 221, 255)),
            ),
          ],
        ),
      ),
    );
  }
}
