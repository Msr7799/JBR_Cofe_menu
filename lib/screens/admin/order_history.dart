import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/widgets/admin/admin_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final orderController = Get.find<OrderController>();
  OrderStatus? selectedStatus;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سجل الطلبات'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: AdminDrawer(),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(
              () => orderController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : _buildOrdersList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'بحث',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilter('الكل', null),
                _buildStatusFilter('معلق', OrderStatus.pending),
                _buildStatusFilter('قيد التحضير', OrderStatus.processing),
                _buildStatusFilter('مكتمل', OrderStatus.completed),
                _buildStatusFilter('ملغي', OrderStatus.cancelled),
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
      padding: EdgeInsets.symmetric(horizontal: 4),
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
        separatorBuilder: (context, index) => Divider(),
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
                  Text('العميل: ${order.customerName}'),
                Text('التاريخ: ${_formatDate(order.createdAt)}'),
                Text('الإجمالي: ${order.total.toStringAsFixed(3)} د.ب'),
                SizedBox(height: 8),
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.name} x ${item.quantity}'),
              Text('${(item.price * item.quantity).toStringAsFixed(3)} د.ب'),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب #${order.id.substring(0, 8)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('العميل: ${order.customerName ?? "غير محدد"}'),
              Text('التاريخ: ${_formatDate(order.createdAt)}'),
              Text('طريقة الدفع: ${_getPaymentTypeText(order.paymentType)}'),
              if (order.notes != null && order.notes!.isNotEmpty)
                Text('ملاحظات: ${order.notes}'),
              SizedBox(height: 16),
              Text('المنتجات:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildItemsList(order.items),
              Divider(),
              Text(
                'الإجمالي: ${order.total.toStringAsFixed(3)} د.ب',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('إغلاق'),
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
        label = 'معلق';
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        label = 'قيد التحضير';
        break;
      case OrderStatus.completed:
        color = Colors.green;
        label = 'مكتمل';
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        label = 'ملغي';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
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
        return 'نقدي';
      case PaymentType.card:
        return 'بطاقة';
      case PaymentType.benefit:
        return 'بنفت باي';
      case PaymentType.other:
        return 'أخرى';
    }
  }
}
