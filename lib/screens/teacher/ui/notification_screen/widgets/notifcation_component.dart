import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student/core/widgets/classes/group.dart';
import 'package:student/core/widgets/classes/requests.dart';
import 'package:student/core/widgets/classes/user.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/theming/colors.dart';
import 'package:student/theming/styles.dart';

class NotifcationComponent extends StatefulWidget {
  const NotifcationComponent({Key? key, required this.request})
      : super(key: key);

  final Request request;

  @override
  State<NotifcationComponent> createState() => _NotifcationComponentState();
}

class _NotifcationComponentState extends State<NotifcationComponent> {
  bool isButtonDisabled = false;
  late AppUser student;
  late Group group;

  @override
  void initState() {
    super.initState();
    student = widget.request.student;
    group = widget.request.group;
  }

  void _onAcceptPressed() {
    setState(() {
      FireStoreFunctions.enrollStudent(
          userId: student.id, code: group.groupCode, groupId: group.groupId);
      isButtonDisabled = true;
      FireStoreFunctions.deleteRequestStatus(
          widget.request.requestId);
    });
  }

  void _onRejectPressed() {
    setState(() {
      isButtonDisabled = true;
      FireStoreFunctions.deleteRequestStatus(
          widget.request.requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.w,
                backgroundImage:
                    student.image != '' ? NetworkImage(student.image!) : null,
                child: student.image == ''
                    ? Text(
                        ('${student.firstName[0]} ${student.lastName[0]}'),
                        style: TextStyles.font18DarkBlue700Weight,
                      )
                    : null,
              ),
              Gap(10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${student.firstName} ${student.lastName}",
                    style: TextStyles.font14Grey400Weight,
                  ),
                  Gap(5.h),
                  Text(
                    "يريد الانضمام الى مجموعة ${group.groupName}",
                    style: TextStyles.font11DarkBlue400Weight,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: isButtonDisabled ? null : _onAcceptPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorsManager.mainBlue(context),
                ),
                child: const Text("قبول"),
              ),
              Gap(5.w),
              TextButton(
                onPressed: isButtonDisabled ? null : _onRejectPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorsManager.coralRed,
                ),
                child: const Text("رفض"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
