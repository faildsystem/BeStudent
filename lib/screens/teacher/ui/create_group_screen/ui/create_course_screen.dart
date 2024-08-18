import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/classes/days.dart';
import 'package:student/core/classes/subject.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // // Grade levels
  // final List<String> _grades = [
  //   'الصف الأول',
  //   'الصف الثاني',
  //   'الصف الثالث',
  //   'الصف الرابع',
  //   'الصف الخامس',
  //   'الصف السادس',
  //   'الصف الاول الاعدادي',
  //   'الصف الثاني الاعدادي',
  //   'الصف الثالث الاعدادي',
  //   'الصف الاول الثانوي',
  //   'الصف الثاني الثانوي',
  //   'الصف الثالث الثانوي',
  // ];

  String? _selectedSubject;
  String? _selectedDay;
  // String? _selectedGrade;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء مجموعة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextFormField(
                      hint: 'اسم المجموعة',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل اسم المجموعة';
                        }
                        return null;
                      },
                      controller: _groupNameController,
                      suffixIcon: const Icon(Icons.group),
                    ),
                    Gap(20.h),
                    Container(
                      constraints: BoxConstraints(maxHeight: 300.h),
                      child: DropdownButtonFormField<String>(
                        decoration: _inputDecoration('اسم المادة', Icons.book),
                        items: Subject.subjects.keys.map((subject) {
                          return DropdownMenuItem<String>(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubject = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'من فضلك اختر اسم المادة';
                          }
                          return null;
                        },
                      ),
                    ),
                    // Gap(20.h),
                    // DropdownButtonFormField<String>(
                    //   decoration: _inputDecoration('الصف الدراسي', Icons.grade),
                    //   items: _grades.map((grade) {
                    //     return DropdownMenuItem<String>(
                    //       value: grade,
                    //       child: Text(grade),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       // _selectedGrade = value;
                    //     });
                    //   },
                    //   validator: (value) {
                    //     if (value == null) {
                    //       return 'من فضلك اختر الصف الدراسي';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    Gap(20.h),
                    DropdownButtonFormField<String>(
                      decoration:
                          _inputDecoration('اليوم', Icons.calendar_today),
                      items: Days.days.map((day) {
                        return DropdownMenuItem<String>(
                          value: day['abbr'],
                          child: Text(day['name']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'من فضلك اختر اليوم';
                        }
                        return null;
                      },
                    ),
                    Gap(20.h),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: AppTextFormField(
                          hint: _selectedTime == null
                              ? 'الوقت'
                              : _selectedTime!.format(context),
                          controller: _timeController,
                          validator: (value) {
                            if (_selectedTime == null) {
                              return 'من فضلك اختر الوقت';
                            }
                            return null;
                          },
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                    Gap(20.h),
                    AppTextFormField(
                      hint: 'المدة',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل المدة';
                        }
                        if (int.tryParse(value) == null) {
                          return 'من فضلك ادخل قيمة صالحة';
                        }
                        return null;
                      },
                      controller: _durationController,
                      suffixIcon: const Icon(Icons.timer),
                    ),
                    Gap(20.h),
                    AppTextButton(
                      buttonText: 'إنشاء',
                      textStyle: TextStyles.font20White400Weight,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _createGroup();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: ColorsManager.mainBlue(context),
                              content: const Text('تم إنشاء المجموعة بنجاح'),
                            ),
                          );
                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: ColorsManager.coralRed,
                              content:
                                  Text('من فضلك املأ جميع الحقول بشكل صحيح'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: ColorsManager.mainBlue(context)),
      filled: true,
      fillColor: ColorsManager.lightShadeOfGray(context),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorsManager.gray93Color(context),
          width: 1.3.w,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorsManager.mainBlue(context),
          width: 1.3.w,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorsManager.coralRed,
          width: 1.3.w,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorsManager.coralRed,
          width: 1.3.w,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _createGroup() async {
    await FireStoreFunctions.createGroup(
      teacherId: teacherId,
      subjectName: _selectedSubject!,
      groupName: _groupNameController.text,
      // grade: _selectedGrade!, // Save selected grade
      day: _selectedDay!, // Use abbreviation
      time: _selectedTime!.format(context),
      duration: int.parse(_durationController.text),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _durationController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
