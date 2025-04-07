import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackItem {
  final String id;
  final String message;
  final int rating; // 0-5 للتقييم بالقلوب
  final DateTime timestamp;
  bool featured; // إضافة خاصية لتمييز التعليقات المميزة

  FeedbackItem({
    String? id,
    required this.message,
    required this.rating,
    required this.timestamp,
    this.featured = false, // القيمة الافتراضية هي عدم تمييز التعليق
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  @override
  String toString() => 'FeedbackItem{id: $id, message: $message, rating: $rating, timestamp: $timestamp, featured: $featured}';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
      'featured': featured, // حفظ حالة التمييز
    };
  }

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'],
      message: json['message'],
      rating: json['rating'],
      timestamp: DateTime.parse(json['timestamp']),
      featured: json['featured'] ??
          false, // استرداد حالة التمييز مع التعامل مع البيانات القديمة
    );
  }
}

class FeedbackController extends GetxController {
  final RxList<FeedbackItem> feedbackItems = <FeedbackItem>[].obs;
  final RxInt currentRating = 0.obs;
  final RxInt featuredCount = 0.obs; // عدد التعليقات المميزة

  @override
  void onInit() {
    super.onInit();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final feedbackList = prefs.getStringList('feedback_items') ?? [];

    feedbackItems.clear();
    featuredCount.value = 0;

    for (var jsonStr in feedbackList) {
      try {
        final json = Map<String, dynamic>.from(jsonDecode(jsonStr) as Map);
        final item = FeedbackItem.fromJson(json);
        feedbackItems.add(item);

        // زيادة عداد التعليقات المميزة
        if (item.featured) {
          featuredCount.value++;
        }
      } catch (e) {
        print('Error loading feedback: $e');
      }
    }

    // ترتيب الاقتراحات حسب التاريخ (الأحدث أولاً)
    feedbackItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    update();
  }

  Future<void> saveFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final feedbackList =
        feedbackItems.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList('feedback_items', feedbackList);
  }

  void setRating(int rating) {
    currentRating.value = rating;
    update();
  }

  Future<void> addFeedback(String message) async {
    if (message.trim().isEmpty) return;

    final newFeedback = FeedbackItem(
      message: message,
      rating: currentRating.value,
      timestamp: DateTime.now(),
    );

    feedbackItems.insert(0, newFeedback);
    currentRating.value = 0; // إعادة تعيين التقييم

    await saveFeedback();
    update();
  }

  Future<void> deleteFeedback(String id) async {
    // تحقق مما إذا كان التعليق مميزاً قبل حذفه
    final item = feedbackItems.firstWhere((item) => item.id == id,
        orElse: () =>
            FeedbackItem(message: '', rating: 0, timestamp: DateTime.now()));
    if (item.featured) {
      featuredCount.value--;
    }

    feedbackItems.removeWhere((item) => item.id == id);
    await saveFeedback();
    update();
  }

  // إضافة طريقة لحذف جميع التعليقات
  Future<void> deleteAllFeedback() async {
    feedbackItems.clear();
    featuredCount.value = 0;
    await saveFeedback();
    update();
  }

  // إضافة طريقة لتمييز أو إلغاء تمييز تعليق
  Future<void> toggleFeatured(String id) async {
    final index = feedbackItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      // إنشاء نسخة جديدة من العنصر لأن العناصر في RxList غير قابلة للتعديل المباشر
      final item = feedbackItems[index];
      final newItem = FeedbackItem(
        id: item.id,
        message: item.message,
        rating: item.rating,
        timestamp: item.timestamp,
        featured: !item.featured, // تبديل حالة التمييز
      );

      // تحديث العداد
      if (newItem.featured) {
        // تحقق من أن العدد لا يتجاوز 2
        if (featuredCount.value >= 2) {
          // إلغاء تمييز أقدم تعليق مميز
          final oldestFeatured = feedbackItems
              .where((item) => item.featured)
              .reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b);

          final oldIndex =
              feedbackItems.indexWhere((item) => item.id == oldestFeatured.id);
          if (oldIndex != -1) {
            final oldItem = feedbackItems[oldIndex];
            feedbackItems[oldIndex] = FeedbackItem(
              id: oldItem.id,
              message: oldItem.message,
              rating: oldItem.rating,
              timestamp: oldItem.timestamp,
              featured: false,
            );
          }
        } else {
          featuredCount.value++;
        }
      } else {
        featuredCount.value--;
      }

      // تحديث العنصر في القائمة
      feedbackItems[index] = newItem;

      await saveFeedback();
      update();
    }
  }

  // الحصول على التعليقات المميزة
  List<FeedbackItem> get featuredFeedbacks {
    return feedbackItems.where((item) => item.featured).toList();
  }
}
