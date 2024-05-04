import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:student/core/widgets/app_bar.dart';
import 'package:student/theming/colors.dart';

import '../../../../../core/widgets/classes/group.dart';
import '../widget/get_all_students.dart';

class AllStudentsScreen extends StatefulWidget {
  const AllStudentsScreen({super.key, required this.group});
  final Group group;
  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  @override
  Widget build(BuildContext context) {
    late final PlutoGridStateManager stateManager;

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: '${widget.group.groupName} عرض جميع طلاب مجموعة',
          isTeacher: true,
        ),
        body: FutureBuilder(
          future: getStudentsRows(widget.group.groupId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.bouncingBall(
                  color: ColorsManager.mainBlue(context),
                  size: 90,
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('! حدث خطأ ما'),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('! لا توجد بيانات لعرضها حالياً'),
              );
            }

            final rows = snapshot.data as List<PlutoRow>;
            return Directionality(
              textDirection: TextDirection.rtl,
              child: PlutoGrid(
                  columns: columns,
                  rows: rows,
                  onChanged: (PlutoGridOnChangedEvent event) {
                    log('${event}        changed');
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    stateManager.setShowColumnFilter(true);
                  },
                  configuration: Theme.of(context).brightness == Brightness.dark
                      ? const PlutoGridConfiguration.dark()
                      : const PlutoGridConfiguration()),
            );
          },
        ),
      ),
    );
  }
}
