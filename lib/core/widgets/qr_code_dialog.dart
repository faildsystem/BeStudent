import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/core/classes/group.dart';
import 'package:student/core/widgets/qr_code_generator.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class GroupQrCode extends StatelessWidget {
  final Group group;
  const GroupQrCode({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrCodeGenerator(
              data: group.groupCode,
              width: 150,
              height: 150,
            ),
            Gap(15.h),
            TextButton(
              onPressed: () {
                _copyCode(context);
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
              child: Text(
                'نسخ الكود',
                style: TextStyles.font16Blue400Weight,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _copyCode(BuildContext context) {
    // Unfocus any active text field to ensure the keyboard is dismissed
    FocusScope.of(context).unfocus();

    try {
      Clipboard.setData(ClipboardData(text: group.groupCode))
          .then((value) => context.pop());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(child: Text('تم نسخ الكود ')),
          backgroundColor: ColorsManager.secondaryBlue(context),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('حدث خطأ أثناء نسخ الكود')),
          backgroundColor: ColorsManager.coralRed,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
