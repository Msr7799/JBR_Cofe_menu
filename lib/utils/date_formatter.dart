class DateFormatter {
  // تنسيق التاريخ بالشكل "yyyy/MM/dd - hh:mm AM/PM"
  static String formatDateTime(DateTime dateTime) {
    // تنسيق اليوم والشهر والسنة
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    
    // تنسيق الساعة والدقيقة
    int hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    
    // تحويل إلى نظام 12 ساعة
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour; // تحويل الساعة 0 إلى 12
    
    return '$year/$month/$day - $hour:$minute $period';
  }
}