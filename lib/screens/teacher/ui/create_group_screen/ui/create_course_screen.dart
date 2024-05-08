import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/app_text_button.dart';
import 'package:student/core/widgets/app_text_form_field.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/helpers/extensions.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final String teacherId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء مجموعة'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextFormField(
                    hint: 'اسم المادة',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'من فضلك ادخل اسم المادة';
                      }
                    },
                    controller: _subjectNameController),
                Gap(20.h),
                AppTextFormField(
                    hint: 'اسم المجموعة',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'من فضلك ادخل اسم المجموعة';
                      }
                      return null;
                    },
                    controller: _groupNameController),
                Gap(20.h),
                AppTextFormField(
                    hint: 'اليوم',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'من فضلك ادخل اليوم';
                      }
                      return null;
                    },
                    controller: _dayController),
                Gap(20.h),
                AppTextFormField(
                    hint: 'الوقت',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'من فضلك ادخل الوقت';
                      }
                      return null;
                    },
                    controller: _durationController),
                Gap(20.h),
                AppTextFormField(
                    hint: 'المدة',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'من فضلك ادخل المدة';
                      }
                      return null;
                    },
                    controller: _durationController),
                Gap(20.h),
                AppTextButton(
                  buttonText: 'إنشاء',
                  textStyle: TextStyles.font18White400Weight,
                  onPressed: () {
                    if (_subjectNameController.text.isNotEmpty &&
                        _groupNameController.text.isNotEmpty &&
                        _dayController.text.isNotEmpty &&
                        _timeController.text.isNotEmpty &&
                        _durationController.text.isNotEmpty) {
                      _createGroup();
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: ColorsManager.coralRed,
                          content: Text('من فضلك املأ جميع الحقول'),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createGroup() {
    FireStoreFunctions.createGroup(
      teacherId: teacherId,
      subjectName: _subjectNameController.text,
      groupName: _groupNameController.text,
      day: _dayController.text,
      time: _timeController.text,
      duration: int.parse(_durationController.text),
    );
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _groupNameController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
