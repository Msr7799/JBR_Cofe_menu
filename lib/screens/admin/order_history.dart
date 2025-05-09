import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/widgets/admin/admin_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}

class OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final orderController = Get.find<OrderController>();
  OrderStatus? selectedStatus;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_history'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        foregroundColor: Colors.white,
      ),
      drawer: AdminDrawer(),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(
              () => orderController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildOrdersList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'search'.tr,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilter('all'.tr, null),
                _buildStatusFilter('status_pending'.tr, OrderStatus.pending),
                _buildStatusFilter(
                    'status_processing'.tr, OrderStatus.processing),
                _buildStatusFilter(
                    'status_completed'.tr, OrderStatus.completed),
                _buildStatusFilter(
                    'status_cancelled'.tr, OrderStatus.cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String label, OrderStatus? status) {
    final isSelected = selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedStatus = selected ? status : null;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildOrdersList() {
    var filteredOrders = orderController.orders.where((order) {
      if (selectedStatus != null && order.status != selectedStatus) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return order.id.toLowerCase().contains(query) ||
            (order.customerName?.toLowerCase().contains(query) ?? false);
      }
      return true;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return RefreshIndicator(
      onRefresh: () => orderController.loadOrders(),
      child: ListView.separated(
        itemCount: filteredOrders.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${order.id.substring(0, 8)}'),
                _buildOrderStatusChip(order.status),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.customerName != null)
                  Text('${'customer'.tr}: ${order.customerName}'),
                Text('${'order_date'.tr}: ${_formatDate(order.createdAt)}'),
                Text(
                    '${'total'.tr}: ${order.total.toStringAsFixed(3)} ${'currency'.tr}'),
                const SizedBox(height: 8),
                _buildItemsList(order.items),
              ],
            ),
            onTap: () => _showOrderDetails(order),
          );
        },
      ),
    );
  }

  Widget _buildItemsList(List<OrderItem> items) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إضافة رأس للجدول
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
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
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'no_order_items'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            // عناصر الطلب
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.name.isNotEmpty ? item.name : 'unknown_product'.tr,
                        maxLines: 1,
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
                        '${item.price.toStringAsFixed(3)} د.ب',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${(item.price * item.quantity).toStringAsFixed(3)} د.ب',
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${'order_details'.tr} #${order.id.substring(0, 8)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${'customer'.tr}: ${order.customerName ?? 'unknown'.tr}'),
              Text('${'order_date'.tr}: ${_formatDate(order.createdAt)}'),
              Text(
                  '${'payment_method'.tr}: ${_getPaymentTypeText(order.paymentType)}'),
              if (order.notes != null && order.notes!.isNotEmpty)
                Text('${'notes'.tr}: ${order.notes}'),
              const SizedBox(height: 16),
              const Text('المنتجات:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _buildItemsList(order.items),
              const Divider(),
              Text(
                '${'total'.tr}: ${order.total.toStringAsFixed(3)} ${'currency'.tr}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('close'.tr),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusChip(OrderStatus status) {
    Color color;
    String label;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        label = 'status_pending'.tr;
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        label = 'status_processing'.tr;
        break;
      case OrderStatus.completed:
        color = Colors.green;
        label = 'status_completed'.tr;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        label = 'status_cancelled'.tr;
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getPaymentTypeText(PaymentType type) {
    switch (type) {
      case PaymentType.cash:
        return 'cash'.tr;
      case PaymentType.card:
        return 'credit_card'.tr;
      case PaymentType.benefit:
        return 'benefitpay'.tr;
      case PaymentType.other:
        return 'other'.tr;
    }
  }
}
