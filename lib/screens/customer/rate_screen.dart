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
  State<RateScreen> createState() => _RateScreenState();
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
    // استخدام ثيم النظام مباشرة
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    final Color primaryColor = theme.colorScheme.primary;
    final Color secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التقييمات والاقتراحات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // طبقة الخلفية
          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              image: isDarkTheme ? null : const DecorationImage(
                image: AssetImage('assets/images/JBRbg2.png'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),
          
          // طبقة التمويه
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: isDarkTheme ? 
                Colors.black.withAlpha(77) : 
                Colors.white.withAlpha(128),
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
                        color: theme.cardTheme.color,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'نرحب بآرائكم واقتراحاتكم',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ' تقييمك واقتراحاتك تشجعنا وتساعدنا نقدم لكم الافضل  .',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
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
                        color: theme.cardTheme.color,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'تقييمك للخدمة',
                            style: theme.textTheme.titleMedium?.copyWith(
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
                        color: theme.cardTheme.color,
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: -3,
                              intensity: 0.7,
                              color: isDarkTheme ? 
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
                                  color: isDarkTheme ? 
                                    Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                                border: InputBorder.none,
                              ),
                              style: theme.textTheme.bodyMedium,
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
                                    backgroundColor: AppTheme.successColor.withAlpha(179),
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
                                    backgroundColor: AppTheme.warningColor.withAlpha(179),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(8),
                                    borderRadius: 8,
                                  );
                                }
                              },
                              child: Text(
                                'إرسال التقييم',
                                style: theme.textTheme.labelLarge?.copyWith(
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
                        color: theme.cardTheme.color,
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
                            style: theme.textTheme.titleMedium?.copyWith(
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
                                            color: isDarkTheme ? 
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
                                          theme,
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
            child: const Icon(
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
                              style: theme.textTheme.bodyMedium?.copyWith(
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
                    style: theme.textTheme.bodySmall?.copyWith(
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
          title: Text('حذف التعليق', style: theme.textTheme.titleLarge),
          content: Text(
            'هل أنت متأكد من حذف هذا التعليق؟',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
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
                  backgroundColor: AppTheme.successColor.withAlpha(179),
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