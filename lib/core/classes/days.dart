class Days {
  static final Map<String, String> dayToArabic = {
    'SU': 'الأحد',
    'MO': 'الاثنين',
    'TU': 'الثلاثاء',
    'WE': 'الأربعاء',
    'TH': 'الخميس',
    'FR': 'الجمعة',
    'SA': 'السبت',
  };
  // Days and their corresponding abbreviations
  static final List<Map<String, String>> days = [
    {'name': 'السبت', 'abbr': 'SA'},
    {'name': 'الأحد', 'abbr': 'SU'},
    {'name': 'الاثنين', 'abbr': 'MO'},
    {'name': 'الثلاثاء', 'abbr': 'TU'},
    {'name': 'الأربعاء', 'abbr': 'WE'},
    {'name': 'الخميس', 'abbr': 'TH'},
    {'name': 'الجمعة', 'abbr': 'FR'},
  ];

  static String translateDayToArabic(String abbreviation) {
    return dayToArabic[abbreviation] ??
        'غير معروف'; // Return 'غير معروف' (Unknown) if not found
  }
}
