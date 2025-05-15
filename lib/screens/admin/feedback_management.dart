import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';

class FeedbackManagement extends StatelessWidget {
  final FeedbackController feedbackController;

  FeedbackManagement({super.key})
      : feedbackController = Get.find<FeedbackController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة التعليقات والمقترحات'),
        // استخدام ثيم التطبيق بدلاً من تعيين الألوان يدويًا
        actions: [
          // زر حذف جميع التعليقات
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'حذف جميع التعليقات',
            onPressed: () => _showDeleteAllDialog(context),
          ),
        ],
      ),
      body: Obx(
        () => feedbackController.feedbackItems.isEmpty
            ? const Center(
                child: Text('لا توجد تعليقات أو مقترحات',
                    style: TextStyle(fontSize: 16)))
            : ListView.builder(
                itemCount: feedbackController.feedbackItems.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final feedback = feedbackController.feedbackItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: feedback.featured
                            ? Colors.amber.shade300
                            : Colors.transparent,
                        width: feedback.featured ? 2 : 0,
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(feedback.message),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text('${feedback.rating}/5'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.access_time,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(feedback.timestamp),
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر تمييز/إلغاء تمييز التعليق
                              IconButton(
                                icon: Icon(
                                  feedback.featured
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: feedback.featured
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                                tooltip: feedback.featured
                                    ? 'إلغاء تمييز التعليق'
                                    : 'تمييز التعليق للعرض في الشاشة الرئيسية',
                                onPressed: () => _toggleFeatured(feedback),
                              ),
                              // زر حذف التعليق
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'حذف التعليق',
                                onPressed: () =>
                                    _showDeleteDialog(context, feedback),
                              ),
                            ],
                          ),
                        ),
                        if (feedback.featured)
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 16.0, right: 16.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green.shade600, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'معروض في الشاشة الرئيسية',
                                  style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // تنسيق التاريخ بشكل أفضل
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$year/$month/$day $hour:$minute';
  }

  void _showDeleteDialog(BuildContext context, FeedbackItem feedback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف التعليق'),
          content: const Text(
              'هل أنت متأكد من حذف هذا التعليق؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
              onPressed: () {
                feedbackController.deleteFeedback(feedback.id);
                Navigator.of(context).pop();
                Get.snackbar(
                  'تم الحذف',
                  'تم حذف التعليق بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // إضافة طريقة لعرض مربع حوار حذف جميع التعليقات
  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف جميع التعليقات'),
          content: const Text(
              'هل أنت متأكد من حذف جميع التعليقات والمقترحات؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  const Text('حذف الكل', style: TextStyle(color: Colors.red)),
              onPressed: () {
                feedbackController.deleteAllFeedback();
                Navigator.of(context).pop();
                Get.snackbar(
                  'تم الحذف',
                  'تم حذف جميع التعليقات بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // إضافة طريقة لتمييز/إلغاء تمييز التعليق
  void _toggleFeatured(FeedbackItem feedback) {
    feedbackController.toggleFeatured(feedback.id);

    Get.snackbar(
      feedback.featured ? 'إلغاء التمييز' : 'تم التمييز',
      feedback.featured
          ? 'تم إلغاء تمييز التعليق من الشاشة الرئيسية'
          : 'تم تمييز التعليق وسيظهر في الشاشة الرئيسية',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: feedback.featured ? Colors.grey : Colors.amber,
      colorText: Colors.white,
    );
  }
}
