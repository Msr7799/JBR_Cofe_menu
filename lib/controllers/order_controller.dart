import 'package:flutter/material.dart';
import 'package:get/get.dart';
/* import 'package:gpr_coffee_shop/constants/theme.dart'; */
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
/* import 'package:gpr_coffee_shop/controllers/auth_controller.dart'; */
import 'package:gpr_coffee_shop/services/notification_service.dart';

class OrderController extends GetxController {
  final LocalStorageService _storage;
  final orders = <Order>[].obs;
  final isLoading = false.obs;

  // أضف هذه المتغيرات الجديدة:
  final pendingItems = <OrderItem>[].obs; // عناصر الطلبات المعلقة (للإشعارات)
// يمكن جعله قابل للتعديل في الإعدادات

  OrderController(this._storage);

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// تحميل الطلبات بدون إظهار رسالة (لتجنب مشاكل snackbar)
  Future<void> loadOrdersQuietly() async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _storage.getOrders();
      orders.value = fetchedOrders;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      LoggerUtil.logger.e('Error loading orders: $e');
    }
  }

  /// تحميل الطلبات مع إظهار رسائل للمستخدم
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _storage.getOrders();
      orders.value = fetchedOrders;
      // استخدم Future.delayed لتجنب مشكلة Snackbar أثناء البناء
      await Future.delayed(Duration.zero, () {
        if (Get.context != null && Get.isOverlaysOpen) {
          Get.snackbar(
            'تم بنجاح',
            'تم تحميل الطلبات بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      LoggerUtil.logger.e('Error loading orders: $e');
      // استخدم Future.delayed لتجنب مشكلة Snackbar أثناء البناء
      await Future.delayed(Duration.zero, () {
        if (Get.context != null && Get.isOverlaysOpen) {
          Get.snackbar(
            'خطأ',
            'حدث خطأ أثناء تحميل الطلبات: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      });
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

  // الاحتفاظ بالنسخة الأولى فقط من getOrdersByDateRange - حذف النسخة المكررة في السطر 1047
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

  // استبدل دالة completePendingItem بهذه النسخة المعدلة نهائياً:
  Future<void> completePendingItem(OrderItem item) async {
    try {
      // Create a new order with the pending item
      final newOrder = Order(
        id: const Uuid().v4(),
        items: [item], // Add the item directly here
        status: OrderStatus.completed,
        createdAt: DateTime.now(),
        customerId: 'walk-in',
        paymentType: PaymentType.cash,
      );

      // Save the new order
      await _storage.saveOrder(newOrder);
      
      // Add to the local list and refresh UI
      orders.add(newOrder);
      orders.refresh();

      // Remove from pending items
      pendingItems.removeWhere((pendingItem) => 
          pendingItem.productId == item.productId &&
          pendingItem.quantity == item.quantity);
      pendingItems.refresh();

      LoggerUtil.logger.i('تم إكمال الطلب: ${item.name} × ${item.quantity}');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إكمال الطلب المعلق: $e');
      rethrow;
    }
  }

  // حذف طلب معلق بشكل سريع (تجاهل الإشعار)
  void quickRemovePendingItem(OrderItem item) {
    pendingItems.remove(item);
    pendingItems.refresh(); // استخدام refresh بدلاً من update
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

      // تحديد الطلبات المكتملة والملغية اليوم
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // تحديد طلبات اليوم المكتملة والملغية
      final todayOrders = orders
          .where((order) =>
              (order.status == OrderStatus.completed ||
                  order.status == OrderStatus.cancelled) &&
              order.createdAt.isAfter(today))
          .toList();

      if (todayOrders.isNotEmpty) {
        // حذف طلبات اليوم
        for (var order in todayOrders) {
          await _storage.deleteOrder(order.id);
        }

        // تحديث القائمة المحلية
        orders.removeWhere((order) =>
            (order.status == OrderStatus.completed ||
                order.status == OrderStatus.cancelled) &&
            order.createdAt.isAfter(today));

        // استخدام refresh بدلاً من update لتجنب مشاكل setState
        orders.refresh();
      }

      // تنظيف الطلبات المعلقة أيضاً
      pendingItems.clear();
      pendingItems.refresh();

      // Log the action
      LoggerUtil.logger.i('Daily statistics reset successfully');
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

  // الاحتفاظ بنسخة واحدة فقط من showContinueToIterateDialog - حذف النسخة المكررة في السطر 799
  Future<bool> showContinueToIterateDialog(
      BuildContext context, OrderItem item) async {
    // التحقق من تفضيلات المستخدم - إذا كان الخيار معطل، نعود true مباشرة
    final showDialog = ViewOptionsHelper.getContinueToIterate();
    if (!showDialog) {
      return true; // استمر في التسوق افتراضيًا إذا كان الخيار معطل
    }

    // عرض نافذة تأكيد
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('تمت الإضافة إلى السلة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تمت إضافة ${item.name} إلى سلة المشتريات.'),
            const SizedBox(height: 10),
            const Text('هل ترغب في الاستمرار في التسوق؟')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('الانتقال إلى السلة'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('استمرار التسوق'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    // إذا كان المستخدم ضغط خارج النافذة، نفترض أنه يريد الاستمرار في التسوق
    return result ?? true;
  }

  // تعديل دالة processOrder لمنع الإكمال التلقائي للطلبات
  Future<bool> processOrder(Product product, int quantity,
      {String? notes}) async {
    try {
      LoggerUtil.logger
          .i('بدء معالجة الطلب: ${product.name}, الكمية: $quantity');

      // Create order item with complete information
      final orderItem = OrderItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        cost: product.cost,
        quantity: quantity,
        notes: notes ?? '',
      );

      LoggerUtil.logger.i(
          'تم إنشاء عنصر الطلب: ${orderItem.name}, السعر: ${orderItem.price}, الكمية: ${orderItem.quantity}');

      // Create a new order directly with the item
      // Changed status from OrderStatus.pending to OrderStatus.processing
      final order = Order(
        id: const Uuid().v4(),
        items: [orderItem], // Add item directly here
        status: OrderStatus.processing, // Changed from pending to processing
        createdAt: DateTime.now(),
        customerId: 'walk-in',
        paymentType: PaymentType.cash,
      );

      LoggerUtil.logger.i(
          'تم إنشاء الطلب الجديد، معرف الطلب: ${order.id}, عدد العناصر: ${order.items.length}');

      // Save the order to storage
      await _storage.saveOrder(order);
      
      // Add to local list and refresh the UI
      orders.add(order);
      orders.refresh();

      // Also add to pending items for UI display
      // We still keep this for notification purposes
      addPendingOrder(orderItem);

      // Show notification to user if service is available
      try {
        final notificationService = Get.find<NotificationService>();
        notificationService.showOrderNotification(orderItem);
      } catch (e) {
        LoggerUtil.logger.e('خطأ في عرض الإشعار: $e');
      }

      // Show success message
      _showSuccessMessage(
        'تم الطلب',
        'تم طلب ${product.name} (${quantity}x) وهو قيد التحضير',
      );

      return true;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إضافة المنتج للطلب: $e');
      _showErrorMessage('خطأ', 'حدث خطأ أثناء إضافة المنتج للطلب');
      return false;
    }
  }

  // عرض رسالة نجاح بطريقة آمنة
  void _showSuccessMessage(String title, String message) {
    // تأخير إظهار الرسالة لتجنب أخطاء البناء
    Future.microtask(() {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withAlpha(179),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }

  // عرض رسالة خطأ بطريقة آمنة
  void _showErrorMessage(String title, String message) {
    // تأخير إظهار الرسالة لتجنب أخطاء البناء
    Future.microtask(() {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(179),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }

  // الاحتفاظ فقط بالدالة المحسنة (السطور 428-471)
  // دالة تحديث معززة لحالة الطلب مع تسجيل التغييرات
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      isLoading.value = true;

      // Find the order in the local list
      final orderIndex = orders.indexWhere((order) => order.id == orderId);
      if (orderIndex == -1) {
        LoggerUtil.logger.w('لم يتم العثور على الطلب بمعرف: $orderId');
        return false;
      }

      final order = orders[orderIndex];
      final updatedOrder = order.copyWith(status: newStatus);

      // Save to database and update local list
      await _storage.saveOrder(updatedOrder);
      orders[orderIndex] = updatedOrder;
      orders.refresh();

      LoggerUtil.logger.i('تم تغيير حالة الطلب ${orderId.substring(0, 8)} من ${order.status} إلى $newStatus');
      return true;
    } catch (e) {
      LoggerUtil.logger.e('Error updating order status: $e');
      return false; // Always return a boolean, even on error
    } finally {
      isLoading.value = false;
    }
  }

  // دالة لإكمال الطلب (تحويله من قيد التحضير إلى مكتمل)
  Future<bool> completeOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.completed);
  }

  // دالة للبدء في تحضير الطلب (تحويله من معلق إلى قيد التحضير)
  Future<bool> startProcessingOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.processing);
  }

  // دالة لإلغاء الطلب (تحويله إلى ملغي)
  Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  // دالة محسنة للحصول على إحصائيات الأرباح
  Map<String, dynamic> getProfitStats(
      {DateTime? startDate, DateTime? endDate}) {
    // استخدام التواريخ المعطاة أو اليوم الحالي افتراضياً
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = startDate ?? today;
    final end = endDate ?? DateTime(now.year, now.month, now.day, 23, 59, 59);

    // تصفية الطلبات المكتملة في النطاق المحدد
    final filteredOrders = orders
        .where((order) =>
            order.status == OrderStatus.completed &&
            order.createdAt.isAfter(start) &&
            order.createdAt.isBefore(end.add(const Duration(days: 1))))
        .toList();

    // حساب الإحصاءات
    final totalSales =
        filteredOrders.fold(0.0, (sum, order) => sum + order.total);
    final totalProfit =
        filteredOrders.fold(0.0, (sum, order) => sum + order.profit);
    final orderCount = filteredOrders.length;

    return {
      'totalSales': totalSales,
      'totalProfit': totalProfit,
      'orderCount': orderCount,
      'averageProfit': orderCount > 0 ? totalProfit / orderCount : 0.0,
      'profitMargin': totalSales > 0 ? (totalProfit / totalSales) * 100 : 0.0,
    };
  }

  // الاحتفاظ بنسخة واحدة فقط من clearCompletedOrders - حذف النسخة المكررة في السطر 583
  Future<bool> clearCompletedOrders() async {
    try {
      // الحصول على الطلبات المكتملة
      final completedOrders = getCompletedOrders();
      if (completedOrders.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا توجد طلبات مكتملة للحذف',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.withAlpha(179),
          colorText: Colors.white,
        );
        return false;
      }

      int count = 0;
      // حذف الطلبات من قاعدة البيانات
      for (var order in completedOrders) {
        await _storage.deleteOrder(order.id);
        orders.remove(order);
        count++;
      }

      // تحديث القائمة
      orders.refresh();

      // سجل العملية
      LoggerUtil.logger.i('تم حذف $count طلب مكتمل');

      // عرض رسالة نجاح
      Get.snackbar(
        'تم الحذف',
        'تم حذف $count طلب مكتمل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withAlpha(179),
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الطلبات المكتملة: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف الطلبات المكتملة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(179),
        colorText: Colors.white,
      );

      return false;
    }
  }

  // الاحتفاظ بنسخة واحدة فقط من findProductById - حذف النسخة المكررة في السطر 874
  Product? findProductById(String productId) {
    final productController = Get.find<ProductController>();
    try {
      return productController.allProducts.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  // نظام معالجة الطلبات المتكامل - إعادة تسمية هذه الدالة لتجنب التكرار مع processOrder
  Future<bool> processOrderIntegrated(Product product, int quantity) async {
    try {
      // تجهيز عنصر الطلب
      final orderItem = OrderItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        cost: product.cost,
        quantity: quantity,
        notes: '',
      );

      // Create a new order with processing status
      final order = Order(
        id: const Uuid().v4(),
        items: [orderItem],
        status: OrderStatus.processing, // Changed from pending to processing
        createdAt: DateTime.now(),
        customerId: 'walk-in',
        paymentType: PaymentType.cash,
      );

      // Save the order
      await _storage.saveOrder(order);
      
      // Add to local list and refresh
      orders.add(order);
      orders.refresh();

      // إضافة للطلبات المعلقة (للإشعارات)
      addPendingOrder(orderItem);

      // عرض إشعار للمستخدم
      final notificationService = Get.find<NotificationService>();
      notificationService.showOrderNotification(orderItem);

      // عرض رسالة نجاح
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'تم الطلب',
          'تم طلب ${product.name} (${quantity}x) وهو قيد التحضير',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withAlpha(179),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      });

      return true;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إضافة المنتج للطلب: $e');
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إضافة المنتج للطلب',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(179),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      });
      return false;
    }
  }

  // إضافة طلب للقائمة المعلقة
  void addPendingOrder(OrderItem item) {
    try {
      pendingItems.add(item);
      pendingItems.refresh();

      // تحديث إحصائيات المعلقة
      _updatePendingStats();

      LoggerUtil.logger
          .i('تمت إضافة طلب معلق: ${item.name} × ${item.quantity}');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إضافة الطلب المعلق: $e');
      rethrow;
    }
  }

  // معالجة طلب معلق - تحويله للاكتمال - إعادة تسمية هذه الدالة لتجنب التكرار مع completePendingItem
  Future<void> finalizePendingItem(OrderItem item) async {
    try {
      // تحقق من وجود الطلب المعلق
      int itemIndex = pendingItems.indexWhere((pendingItem) =>
          pendingItem.productId == item.productId &&
          pendingItem.quantity == item.quantity);

      if (itemIndex != -1) {
        // إزالة من المعلق
        pendingItems.removeAt(itemIndex);
        pendingItems.refresh();
      }

      // إنشاء طلب جديد مكتمل
      final order = Order(
        id: const Uuid().v4(), // يتطلب استيراد package:uuid/uuid.dart
        items: [item],
        createdAt: DateTime.now(),
        status: OrderStatus.completed,
        customerId: 'walk-in', // افتراضي للعملاء العابرين
        paymentType: PaymentType.cash, // افتراضي للدفع نقداً
      );

      // حفظ الطلب
      await _storage.saveOrder(order);

      // تحديث قائمة الطلبات
      orders.add(order);
      orders.refresh();

      // تحديث الإحصائيات
      _updateOrderStats(order);

      // سجل العملية
      LoggerUtil.logger.i('تم إكمال الطلب: ${item.name} × ${item.quantity}');
      LoggerUtil.logger.i('إجمالي الطلبات الآن: ${orders.length}');

      // حساب عدد الطلبات اليومية
      final todayOrdersCount = orders
          .where((order) =>
              order.createdAt.day == DateTime.now().day &&
              order.createdAt.month == DateTime.now().month &&
              order.createdAt.year == DateTime.now().year)
          .length;
      LoggerUtil.logger.i('عدد الطلبات اليوم: $todayOrdersCount');

      // حساب إجمالي المبيعات اليومية
      final todaySales = orders
          .where((order) =>
              order.createdAt.day == DateTime.now().day &&
              order.createdAt.month == DateTime.now().month &&
              order.createdAt.year == DateTime.now().year)
          .fold(0.0, (sum, order) => sum + order.total);
      LoggerUtil.logger.i('إجمالي المبيعات اليوم: $todaySales');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إكمال الطلب المعلق: $e');

      // عرض إشعار الخطأ
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إكمال الطلب',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(179),
          colorText: Colors.white,
        );
      });

      rethrow;
    }
  }

  // رفض/إلغاء طلب معلق
  void removePendingItem(OrderItem item) {
    try {
      int itemIndex = pendingItems.indexWhere((pendingItem) =>
          pendingItem.productId == item.productId &&
          pendingItem.quantity == item.quantity);

      if (itemIndex != -1) {
        pendingItems.removeAt(itemIndex);
        pendingItems.refresh();

        // تحديث إحصائيات المعلقة
        _updatePendingStats();

        LoggerUtil.logger
            .i('تم إلغاء الطلب المعلق: ${item.name} × ${item.quantity}');

        // إشعار بالإلغاء
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'تم الإلغاء',
            'تم إلغاء طلب ${item.name}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.amber.withAlpha(179),
            colorText: Colors.black,
            duration: const Duration(seconds: 2),
          );
        });
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إلغاء الطلب المعلق: $e');
    }
  }

  // الحصول على الطلبات المعلقة
  List<OrderItem> getPendingItems() {
    return pendingItems.toList();
  }

  // تغيير حالة الطلب - إعادة تسمية هذه الدالة لتجنب التكرار مع updateOrderStatus
  Future<bool> changeOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final orderIndex = orders.indexWhere((o) => o.id == orderId);
      if (orderIndex == -1) {
        return false;
      }

      // نسخة من الطلب وتحديث الحالة
      final order = orders[orderIndex];
      final updatedOrder = order.copyWith(status: newStatus);

      // حفظ التعديلات
      await _storage.saveOrder(updatedOrder);

      // تحديث قائمة الطلبات
      orders[orderIndex] = updatedOrder;
      orders.refresh();

      // تسجيل الحدث
      LoggerUtil.logger
          .i('تم تحديث حالة الطلب $orderId إلى ${_getStatusName(newStatus)}');

      return true;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في تحديث حالة الطلب: $e');
      return false;
    }
  }

  // الحصول على اسم الحالة بالعربي
  String _getStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'معلق';
      case OrderStatus.processing:
        return 'قيد التحضير';
      case OrderStatus.completed:
        return 'مكتمل';
      case OrderStatus.cancelled:
        return 'ملغي';
      }
  }

  // مساعد لتحديث إحصائيات الطلبات
  void _updateOrderStats(Order order) {
    // تنفيذ تحديثات إضافية للإحصائيات هنا
    // مثلاً، تحديث إحصائيات المنتجات الأكثر مبيعاً
    // تحديث توقيتات الذروة
    // الخ...
  }

  // مساعد لتحديث إحصائيات الطلبات المعلقة
  void _updatePendingStats() {
    // تحديث إحصائيات الطلبات المعلقة
    // إرسال إشعارات للموظفين إذا كان هناك طلبات معلقة جديدة
    // إلخ...
  }

  // احتساب وقت الانتظار للطلبات حسب حالتها
  Map<String, dynamic> calculateWaitTimes() {
    final pendingOrders = getPendingOrders();
    final processingOrders = getProcessingOrders();

    // احتساب متوسط وقت الانتظار للطلبات المعلقة
    Duration totalPendingWaitTime = Duration.zero;
    for (var order in pendingOrders) {
      final waitTime = DateTime.now().difference(order.createdAt);
      totalPendingWaitTime += waitTime;
    }

    // احتساب متوسط وقت المعالجة للطلبات قيد التحضير
    Duration totalProcessingWaitTime = Duration.zero;
    for (var order in processingOrders) {
      final waitTime = DateTime.now().difference(order.createdAt);
      totalProcessingWaitTime += waitTime;
    }

    // احتساب المتوسطات
    final avgPendingMinutes = pendingOrders.isNotEmpty
        ? totalPendingWaitTime.inSeconds / pendingOrders.length / 60
        : 0.0;

    final avgProcessingMinutes = processingOrders.isNotEmpty
        ? totalProcessingWaitTime.inSeconds / processingOrders.length / 60
        : 0.0;

    return {
      'avgPendingWaitMinutes': avgPendingMinutes,
      'avgProcessingWaitMinutes': avgProcessingMinutes,
      'pendingOrdersCount': pendingOrders.length,
      'processingOrdersCount': processingOrders.length,
    };
  }

  // أضف هذه الدالة في كلاس OrderController
  Future<void> removeOrder(String id) async {
    try {
      isLoading.value = true;
      
      // حذف الطلب من التخزين المحلي
      await _storage.deleteOrder(id);
      
      // حذف الطلب من القائمة المحلية
      orders.removeWhere((order) => order.id == id);
      orders.refresh();
      
      // عرض رسالة تأكيد
      _showSuccessMessage(
        'تم الحذف',
        'تم حذف الطلب بنجاح',
      );
      
      LoggerUtil.logger.i('تم حذف الطلب بنجاح: $id');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الطلب: $e');
      _showErrorMessage('خطأ', 'حدث خطأ أثناء محاولة حذف الطلب');
    } finally {
      isLoading.value = false;
    }
  }

  // إضافة هذه الدالة إلى كلاس OrderController
  Future<bool> deleteOrder(String id) async {
    try {
      isLoading.value = true;
      
      // حذف الطلب من التخزين المحلي
      await _storage.deleteOrder(id);
      
      // حذف الطلب من القائمة المحلية
      orders.removeWhere((order) => order.id == id);
      orders.refresh();
      
      // عرض رسالة نجاح
      _showSuccessMessage(
        'تم الحذف',
        'تم حذف الطلب بنجاح',
      );
      
      LoggerUtil.logger.i('تم حذف الطلب بنجاح: $id');
      return true;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الطلب: $e');
      _showErrorMessage('خطأ', 'حدث خطأ أثناء محاولة حذف الطلب');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // أضف هذه الدالة إلى كلاس OrderController
  Future<bool> deleteOrderById(String id) async {
    try {
      isLoading.value = true;
      
      // حذف الطلب من التخزين المحلي
      await _storage.deleteOrder(id);
      
      // حذف الطلب من القائمة المحلية
      orders.removeWhere((order) => order.id == id);
      orders.refresh();
      
      LoggerUtil.logger.i('تم حذف الطلب بنجاح: $id');
      
      // عرض رسالة نجاح
      Get.snackbar(
        'تم الحذف',
        'تم حذف الطلب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withAlpha(179),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      return true;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الطلب: $e');
      
      // عرض رسالة خطأ
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء محاولة حذف الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(179),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
