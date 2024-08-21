import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/theming/colors.dart';

class QrDialog {
  Future<void> showQR(BuildContext context, dynamic data,
      {bool isGroup = false}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 36,
              ),
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.860,
              decoration: const BoxDecoration(
                color: Colors.black,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xFFFEEDFC),
                    Colors.white,
                    Color(0xFFE4E6F7),
                    Color(0xFFE2E5F5),
                  ],
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 240,
                    width: 240,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Colors.white,
                          Color(0xFFE4E6F7),
                          Colors.white,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: Center(
                      child: QrImageView(
                        data: isGroup ? data.groupCode : data,
                        size: 180,
                        foregroundColor: ColorsManager.mainBlue(context),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGroup
                            ? 'رمز مجموعة ${data.groupName}'
                            : 'هذا هو رمز الاستجابة السريعة الخاص بك',
                        style: TextStyle(
                          fontFamily: 'poppins_bold',
                          fontSize: 16.sp,
                          color: ColorsManager.secondaryBlue(context),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _copyCode(context, isGroup ? data.groupCode : data),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 32.0,
                                    color:
                                        const Color.fromARGB(255, 133, 142, 212)
                                            .withOpacity(0.68),
                                  ),
                                ],
                              ),
                              child: Icon(
                                EvaIcons.copyOutline,
                                color: ColorsManager.mainBlue(context),
                              ),
                            ),
                          ),
                          const Gap(8),
                          const Text(
                            "Copy",
                            style: TextStyle(
                              fontFamily: 'poppins_semi_bold',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Gap(40),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 32.0,
                                    color:
                                        const Color.fromARGB(255, 133, 142, 212)
                                            .withOpacity(0.68),
                                  ),
                                ],
                              ),
                              child: Icon(
                                EvaIcons.saveOutline,
                                color: ColorsManager.mainBlue(context),
                              ),
                            ),
                          ),
                          const Gap(8),
                          const Text(
                            "Save",
                            style: TextStyle(
                              fontFamily: 'poppins_semi_bold',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _copyCode(BuildContext context, String data) {
    // Unfocus any active text field to ensure the keyboard is dismissed
    FocusScope.of(context).unfocus();

    try {
      Clipboard.setData(ClipboardData(text: data))
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
