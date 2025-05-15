import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';

class DateTimeWidget extends StatelessWidget {
  final DateTime currentDateTime;
  
  const DateTimeWidget({
    Key? key,
    required this.currentDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white; // Default text color
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Format date and time based on screen size
    final dateFormat = DateFormat(isVerySmallScreen ? 'MM/dd' : 'yyyy/MM/dd');
    final timeFormat = DateFormat(isVerySmallScreen || isLandscape ? 'HH:mm' : 'HH:mm:ss');
    final dayName = _getArabicDayName(currentDateTime.weekday);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isVerySmallScreen ? 0 : 2,
        horizontal: isVerySmallScreen ? 2 : 3
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withAlpha(200),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryColor.withAlpha(120), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      // Adjust size constraints based on screen size
      constraints: BoxConstraints(
        maxWidth: isVerySmallScreen
            ? 100
            : isSmallScreen
                ? 140
                : 160,
        maxHeight: isVerySmallScreen
            ? 32
            : isSmallScreen
                ? 36
                : 40,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row with flag and day name
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bahrain flag
                Container(
                  height: isVerySmallScreen ? 12 : 14,
                  width: isVerySmallScreen ? 16 : 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/bahrain_flag.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  dayName,
                  style: TextStyle(
                    color: Colors.amber[200],
                    fontSize: isVerySmallScreen ? 8 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Display time
            Text(
              timeFormat.format(currentDateTime),
              style: TextStyle(
                fontSize: isVerySmallScreen ? 10 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Display date
            Text(
              dateFormat.format(currentDateTime),
              style: TextStyle(
                fontSize: isVerySmallScreen ? 8 : 9,
                fontWeight: FontWeight.w400,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get Arabic day name
  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'الإثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      default:
        return '';
    }
  }
}
