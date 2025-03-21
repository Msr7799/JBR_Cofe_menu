import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/widgets/admin/sales_chart.dart';
import 'package:gpr_coffee_shop/widgets/admin/admin_drawer.dart';

class AdminDashboard extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final orderController = Get.find<OrderController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: AdminDrawer(),
      body: Obx(
        () => orderController.isLoading.value || productController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsCards(),
                      SizedBox(height: 24),
                      _buildTopProducts(),
                      SizedBox(height: 24),
                      _buildRecentOrders(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.wait([
      productController.fetchAllProducts(),
      orderController.loadOrders(),
    ]);
  }

  Widget _buildStatisticsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: [
        _buildStatCard(
          icon: Icons.shopping_cart,
          title: 'الطلبات اليوم',
          value: '${orderController.getTodayOrdersCount()}',
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.attach_money,
          title: 'إيرادات اليوم',
          value: '${orderController.getTodayRevenue().toStringAsFixed(3)} د.ب',
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.inventory,
          title: 'المنتجات',
          value: '${productController.products.length}',
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.pending_actions,
          title: 'طلبات معلقة',
          value: '${orderController.getPendingOrdersCount()}',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    final topProducts = productController.getTopProducts();
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المنتجات الأكثر مبيعاً',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SalesChart(
              data: topProducts
                  .map((product) => SaleData(
                        name: product.productName,
                        value: product.salesCount.toDouble(),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders() {
    final recentOrders = orderController.getRecentOrders(limit: 5);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آخر الطلبات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentOrders.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                return ListTile(
                  title: Text('#${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    '${order.total.toStringAsFixed(3)} د.ب',
                  ),
                  trailing: _buildOrderStatusChip(order.status),
                );
              },
            ),
          ],
        ),
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
}
