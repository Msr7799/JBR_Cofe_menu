import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';

class OrderController extends GetxController {
  final LocalStorageService _storage;
  final orders = <Order>[].obs;
  final isLoading = false.obs;

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
      print('Error loading orders: $e');
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
      print('Error saving order: $e');
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
    return orders.where((order) => order.status == OrderStatus.pending).toList();
  }

  List<Order> getProcessingOrders() {
    return orders.where((order) => order.status == OrderStatus.processing).toList();
  }

  List<Order> getCompletedOrders() {
    return orders.where((order) => order.status == OrderStatus.completed).toList();
  }

  List<Order> getCancelledOrders() {
    return orders.where((order) => order.status == OrderStatus.cancelled).toList();
  }

  List<Order> getRecentOrders({int limit = 5}) {
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedOrders.take(limit).toList();
  }

  int getTodayOrdersCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return orders
        .where((order) => order.createdAt.isAfter(today))
        .length;
  }

  int getPendingOrdersCount() {
    return orders
        .where((order) => order.status == OrderStatus.pending)
        .length;
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
}
