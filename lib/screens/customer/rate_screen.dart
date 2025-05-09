import 'dart:ui';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/utils/date_formatter.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final SettingsController settingsController = Get.find<SettingsController>();
  final TextEditingController feedbackTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    feedbackTextController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        // Apply theme based on controller settings
        ThemeData activeTheme;
        Color primaryColor;
        Color secondaryColor;
        
        switch (settingsController.themeMode) {
          case 'dark':
            activeTheme = AppTheme.darkTheme;
            primaryColor = const Color(0xFFAB7F52); // Dark theme primary
            secondaryColor = const Color(0xFFE2A54C); // Dark theme accent
            break;
          case 'coffee':
            activeTheme = AppTheme.coffeeTheme;
            primaryColor = AppTheme.coffeePrimaryColor;
            secondaryColor = AppTheme.coffeeSecondaryColor;
            break;
          case 'sweet':
            activeTheme = AppTheme.sweetTheme;
            primaryColor = AppTheme.sweetPrimaryColor;
            secondaryColor = AppTheme.sweetSecondaryColor;
            break;
          default: // light
            activeTheme = AppTheme.lightTheme;
            primaryColor = AppTheme.primaryColor;
            secondaryColor = AppTheme.secondaryColor;
        }

        return Theme(
          data: activeTheme,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'التقييمات والاقتراحات',
                style: TextStyle(
                  color: activeTheme.appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: activeTheme.appBarTheme.backgroundColor,
              elevation: 0,
              iconTheme: IconThemeData(color: activeTheme.appBarTheme.foregroundColor),
            ),
            body: Stack(
              children: [
                // طبقة الخلفية - استخدام الخلفية المناسبة للثيم
                Container(
                  decoration: BoxDecoration(
                    // Use theme background color
                    color: activeTheme.scaffoldBackgroundColor,
                    image: settingsController.themeMode == 'light' || 
                           settingsController.themeMode == 'system' ? 
                      const DecorationImage(
                        image: AssetImage('assets/images/JBRbg2.png'),
                        fit: BoxFit.cover,
                        opacity: 0.5,
                      ) : null,
                  ),
                ),
                
                // طبقة التمويه - تعديل الألوان حسب الثيم
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: settingsController.themeMode == 'dark' ? 
                      Colors.black.withOpacity(0.3) : 
                      Colors.white.withOpacity(0.5),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                
                // المحتوى الرئيسي
                SafeArea(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // رسالة ترحيبية
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: 3,
                              intensity: 0.7,
                              color: activeTheme.cardTheme.color,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'نرحب بآرائكم واقتراحاتكم',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ' تقييمك واقتراحاتكم تشجعنا وتساعدنا نقدم لكم الافضل  .',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: activeTheme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // نظام التقييم بالنجوم
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: 3,
                              intensity: 0.7,
                              color: activeTheme.cardTheme.color,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'تقييمك للخدمة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildRatingStars(secondaryColor),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // حقل إدخال الاقتراح
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: 3,
                              intensity: 0.7,
                              color: activeTheme.cardTheme.color,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'أضف اقتراحك أو ملاحظتك',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Neumorphic(
                                  style: NeumorphicStyle(
                                    depth: -3,
                                    intensity: 0.7,
                                    color: settingsController.themeMode == 'dark' ? 
                                      Colors.grey.shade800 : Colors.white,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(8),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: TextField(
                                    controller: feedbackTextController,
                                    decoration: InputDecoration(
                                      hintText: 'اكتب رأيك هنا...',
                                      hintStyle: TextStyle(
                                        color: settingsController.themeMode == 'dark' ? 
                                          Colors.grey.shade400 : Colors.grey.shade600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: activeTheme.textTheme.bodyMedium?.color,
                                    ),
                                    maxLines: 3,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: NeumorphicButton(
                                    style: NeumorphicStyle(
                                      depth: 4,
                                      intensity: 0.8,
                                      color: primaryColor,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    onPressed: () {
                                      if (feedbackTextController.text
                                          .trim()
                                          .isNotEmpty) {
                                        feedbackController.addFeedback(
                                          feedbackTextController.text.trim(),
                                        );
                                        feedbackTextController.clear();

                                        // عرض رسالة نجاح
                                        Get.snackbar(
                                          'تم بنجاح',
                                          'شكراً لك! تم إرسال تقييمك بنجاح',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppTheme.successColor.withOpacity(0.7),
                                          colorText: Colors.white,
                                          margin: const EdgeInsets.all(8),
                                          borderRadius: 8,
                                        );
                                      } else {
                                        // تنبيه إذا كان النص فارغاً
                                        Get.snackbar(
                                          'تنبيه',
                                          'الرجاء كتابة اقتراحك قبل الإرسال',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppTheme.warningColor.withOpacity(0.7),
                                          colorText: Colors.white,
                                          margin: const EdgeInsets.all(8),
                                          borderRadius: 8,
                                        );
                                      }
                                    },
                                    child: Text(
                                      'إرسال التقييم',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // عرض التقييمات السابقة
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: 3,
                              intensity: 0.7,
                              color: activeTheme.cardTheme.color,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'آراء المستخدمين السابقة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GetBuilder<FeedbackController>(
                                  builder: (controller) {
                                    return controller.feedbackItems.isEmpty
                                        ? Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Text(
                                                'لا توجد تقييمات سابقة. كن أول من يشارك رأيه!',
                                                style: TextStyle(
                                                  color: settingsController.themeMode == 'dark' ? 
                                                    Colors.grey.shade400 : Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: List.generate(
                                              controller.feedbackItems.length,
                                              (index) => _buildFeedbackItem(
                                                controller.feedbackItems[index],
                                                primaryColor,
                                                secondaryColor,
                                                activeTheme,
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // نظام التقييم بالنجوم
  Widget _buildRatingStars(Color starColor) {
    return GetBuilder<FeedbackController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                controller.setRating(index + 1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  controller.currentRating.value > index
                      ? Icons.star
                      : Icons.star_border,
                  color: starColor,
                  size: 36,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // عنصر اقتراح واحد
  Widget _buildFeedbackItem(FeedbackItem item, Color primaryColor, Color secondaryColor, ThemeData theme) {
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أيقونة المستخدم
          CircleAvatar(
            radius: 18,
            backgroundColor: primaryColor.withAlpha(204),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          // بالون الدردشة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // إضافة زر حذف التعليق
                          GestureDetector(
                            onTap: () => _showDeleteConfirmation(item, theme),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // عرض التقييم بالنجوم
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < item.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: secondaryColor,
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                  child: Text(
                    DateFormatter.formatDateTime(item.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // إضافة دالة جديدة لعرض مربع حوار تأكيد الحذف
  void _showDeleteConfirmation(FeedbackItem item, ThemeData theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف التعليق', style: TextStyle(color: theme.textTheme.titleLarge?.color)),
          backgroundColor: theme.dialogTheme.backgroundColor,
          content: Text(
            'هل أنت متأكد من حذف هذا التعليق؟',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء', style: TextStyle(color: theme.textTheme.labelLarge?.color)),
            ),
            TextButton(
              onPressed: () {
                // حذف التعليق
                feedbackController.deleteFeedback(item.id);
                Navigator.of(context).pop();

                // عرض رسالة تأكيد الحذف
                Get.snackbar(
                  'تم الحذف',
                  'تم حذف التعليق بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppTheme.successColor.withOpacity(0.7),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(8),
                  borderRadius: 8,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
