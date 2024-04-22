import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/core/widgets/app_text_button.dart';
import 'package:student/core/widgets/app_text_form_field.dart';
import 'package:student/core/widgets/divided_text.dart';
import 'package:student/helpers/app_regex.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/routing/routes.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  String courseCode = '123456';
  final TextEditingController codeController = TextEditingController();

  bool _isCodeValid() {
    return codeController.text == courseCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'الصفحة الرئيسية'),
      body: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap(20.h),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: AppTextFormField(
                      hint: 'أدخل كود المادة',
                      validator: (value) {
                        if (value == null ||
                            value.length < 6 ||
                            !AppRegex.isCodeValid(value)) {
                          return 'من فضلك أدخل كود المادة بشكل صحيح';
                        }
                      },
                      controller: codeController,
                    ),
                  ),
                ),
                Gap(20.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildNotesRow(
                          'اطلب من معلمك كود المادة لتتمكن من الانضمام.'),
                      Gap(10.h),
                      buildNotesRow(
                          'الكود يجب أن يحتوي على ٦ أحرف على الأقل بدون مسافات او رموز.'),
                    ],
                  ),
                ),
                Gap(20.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: AppTextButton(
                      buttonText: 'انضمام',
                      textStyle: TextStyles.font16White600Weight,
                      onPressed: () {
                        if (_isCodeValid()) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            title: ' تم الانضمام بنجاح',
                            desc:
                                'تم انضمامك بنجاح لمادة ؟؟، يمكنك الان البدء في حل الواجبات والمشاركة في الدروس.',
                          ).show();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: ColorsManager.coralRed,
                              content: Center(
                                child: Text(
                                  'كود المادة غير صحيح',
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
                Gap(30.h),
                DividedText(
                  text: 'او انضم عن طريق QR Code',
                  width: MediaQuery.of(context).size.width / 4,
                ),
                Gap(60.h),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routes.qrScannerScreen);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.expand,
                              size: 150,
                              color: ColorsManager.mainBlue(context),
                            ),
                            Icon(
                              FontAwesomeIcons.camera,
                              size: 75,
                              color: ColorsManager.mainBlue(context),
                            ),
                          ],
                        ),
                        Text(
                          'اضغط لفتح الكاميرا',
                          style: TextStyles.font14DarkBlue500Weight,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotesRow(String text) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        CircleAvatar(
          radius: 3,
          backgroundColor: ColorsManager.gray(context),
        ),
        Gap(5.w),
        Text(
          text,
          style: TextStyles.font12DarkBlue600Weight,
        )
      ],
    );
  }
}
