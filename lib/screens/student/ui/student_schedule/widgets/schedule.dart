import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../../../theming/colors.dart';

class StudentSchedule extends StatelessWidget {
  const StudentSchedule({super.key, required this.appointments});
  final CalendarDataSource appointments;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      firstDayOfWeek: 6, // Saturday
      allowedViews: const <CalendarView>[
        CalendarView.month,
        CalendarView.week,
      ],
      dataSource: appointments,
      monthViewSettings: MonthViewSettings(
        showAgenda: true,
        agendaViewHeight: 300.h,
        navigationDirection: MonthNavigationDirection.horizontal,
      ),
      appointmentTimeTextFormat: 'hh:mm a',
      headerDateFormat: 'MMMM yyyy',
      cellBorderColor: ColorsManager.mainBlue(context),
      todayHighlightColor: ColorsManager.mainBlue(context),
      timeZone: 'Egypt Standard Time',
    );
  }
}
