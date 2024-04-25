import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../theming/colors.dart';
import '../appointments.dart';

class AppointmentTimeTextFormat extends StatelessWidget {
  const AppointmentTimeTextFormat({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      scheduleViewMonthHeaderBuilder:
          (BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
        // final String monthName = _getMonthDate(details.date.month);
        return Stack(
          children: [
            Image(
                image: const AssetImage('assets/images/quiz.png'),
                fit: BoxFit.cover,
                width: details.bounds.width,
                height: details.bounds.height),
            Positioned(
              left: 55,
              right: 0,
              top: 20,
              bottom: 0,
              child: Text(
                'april' + ' ' + details.date.year.toString(),
                style: TextStyle(
                    fontSize: 50.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
      showDatePickerButton: true,
      view: CalendarView.month,
      firstDayOfWeek: 6,
      allowedViews: const <CalendarView>[
        CalendarView.month,
        CalendarView.schedule
      ],
      dataSource: getDataSource(),
      monthViewSettings: MonthViewSettings(
        showAgenda: true,
        agendaViewHeight: 300.h,
        navigationDirection: MonthNavigationDirection.horizontal,
        // showTrailingAndLeadingDates: false,
      ),
      appointmentTimeTextFormat: 'hh:mm a',
      showTodayButton: true,
      headerDateFormat: 'MMMM yyyy',
      headerStyle: CalendarHeaderStyle(
        backgroundColor: ColorsManager.white(context),
      ),
      cellBorderColor: ColorsManager.mainBlue(context),
      todayHighlightColor: ColorsManager.mainBlue(context),
      timeZone: 'Egypt Standard Time',
      scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: true,
          dayHeaderSettings: DayHeaderSettings(
              dayFormat: 'EEE',
              width: 55.sp,
              dayTextStyle: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
                // color: Colors.red,
              ),
              dateTextStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w300,
                // color: Colors.red,
              ))),
    );
  }
}
