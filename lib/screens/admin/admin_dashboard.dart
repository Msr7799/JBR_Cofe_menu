import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/widgets/admin/sales_chart.dart';
import 'package:gpr_coffee_shop/widgets/admin/admin_drawer.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/category_management.dart';
import 'package:gpr_coffee_shop/screens/admin/product_management.dart';
import 'package:gpr_coffee_shop/screens/admin/order_history.dart';
import 'package:gpr_coffee_shop/screens/admin/feedback_management.dart';
import 'package:gpr_coffee_shop/widgets/admin/data_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/utils/hive_reset_util.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late final ProductController productController;
  late final OrderController orderController;
  late final AuthController authController;
  late final CategoryController categoryController;

  @override
  void initState() {
    super.initState();
    productController = Get.find<ProductController>();
    orderController = Get.find<OrderController>();
    authController = Get.find<AuthController>();
    categoryController = Get.find<CategoryController>();

    ever(orderController.orders, (_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: AdminDrawer(),
      body: Obx(
        () => orderController.isLoading.value ||
                productController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                        child: Text(
                          'admin'.tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildAdminCards(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'statistics'.tr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _showResetStatsDialog(context),
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              label: Text('reset_stats'.tr,
                                  style: const TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => _buildStatisticsCards()),
                      const SizedBox(height: 24),
                      Obx(() => _buildTopProducts()),
                      const SizedBox(height: 24),
                      Obx(() => _buildRecentOrders()),
                      const SizedBox(height: 24),
                      _buildSectionHeader('system_settings'.tr),
                      _buildSystemSettingsCard(context),
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
    final stats = orderController.getDailyStats();

    return Row(
      children: [
        Expanded(
          child: DataCard(
            title: 'daily_sales'.tr,
            value:
                '${stats['totalSales']?.toStringAsFixed(3) ?? '0.000'} ${'currency'.tr}',
            icon: Icons.attach_money,
            customColor: Colors.green.shade600,
            onTap: () {
              Get.to(() => const OrderHistoryScreen());
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DataCard(
            title: 'daily_profits'.tr,
            value:
                '${stats['totalProfit']?.toStringAsFixed(3) ?? '0.000'} ${'currency'.tr}',
            icon: Icons.trending_up,
            customColor: Colors.blue.shade600,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DataCard(
            title: 'order_count'.tr,
            value: stats['orderCount']?.toString() ?? '0',
            icon: Icons.receipt_long,
            customColor: Colors.orange.shade600,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTopProducts() {
    final stats = orderController.getDailyStats();
    final topProducts = stats['topProducts'] as List? ?? [];

    if (topProducts.isEmpty) {
      return _buildTopProductsFromController();
    }

    final chartData = topProducts.map((product) {
      return SaleData(
        name: product['name'] as String? ?? '',
        value: (product['quantity'] as int? ?? 0).toDouble(),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'popular_products'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (chartData.isNotEmpty)
              SalesChart(data: chartData)
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'no_sales_data'.tr,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsFromController() {
    final topProducts = productController.getTopProducts();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'popular_products'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recent_orders'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentOrders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                return ListTile(
                  title: Text('#${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    '${order.total.toStringAsFixed(3)} ${'currency'.tr}',
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
        label = 'pending'.tr;
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        label = 'processing'.tr;
        break;
      case OrderStatus.completed:
        color = Colors.green;
        label = 'completed'.tr;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        label = 'cancelled'.tr;
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

  Widget _buildAdminCards() {
    // Use smaller grid for more compact view
    return GridView.count(
      crossAxisCount: 3, // Changed from 2 to 3 for smaller cards
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.0, // Reduced spacing
      crossAxisSpacing: 12.0, // Reduced spacing
      childAspectRatio: 0.85, // Make cards slightly taller than wide
      children: [
        _buildAdminActionCard(
          icon: Icons.category,
          title: 'category_management'.tr,
          subtitle:
              '${categoryController.categories.length} ${'categories'.tr.toLowerCase()}',
          color: Colors.teal,
          onTap: () => Get.to(() => CategoryManagement()),
        ),
        _buildAdminActionCard(
          icon: Icons.shopping_bag,
          title: 'product_management'.tr,
          subtitle:
              '${productController.products.length} ${'products'.tr.toLowerCase()}',
          color: Colors.indigo,
          onTap: () => Get.to(() => const ProductManagement()),
        ),
        _buildAdminActionCard(
          icon: Icons.receipt_long,
          title: 'order_history'.tr,
          subtitle:
              '${orderController.orders.length} ${'orders'.tr.toLowerCase()}',
          color: Colors.amber.shade700,
          onTap: () => Get.to(() => const OrderHistoryScreen()),
        ),
        _buildAdminActionCard(
          icon: Icons.settings,
          title: 'settings'.tr,
          subtitle: 'app_settings'.tr,
          color: Colors.blueGrey,
          onTap: () => Get.toNamed('/settings'),
        ),
        _buildAdminActionCard(
          icon: Icons.insert_chart,
          title: 'reports'.tr,
          subtitle: 'sales_overview'.tr,
          color: Colors.green.shade600,
          onTap: () {
            Get.snackbar(
              'coming_soon'.tr,
              'feature_coming_soon'.tr,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        _buildAdminActionCard(
          icon: Icons.qr_code,
          title: 'benefitpayQR'.tr,
          subtitle: 'manage_qr'.tr,
          color: Colors.purple,
          onTap: () => Get.toNamed('/benefit-pay-qr'),
        ),
        _buildAdminActionCard(
          icon: Icons.feedback,
          title: 'feedback_management'.tr,
          subtitle: 'manage_feedback'.tr,
          color: AppTheme.primaryColor,
          onTap: () => Get.to(() => FeedbackManagement()),
        ),
      ],
    );
  }

  Widget _buildAdminActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22, // Smaller radius
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 22, color: color), // Smaller icon
              ),
              const SizedBox(height: 8), // Reduced spacing
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13, // Smaller font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), // Reduced spacing
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10, // Smaller font size
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('reset_stats'.tr),
          content: Text(
            'reset_stats_confirmation'.tr,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _exportStatsAsText();
              },
              child: Text('export_and_save'.tr),
            ),
            TextButton(
              onPressed: () {
                _resetStats();
                Navigator.of(context).pop();
                Get.snackbar(
                  'success'.tr,
                  'stats_reset_success'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('reset_without_save'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportStatsAsText() async {
    try {
      final stats = orderController.getDailyStats();
      final topProducts = stats['topProducts'] as List? ?? [];
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}";
      final reportContent = StringBuffer();
      reportContent.writeln('تقرير مبيعات المقهى - $formattedDate');
      reportContent.writeln('================================');
      reportContent.writeln('');
      reportContent.writeln(
          'إجمالي المبيعات: ${stats['totalSales']?.toStringAsFixed(3) ?? '0'} د.ب');
      reportContent.writeln(
          'إجمالي الأرباح: ${stats['totalProfit']?.toStringAsFixed(3) ?? '0'} د.ب');
      reportContent.writeln('عدد الطلبات: ${stats['orderCount'] ?? '0'}');
      reportContent.writeln(
          'متوسط قيمة الطلب: ${stats['avgOrderValue']?.toStringAsFixed(3) ?? '0'} د.ب');
      reportContent.writeln('');
      reportContent.writeln('المنتجات الأكثر مبيعاً:');
      reportContent.writeln('--------------------------------');

      if (topProducts.isNotEmpty) {
        for (int i = 0; i < topProducts.length; i++) {
          final product = topProducts[i];
          reportContent.writeln(
              '${i + 1}. ${product['name'] ?? 'غير معروف'} - الكمية: ${product['quantity'] ?? 0}');
        }
      } else {
        reportContent.writeln('لا توجد بيانات للمنتجات');
      }

      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/coffee_shop_report_$formattedDate.txt';
      final file = File(filePath);

      await file.writeAsString(reportContent.toString());

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'تقرير مبيعات المقهى - $formattedDate',
      );

      _resetStats();

      Get.snackbar(
        'تمت العملية',
        'تم تصدير البيانات وتصفير الإحصائيات بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      LoggerUtil.logger.e('Error exporting stats: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تصدير البيانات: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _resetStats() {
    orderController.resetDailyStats();
    _refreshData();
  }

  Widget _buildSystemSettingsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.red),
              title: Text('factory_reset'.tr),
              subtitle: Text('factory_reset_description'.tr),
              trailing: const Icon(Icons.warning, color: Colors.red),
              onTap: () => HiveResetUtil.showResetConfirmationDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  // Helper method to determine if the image is an asset or a file
  Widget _buildProductImage(String? imagePath, {double size = 60}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Icon(Icons.image_not_supported, size: size * 0.5);
    }

    try {
      // Check if the path is a local file path
      if (imagePath.startsWith('C:') ||
          imagePath.startsWith('/') ||
          imagePath.contains('Documents')) {
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            print('خطأ تحميل الصورة: $imagePath, $error');
            return Icon(Icons.broken_image, size: size * 0.5);
          },
        );
      } else {
        // Otherwise assume it's an asset path
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            print('خطأ تحميل الأصول: $imagePath, $error');
            return Icon(Icons.broken_image, size: size * 0.5);
          },
        );
      }
    } catch (e) {
      LoggerUtil.logger.e('Error building product image: $e');
      return Icon(Icons.broken_image, size: size * 0.5);
    }
  }
}
