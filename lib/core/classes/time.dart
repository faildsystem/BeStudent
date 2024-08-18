class FormatTimeToArabic {
  static String formatTimeToArabic(String time) {
    // Split the time and period
    final timeParts = time.split(' ');
    final period = timeParts[1].toLowerCase() == 'am' ? 'صباحًا' : 'مساءً';

    // Construct the Arabic time string
    return '${timeParts[0]} $period';
  }
}
