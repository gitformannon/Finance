import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';



class DateHelpers {
  DateHelpers._();

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('E, d-MMM HH:mm', 'uz');
    return formatter.format(date);
  }

  static String formatDateDay(DateTime date) {
    final DateFormat formatter = DateFormat('E, d-MMM', 'uz');
    return formatter.format(date);
  }
  static String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String formatReqDate(DateTime date) {
    String formattedDate = date.toIso8601String();
    if(!formattedDate.contains("Z")){
      formattedDate = "${formattedDate}Z";
    }
    return formattedDate;
  }
  static DateTime currentDate() {
    return DateTime.now();
  }

  static (DateTime, DateTime) getTodayDateDuration() {
    return (
      DateTime(
          currentDate().year, currentDate().month, currentDate().day, 0, 0, 0),
      DateTime(
          currentDate().year, currentDate().month, currentDate().day, 0, 0, 0)
    );
  }

  static (DateTime, DateTime) getYesterdayDateDuration() {
    return (
      DateTime(currentDate().year, currentDate().month, currentDate().day - 1,
          0, 0, 0),
      DateTime(currentDate().year, currentDate().month, currentDate().day - 1,
          0, 0, 0)
    );
  }

  static (DateTime, DateTime) getLastMonthDateDuration() {
    return (
      DateTime(currentDate().year, currentDate().month - 1),
      DateTime(currentDate().year, currentDate().month)
    );
  }

  static (DateTime, DateTime) getCurrentMonthDateDuration() {
    return (
      DateTime(currentDate().year, currentDate().month, 1),
      DateTime(currentDate().year, currentDate().month + 1)
    );
  }

  static (DateTime, DateTime) getCurrentWeekDuration() {
    DateTime startWeek =
        currentDate().subtract(Duration(days: currentDate().weekday - 1));
    DateTime endWeek = startWeek.add(const Duration(days: 7));
    return (
      DateTime(
        startWeek.year,
        startWeek.month,
        startWeek.day,
      ),
      DateTime(endWeek.year, endWeek.month, endWeek.day)
    );
  }

  static Future<void> showDatePickerDialog(
      {required BuildContext context,
      required Function onChange,
      DateTime? initialDate}) async {
    final DateTime? picked = await showDatePicker(
      locale: context.locale,
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != initialDate) {
      onChange(picked);
    }
  }
}
