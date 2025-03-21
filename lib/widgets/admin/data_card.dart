import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:gpr_coffee_shop/constants/colors.dart';

/// بطاقة عرض البيانات الإحصائية
class DataCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showArrow;
  final double? height;
  final bool isLoading;

  /// بطاقة عرض الإحصائيات والبيانات المهمة
  /// [title] عنوان البطاقة
  /// [value] القيمة الرئيسية للبطاقة
  /// [subtitle] نص ثانوي (اختياري)
  /// [icon] أيقونة البطاقة
  /// [color] لون أيقونة البطاقة
  /// [backgroundColor] لون خلفية الأيقونة (اختياري)
  /// [onTap] وظيفة يتم تنفيذها عند النقر على البطاقة
  /// [showArrow] إظهار سهم للإشارة بإمكانية النقر
  /// [height] ارتفاع البطاقة (اختياري)
  /// [isLoading] حالة التحميل
  const DataCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color = AppColors.primary,
    this.backgroundColor,
    this.onTap,
    this.showArrow = true,
    this.height,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        ),
        child: Container(
          height: height,
          padding: EdgeInsets.all(16),
          child: isLoading ? _buildLoadingState() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 16,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 24,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        if (subtitle != null) SizedBox(height: 8),
        if (subtitle != null)
          Container(
            height: 12,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        // أيقونة البطاقة
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor ?? color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(width: 16),

        // محتوى البطاقة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),

        // سهم (اختياري)
        if (onTap != null && showArrow)
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      ],
    );
  }
}

/// بطاقة عرض النسبة المئوية
class PercentageDataCard extends StatelessWidget {
  final String title;
  final double value;
  final double total;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isPositiveTrend;
  final String? trendPercentage;
  final bool isLoading;

  /// بطاقة عرض النسبة المئوية
  /// [title] عنوان البطاقة
  /// [value] القيمة الحالية
  /// [total] القيمة الإجمالية
  /// [subtitle] نص ثانوي (اختياري)
  /// [icon] أيقونة البطاقة
  /// [color] لون أيقونة البطاقة
  /// [onTap] وظيفة يتم تنفيذها عند النقر على البطاقة
  /// [isPositiveTrend] هل الاتجاه إيجابي أم سلبي
  /// [trendPercentage] نسبة التغير
  /// [isLoading] حالة التحميل
  const PercentageDataCard({
    Key? key,
    required this.title,
    required this.value,
    required this.total,
    this.subtitle,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
    this.isPositiveTrend = true,
    this.trendPercentage,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (value / total) * 100 : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: isLoading
              ? _buildLoadingState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // أيقونة البطاقة
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        SizedBox(width: 12),

                        // عنوان البطاقة
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // نسبة التغير (اختياري)
                        if (trendPercentage != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isPositiveTrend
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositiveTrend
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: isPositiveTrend
                                      ? Colors.green
                                      : Colors.red,
                                  size: 12,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  trendPercentage!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isPositiveTrend
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // شريط التقدم
                    _buildProgressBar(percentage),

                    SizedBox(height: 8),

                    // القيم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          '${value.toStringAsFixed(1)} / ${total.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // وصف إضافي (اختياري)
                    if (subtitle != null) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 14,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 18,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: (percentage / 100) *
                (300 - 32), // تقدير لعرض البطاقة بدون الهوامش
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
