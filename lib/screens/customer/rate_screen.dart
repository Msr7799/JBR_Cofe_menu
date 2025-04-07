import 'dart:ui';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';
import 'package:gpr_coffee_shop/utils/date_formatter.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'التقييمات والاقتراحات',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
      ),
      body: Stack(
        children: [
          // طبقة الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/JBRbg2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // طبقة التمويه
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.white.withOpacity(0.7),
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
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text(
                            'نرحب بآرائكم واقتراحاتكم',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            ' تقييمك واقتراحاتكم تشجعنا وتساعدنا نقدم لكم الافضل  .',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // نظام التقييم بالقلوب
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 3,
                        intensity: 0.7,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'تقييمك للخدمة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildRatingHearts(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // حقل إدخال الاقتراح
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 3,
                        intensity: 0.7,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'أضف اقتراحك أو ملاحظتك',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: -3,
                              intensity: 0.7,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: feedbackTextController,
                              decoration: const InputDecoration(
                                hintText: 'اكتب رأيك هنا...',
                                border: InputBorder.none,
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
                                    backgroundColor:
                                        Colors.green.withOpacity(0.7),
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
                                    backgroundColor:
                                        Colors.orange.withOpacity(0.7),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(8),
                                    borderRadius: 8,
                                  );
                                }
                              },
                              child: const Text(
                                'إرسال التقييم',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'آراء المستخدمين السابقة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                                            color: Colors.grey.shade600,
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

  // نظام التقييم بالقلوب
  Widget _buildRatingHearts() {
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
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.black,
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
  Widget _buildFeedbackItem(FeedbackItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أيقونة المستخدم
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primaryColor.withAlpha(204),
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
                    color: Colors.grey.shade200,
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
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // إضافة زر حذف التعليق
                          GestureDetector(
                            onTap: () => _showDeleteConfirmation(item),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // عرض التقييم بالقلوب
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < item.rating
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.black,
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
                      color: Colors.grey.shade600,
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
  void _showDeleteConfirmation(FeedbackItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف التعليق'),
          content: const Text('هل أنت متأكد من حذف هذا التعليق؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
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
                  backgroundColor: Colors.green.withOpacity(0.7),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(8),
                  borderRadius: 8,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
