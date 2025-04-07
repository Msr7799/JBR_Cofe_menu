import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

class OrderController extends GetxController {
  final LocalStorageService _storage;
  final orders = <Order>[].obs;
  final isLoading = false.obs;

  // أضف هذه المتغيرات الجديدة:
  final pendingItems = <OrderItem>[].obs; // عناصر الطلبات المعلقة (للإشعارات)

  OrderController(this._storage);

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final loadedOrders = await _storage.getOrders();
      orders.value = loadedOrders;
    } catch (e) {
      LoggerUtil.logger.e('Error loading orders: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل الطلبات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveOrder(Order order) async {
    try {
      isLoading.value = true;
      await _storage.saveOrder(order);
      final index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        orders[index] = order;
      } else {
        orders.add(order);
      }
    } catch (e) {
      LoggerUtil.logger.e('Error saving order: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ الطلب',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Order> getOrdersByDateRange(DateTime startDate, DateTime endDate) {
    return orders.where((order) {
      return order.createdAt.isAfter(startDate) &&
          order.createdAt.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  List<Order> getPendingOrders() {
    return orders
        .where((order) => order.status == OrderStatus.pending)
        .toList();
  }

  List<Order> getProcessingOrders() {
    return orders
        .where((order) => order.status == OrderStatus.processing)
        .toList();
  }

  List<Order> getCompletedOrders() {
    return orders
        .where((order) => order.status == OrderStatus.completed)
        .toList();
  }

  List<Order> getCancelledOrders() {
    return orders
        .where((order) => order.status == OrderStatus.cancelled)
        .toList();
  }

  List<Order> getRecentOrders({int limit = 5}) {
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedOrders.take(limit).toList();
  }

  int getTodayOrdersCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return orders.where((order) => order.createdAt.isAfter(today)).length;
  }

  int getPendingOrdersCount() {
    return orders.where((order) => order.status == OrderStatus.pending).length;
  }

  double getTodayRevenue() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return orders
        .where((order) => order.createdAt.isAfter(today))
        .fold(0, (sum, order) => sum + order.total);
  }

  double getTotalRevenue() {
    return orders.fold(0, (sum, order) => sum + order.total);
  }

  Order? findById(String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // إضافة عنصر طلب جديد إلى قائمة الانتظار (إشعار)
  void addPendingOrder(OrderItem item) {
    pendingItems.add(item);
    update();
  }

  // إكمال طلب معلق (إزالة الإشعار وإضافته كطلب مكتمل)
  Future<void> completePendingItem(OrderItem item) async {
    try {
      isLoading.value = true;

      // إزالة العنصر من قائمة الانتظار
      pendingItems.remove(item);

      // إنشاء طلب جديد مكتمل
      final order = Order(
        id: const Uuid().v4(),
        items: [item],
        status: OrderStatus.completed,
        createdAt: DateTime.now(),
        customerId: 'walk-in', // يمكن تعديله حسب الحاجة
        paymentType: PaymentType.cash, // يمكن تعديله حسب الحاجة
      );

      // إضافة الطلب الجديد إلى القائمة المحلية أولاً قبل الحفظ
      orders.add(order);

      // حفظ الطلب
      await _storage.saveOrder(order);

      // طباعة معلومات تشخيصية للتحقق
      LoggerUtil.logger.e('تم إكمال الطلب: ${item.name} × ${item.quantity}');
      LoggerUtil.logger.e('إجمالي الطلبات الآن: ${orders.length}');
      LoggerUtil.logger.e('عدد الطلبات اليوم: ${getTodayOrdersCount()}');
      LoggerUtil.logger.e('إجمالي المبيعات اليوم: ${getTodayRevenue()}');

      // تحديث الواجهة
      update();
    } catch (e) {
      LoggerUtil.logger.e('Error completing pending item: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إكمال الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // حذف طلب معلق (تجاهل الإشعار)
  void removePendingItem(OrderItem item) {
    pendingItems.remove(item);
    update();
  }

  // الحصول على إحصاءات تفصيلية للمبيعات اليومية
  Map<String, dynamic> getDailyStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // تصفية الطلبات المكتملة اليوم
    final todayOrders = orders
        .where((order) =>
            order.status == OrderStatus.completed &&
            order.createdAt.isAfter(today))
        .toList();

    // إجمالي المبيعات
    final totalSales = todayOrders.fold(0.0, (sum, order) => sum + order.total);

    // إجمالي الأرباح
    final totalProfit =
        todayOrders.fold(0.0, (sum, order) => sum + order.profit);

    // عدد الطلبات
    final orderCount = todayOrders.length;

    // المنتجات الأكثر مبيعًا
    final productSales = <String, Map<String, dynamic>>{};

    for (var order in todayOrders) {
      for (var item in order.items) {
        if (!productSales.containsKey(item.productId)) {
          productSales[item.productId] = {
            'name': item.name,
            'quantity': 0,
            'revenue': 0.0,
            'profit': 0.0,
          };
        }

        productSales[item.productId]!['quantity'] += item.quantity;
        productSales[item.productId]!['revenue'] +=
            (item.price * item.quantity);
        {
          productSales[item.productId]!['profit'] +=
              ((item.price - item.cost) * item.quantity);
        }
      }
    }

    // تحويل إلى قائمة وترتيب حسب الكمية
    final topProducts = productSales.entries
        .map((e) => {
              'productId': e.key,
              'name': e.value['name'],
              'quantity': e.value['quantity'],
              'revenue': e.value['revenue'],
              'profit': e.value['profit'],
            })
        .toList()
      ..sort((a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int));

    return {
      'totalSales': totalSales,
      'totalProfit': totalProfit,
      'orderCount': orderCount,
      'avgOrderValue': orderCount > 0 ? totalSales / orderCount : 0,
      'topProducts': topProducts.take(5).toList(),
    };
  }

  Future<void> resetDailyStats() async {
    try {
      isLoading.value = true;

      // تحديد الطلبات المكتملة اليوم
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // تحديد طلبات اليوم المكتملة
      final todayOrders = orders
          .where((order) =>
              order.status == OrderStatus.completed &&
              order.createdAt.isAfter(today))
          .toList();

      if (todayOrders.isNotEmpty) {
        // حذف طلبات اليوم
        for (var order in todayOrders) {
          await _storage.deleteOrder(order.id);
        }

        // تحديث القائمة المحلية
        orders.removeWhere((order) =>
            order.status == OrderStatus.completed &&
            order.createdAt.isAfter(today));
      }

      // تنظيف الطلبات المعلقة أيضاً
      pendingItems.clear();

      update();
    } catch (e) {
      LoggerUtil.logger.e('Error resetting stats: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تصفير الإحصائيات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
