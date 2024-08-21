import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theming/colors.dart';
import '../../theming/styles.dart';

class AppTextFormField extends StatelessWidget {
  final String hint;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool? isObscureText;
  final bool? isDense;
  final TextEditingController? controller;
  final Function(String?) validator;
  final TextInputType? keyboardType;

  const AppTextFormField({
    super.key,
    required this.hint,
    this.suffixIcon,
    this.isObscureText,
    this.isDense,
    this.controller,
    this.onChanged,
    this.focusNode,
    required this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      validator: (value) {
        return validator(value);
      },
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        hintText: hint,
        hintStyle: TextStyles.font14Hint500Weight,
        isDense: isDense ?? true,
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
        suffixIcon: suffixIcon,
      ),
      obscuringCharacter: '*',
      obscureText: isObscureText ?? false,
      style: TextStyles.font14DarkBlue500Weight,
    );
  }
}
