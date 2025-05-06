import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/widgets/admin/admin_drawer.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  final OrderController orderController = Get.find<OrderController>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Now only 3 tabs (Processing, Completed, Cancelled)
    _tabController = TabController(length: 3, vsync: this);

    // Use microtask to avoid calling setState during build
    Future.microtask(() => orderController.loadOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_management'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // إضافة قائمة منسدلة للخيارات الإضافية
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_completed') {
                _showClearCompletedDialog();
              } else if (value == 'reset_orders') {
                _showResetOrdersDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'clear_completed',
                child: Row(
                  children: [
                    const Icon(Icons.delete_sweep, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('clear_completed_orders'.tr),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'reset_orders',
                child: Row(
                  children: [
                    const Icon(Icons.restore, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text('reset_orders'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: _buildTabs(),
      ),
      drawer: AdminDrawer(),
      body: GetX<OrderController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Removed pending orders tab
              _buildOrdersList(
                  controller.getProcessingOrders(), OrderStatus.processing),
              _buildOrdersList(
                  controller.getCompletedOrders(), OrderStatus.completed),
              _buildOrdersList(
                  controller.getCancelledOrders(), OrderStatus.cancelled),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          orderController.loadOrders();
          Get.snackbar(
            'refresh_orders'.tr,
            'orders_refreshed'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.primaryColor,
            colorText: Colors.white,
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders, OrderStatus status) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'no_${status.toString().split('.').last.toLowerCase()}_orders'.tr,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // ترتيب الطلبات بحيث الأحدث في الأعلى
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      itemCount: sortedOrders.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final order = sortedOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  // دالة تحسين عرض الطلب
  Widget _buildOrderCard(Order order) {
    final totalPrice = order.total;
    final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'order'.tr} #${order.id.substring(0, 6)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const Divider(),
            // تحسين عرض عناصر الطلب مع رأس للجدول
            Column(
              children: [
                // رأس الجدول
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'product'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'quantity'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'price'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'total'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),

                // التحقق من وجود عناصر في الطلب
                if (order.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'no_products_in_order'.tr,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  // عناصر الطلب
                  ...order.items
                      .map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.name.isNotEmpty
                                        ? item.name
                                        : 'unknown_product'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${item.quantity}×',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${item.price.toStringAsFixed(3)} ${'currency'.tr}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${(item.price * item.quantity).toStringAsFixed(3)} ${'currency'.tr}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
              ],
            ),
            const Divider(),
            // معلومات الطلب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${('date').tr}: $formattedDate'),
                Text(
                    '${('total').tr}: ${totalPrice.toStringAsFixed(3)} ${'currency'.tr}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            // أزرار التحكم
            _buildOrderActions(order),
          ],
        ),
      ),
    );
  }

  // دالة تحسين عرض حالة الطلب
  Widget _buildStatusChip(OrderStatus status) {
    return Chip(
      label: Text(_getStatusText(status)),
      backgroundColor: _getStatusColor(status),
      labelStyle: const TextStyle(color: Colors.white),
      avatar: Icon(_getStatusIcon(status), color: Colors.white, size: 16),
    );
  }

  // تعديل دالة _buildTabs لتغيير عرض التبويبات - حذف تبويب الطلبات المعلقة
  PreferredSizeWidget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppTheme.primaryColor,
      tabs: [
        // Removed pending tab
        Tab(
          icon: const Icon(Icons.hourglass_top),
          text: 'tab_processing'.tr,
        ),
        Tab(
          icon: const Icon(Icons.check_circle),
          text: 'tab_completed'.tr,
        ),
        Tab(
          icon: const Icon(Icons.cancel),
          text: 'tab_cancelled'.tr,
        ),
      ],
    );
  }

  // تحسين دالة _buildActionButtons لعرض الأزرار المناسبة حسب حالة الطلب
  Widget _buildOrderActions(Order order) {
    final List<Widget> actions = [];

    // إذا كان الطلب قيد التحضير، نقدم خيارات الاكتمال أو الإلغاء
    if (order.status == OrderStatus.processing) {
      // زر إكمال الطلب
      actions.add(
        ElevatedButton.icon(
          onPressed: () => _confirmStatusChange(
            order,
            OrderStatus.completed,
            'confirm_complete_order'.tr, // رسالة التأكيد
            () => orderController.updateOrderStatus(
                order.id, OrderStatus.completed), // دالة التنفيذ
          ),
          icon: const Icon(Icons.check_circle, color: Colors.green),
          label: Text('complete'.tr),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.2),
            foregroundColor: Colors.green,
          ),
        ),
      );

      actions.add(const SizedBox(width: 8));

      // زر إلغاء الطلب
      actions.add(
        ElevatedButton.icon(
          onPressed: () => _confirmStatusChange(
            order,
            OrderStatus.cancelled,
            'confirm_cancel_order'.tr, // رسالة التأكيد
            () => orderController.updateOrderStatus(
                order.id, OrderStatus.cancelled), // دالة التنفيذ
          ),
          icon: const Icon(Icons.cancel, color: Colors.red),
          label: Text('cancel'.tr),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.2),
            foregroundColor: Colors.red,
          ),
        ),
      );
    }
    // إذا كان الطلب ملغياً أو مكتملاً، يمكن حذفه فقط
    else if (order.status == OrderStatus.completed ||
        order.status == OrderStatus.cancelled) {
      actions.add(
        ElevatedButton.icon(
          onPressed: () {
            _confirmDeleteOrder(order);
          },
          icon: const Icon(Icons.delete, color: Colors.grey),
          label: Text('delete'.tr),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(0.2),
            foregroundColor: Colors.grey,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: actions,
    );
  }

  void _confirmStatusChange(Order order, OrderStatus newStatus,
      String confirmMessage, Function() onConfirm) {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_status_change'.tr),
        content: Text(confirmMessage),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _getStatusColor(newStatus),
            ),
            child: Text('confirm'.tr),
            onPressed: () {
              Get.back();
              onConfirm().then((success) {
                if (success) {
                  Get.snackbar(
                    'status_updated'.tr,
                    '${'order_status_changed'.tr} ${_getStatusText(newStatus)}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: _getStatusColor(newStatus),
                    colorText: Colors.white,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // دالة لتأكيد حذف طلب
  void _confirmDeleteOrder(Order order) {
    Get.defaultDialog(
      title: 'confirm_delete'.tr,
      middleText: 'confirm_delete_order'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      cancelTextColor: AppTheme.primaryColor,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await orderController.deleteOrderById(order.id);
      },
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending_actions;
      case OrderStatus.processing:
        return Icons.local_cafe;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'status_pending'.tr;
      case OrderStatus.processing:
        return 'status_processing'.tr;
      case OrderStatus.completed:
        return 'status_completed'.tr;
      case OrderStatus.cancelled:
        return 'status_cancelled'.tr;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  // دالة لعرض مربع حوار تأكيد حذف الطلبات المكتملة
  void _showClearCompletedDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('alert'.tr),
        content: Text('clear_completed_orders_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // إغلاق الحوار فقط
            },
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              // إغلاق الحوار أولاً
              Get.back();

              // انتظار قليلاً قبل تنفيذ الإجراء لتجنب تداخل Get.back() مع snackbar
              Future.delayed(const Duration(milliseconds: 300), () {
                _clearCompletedOrders();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  // فصل منطق حذف الطلبات المكتملة إلى دالة منفصلة
  Future<void> _clearCompletedOrders() async {
    try {
      // عرض مؤشر التحميل
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // تنفيذ عملية الحذف
      final count = await orderController.clearCompletedOrders();

      // إغلاق مؤشر التحميل
      Get.back();

      // عرض إشعار نجاح العملية بعد تأخير قصير
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'success'.tr,
          'completed_orders_cleared'.tr.replaceAll('{count}', count.toString()),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      });
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة حدوث خطأ
      Get.back();

      // عرض إشعار الخطأ بعد تأخير قصير
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'error'.tr,
          'error_clearing_completed_orders'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
      LoggerUtil.logger.e('Error clearing completed orders: $e');
    }
  }

  // دالة لعرض مربع حوار تأكيد إعادة تعيين الطلبات
  void _showResetOrdersDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('reset_orders'.tr),
        content: Text('reset_orders_confirmation'.tr),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text('confirm'.tr),
            onPressed: () {
              Get.back();
              _resetOrders();
            },
          ),
        ],
      ),
    );
  }

  // دالة لإعادة تعيين الطلبات
  Future<void> _resetOrders() async {
    // عرض مؤشر التحميل
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await orderController.resetDailyStats();

      // إغلاق مؤشر التحميل
      Get.back();

      // عرض رسالة نجاح
      Get.snackbar(
        'success'.tr,
        'orders_reset_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // إغلاق مؤشر التحميل
      Get.back();

      // عرض رسالة خطأ
      Get.snackbar(
        'error'.tr,
        'error_resetting_orders'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

// تأكد من أن هذه الدالات تعمل بشكل صحيح
Future<void> saveOrder(Order order) async {
  try {
    await _ordersBox.put(order.id, order.toJson());
    LoggerUtil.logger.i('تم حفظ الطلب: ${order.id}');
  } catch (e) {
    LoggerUtil.logger.e('خطأ في حفظ الطلب: $e');
    rethrow;
  }
}

Future<List<Order>> getOrders() async {
  try {
    final orderMaps = _ordersBox.values.toList();
    final orders = <Order>[];

    for (var item in orderMaps) {
      if (item is Map) {
        try {
          orders.add(Order.fromJson(Map<String, dynamic>.from(item)));
        } catch (e) {
          LoggerUtil.logger.e('خطأ في تحليل الطلب: $e');
        }
      }
    }

    return orders;
  } catch (e) {
    LoggerUtil.logger.e('خطأ في الحصول على الطلبات: $e');
    return [];
  }
}

class _ordersBox {
  static var values;

  static put(String id, Map<String, dynamic> json) {}
}
