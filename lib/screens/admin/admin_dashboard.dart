import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/screens/admin/sales_report_screen.dart';
import 'package:gpr_coffee_shop/utils/chart_utils.dart';
import 'package:gpr_coffee_shop/widgets/admin/sales_chart.dart';
import 'package:gpr_coffee_shop/widgets/admin/admin_drawer.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/category_management.dart';
import 'package:gpr_coffee_shop/screens/admin/product_management.dart';
import 'package:gpr_coffee_shop/screens/admin/order_history.dart';
import 'package:gpr_coffee_shop/screens/admin/feedback_management.dart';
import 'package:gpr_coffee_shop/widgets/admin/data_card.dart';
import 'package:gpr_coffee_shop/widgets/pop_scope.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/utils/hive_reset_util.dart';
import 'package:gpr_coffee_shop/screens/admin/order_management_screen.dart';
import 'package:intl/intl.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_notes.dart';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/widgets/admin/category_sales_chart.dart';
import 'package:gpr_coffee_shop/utils/date_formatter.dart';
import 'package:gpr_coffee_shop/widgets/pending_orders_panel.dart';

// نقل الكلاسات المساعدة إلى خارج الكلاس الرئيسي (قبل AdminDashboard)

// كلاس مساعد لبيانات الشاشة
class _ScreenMetrics {
  final bool isSmallScreen;
  final bool isVerySmallScreen;
  final bool isLandscape;
  final double width;
  final double height;

  _ScreenMetrics({
    required this.isSmallScreen,
    required this.isVerySmallScreen,
    required this.isLandscape,
    required this.width,
    required this.height,
  });
}

// مكوّن للتعامل مع بيانات الحالة الطلب
class _StatusConfig {
  final Color color;
  final String label;

  _StatusConfig(this.color, this.label);
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // ثوابت التطبيق
  static const double _defaultPadding = 16.0;
  static const double _smallPadding = 8.0;
  static const double _tinyPadding = 4.0;
  static const double _defaultIconSize = 24.0;
  static const double _smallIconSize = 16.0;

  late final ProductController productController;
  late final OrderController orderController;
  late final AuthController authController;
  late final CategoryController categoryController;

  // إضافة متغيرات الاشتراك
  StreamSubscription? _ordersSubscription;
  StreamSubscription? _ordersPendingSubscription;

  @override
  void initState() {
    super.initState();
    productController = Get.find<ProductController>();
    orderController = Get.find<OrderController>();
    authController = Get.find<AuthController>();
    categoryController = Get.find<CategoryController>();

    // إعداد الإستماع بشكل آمن
    _setupSafeListeners();
  }

  void _setupSafeListeners() {
    // الاستماع بشكل آمن للتغييرات في الطلبات
    _ordersSubscription = orderController.orders.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });

    // الاستماع للتغييرات في الطلبات المعلقة
    _ordersPendingSubscription =
        orderController.pendingItems.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // إلغاء الاشتراكات عند التخلص من الكائن
    _ordersSubscription?.cancel();
    _ordersPendingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenMetrics = _getScreenMetrics(context);

    return SafeScaffold(
      appBar: _buildAppBar(),
      drawer: AdminDrawer(),
      body: Obx(() => _buildBody(screenMetrics)),
    );
  }

  // دالة منفصلة للحصول على مقاييس الشاشة
  _ScreenMetrics _getScreenMetrics(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return _ScreenMetrics(
      isSmallScreen: size.width < 600,
      isVerySmallScreen: size.width < 400,
      isLandscape: orientation == Orientation.landscape,
      width: size.width,
      height: size.height,
    );
  }

  // بناء شريط التطبيق
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.dashboard),
          const SizedBox(width: 8),
          Text('dashboard'.tr),
        ],
      ),
      centerTitle: true,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            final pendingCount = orderController.getPendingOrders().length;
            if (pendingCount > 0) {
              Get.to(() => const OrderManagementScreen());
            } else {
              Get.snackbar(
                'no_pending_orders'.tr,
                'no_pending_orders_message'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          tooltip: 'notifications'.tr,
        ),
      ],
    );
  }

  // بناء جسم الصفحة
  Widget _buildBody(_ScreenMetrics metrics) {
    if (orderController.isLoading.value || productController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(
            metrics.isVerySmallScreen ? _smallPadding : _defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminHeader(metrics),

            // قسم الإحصائيات والأرقام
            _buildSectionHeader('الإحصائيات اليومية'),
            _buildProfitDetailsCard(metrics),
            const SizedBox(height: 16),

            // عرض حالة الطلبات الحالية
            _buildSectionHeader('حالة الطلبات'),
            _buildOrderStatusCard(metrics),
            const SizedBox(height: 24),

            // عرض الطلبات المعلقة إذا وجدت
            Obx(() {
              if (orderController.pendingItems.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('الطلبات المعلقة'),
                    const PendingOrdersPanel(),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // قسم المخططات البيانية
            _buildSectionHeader('التحليل البياني'),
            _buildSaleChartTabs(),
            const SizedBox(height: 24),

            // قسم المنتجات الأكثر مبيعاً
            _buildSectionHeader('المنتجات الأكثر مبيعاً'),
            _buildTopProductsSection(),
            const SizedBox(height: 24),

            // قسم الطلبات الأخيرة
            _buildSectionHeader('آخر الطلبات'),
            _buildRecentOrdersSection(),
            const SizedBox(height: 24),

            // قسم أدوات الإدارة والوصول السريع
            _buildSectionHeader('أدوات الإدارة'),
            _buildAdminCardSection(metrics),
            const SizedBox(height: 24),

            // قسم إعدادات النظام
            _buildSectionHeader('إعدادات النظام'),
            _buildSystemSettingsCard(),
            const SizedBox(height: 16),
          ],
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

  // تحديث الدالة _buildProfitDetailsCard وإزالة البطاقات المكررة
  Widget _buildStatisticsCards(_ScreenMetrics metrics) {
    final stats = orderController.getDailyStats();

    // تعديل _buildStatisticsCards لعدم إظهار المعلومات المكررة - نعرض فقط عدد الطلبات
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryColor,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  'order_count'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stats['orderCount']?.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
    final recentOrders =
        orderController.getRecentOrders(limit: 3); // تقليل العدد إلى 3

    return Column(
      children: [
        if (recentOrders.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'no_recent_orders'.tr,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return _buildOrderListItem(order);
            },
          ),

        // زر لعرض المزيد من الطلبات
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextButton.icon(
            onPressed: () => _showAllOrdersDialog(),
            icon: const Icon(Icons.visibility),
            label: Text('view_all_orders'.tr),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  // إصلاح دالة _showAllOrdersDialog

  void _showAllOrdersDialog() {
    final recentOrders = orderController.getRecentOrders(limit: 20);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'recent_orders'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.6,
                ),
                child: recentOrders.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'no_recent_orders'.tr,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: recentOrders.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return _buildOrderListItem(recentOrders[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetailsDialog(Order order) {
    final formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'order_details'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),

              // رقم الطلب والتاريخ والحالة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${order.id.substring(0, 8)}'),
                  _buildOrderStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('Date: $formattedDate',
                  style: TextStyle(color: Colors.grey[700])),

              const Divider(),

              // عناصر الطلب
              Text(
                'order_items'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.3,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.name),
                      subtitle: Text(
                          '${item.quantity} × ${item.price.toStringAsFixed(3)} ${'currency'.tr}'),
                      trailing: Text(
                        '${(item.price * item.quantity).toStringAsFixed(3)} ${'currency'.tr}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),

              const Divider(),

              // الإجمالي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${order.total.toStringAsFixed(3)} ${'currency'.tr}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),

              if (order.profit > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'profit'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${order.profit.toStringAsFixed(3)} ${'currency'.tr}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderListItem(Order order) {
    final formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: Row(
        children: [
          Text('#${order.id.substring(0, 8)}'),
          const SizedBox(width: 8),
          _buildOrderStatusChip(order.status),
        ],
      ),
      subtitle: Text(formattedDate),
      trailing: Text(
        '${order.total.toStringAsFixed(3)} ${'currency'.tr}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
      onTap: () => _showOrderDetailsDialog(order),
    );
  }

  // مكوّن لعرض شرائح حالة الطلب
  Widget _buildOrderStatusChip(OrderStatus status) {
    final statusConfig = _getStatusConfig(status);

    return Chip(
      label: Text(
        statusConfig.label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: statusConfig.color,
    );
  }

  // مكوّن للتعامل مع بيانات الحالة
  _StatusConfig _getStatusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusConfig(Colors.orange, 'status_pending'.tr);
      case OrderStatus.processing:
        return _StatusConfig(Colors.blue, 'status_processing'.tr);
      case OrderStatus.completed:
        return _StatusConfig(Colors.green, 'status_completed'.tr);
      case OrderStatus.cancelled:
        return _StatusConfig(Colors.red, 'status_cancelled'.tr);
    }
  }

  Widget _buildAdminCards(
      bool isSmallScreen, bool isVerySmallScreen, bool isLandscape) {
    // Use smaller grid for more compact view
    return GridView.count(
      crossAxisCount:
          isSmallScreen ? 2 : 3, // Changed from 2 to 3 for smaller cards
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: isVerySmallScreen ? 8.0 : 12.0, // Reduced spacing
      crossAxisSpacing: isVerySmallScreen ? 8.0 : 12.0, // Reduced spacing
      childAspectRatio:
          isLandscape ? 1.2 : 0.85, // Make cards slightly taller than wide
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
          onTap: () => Get.to(() => ProductManagement()),
        ),
        _buildAdminActionCard(
          icon: Icons.receipt_long,
          title: 'order_management'.tr,
          subtitle:
              '${orderController.orders.length} ${'orders'.tr.toLowerCase()}',
          color: Colors.amber.shade700,
          onTap: () => Get.to(() => OrderManagementScreen()), // تغيير هنا
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
          onTap: () => Get.to(() => const SalesReportScreen()),
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
        _buildAdminActionCard(
          icon: Icons.history,
          title: 'order_history'.tr,
          subtitle: 'view_past_orders'.tr,
          color: Colors.indigo,
          onTap: () => Get.to(() => const OrderHistoryScreen()),
        ),
        // إضافة بطاقة الملاحظات في لوحة التحكم
        _buildAdminActionCard(
          icon: Icons.note_add,
          title: 'admin_notes'.tr,
          subtitle: 'manage_notes'.tr,
          color: Colors.teal,
          onTap: () => Get.to(() => const AdminNotes()),
        )
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
    Get.dialog(
      AlertDialog(
        title: Text('reset_stats'.tr),
        content: Text('reset_stats_confirmation'.tr,
            style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _exportStatsAsText();
            },
            child: Text('export_and_save'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              // عرض مؤشر التحميل
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                await orderController.resetDailyStats();
                await _refreshData();

                // إغلاق مؤشر التحميل
                Get.back();

                _showSuccessSnackbar('stats_reset_success'.tr);
              } catch (e) {
                // إغلاق مؤشر التحميل
                Get.back();

                _showErrorSnackbar('حدث خطأ أثناء إعادة تعيين الإحصائيات');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('reset_without_save'.tr),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'success'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _exportStatsAsText() async {
    try {
      final stats = orderController.getDailyStats();
      final formattedDate = _getFormattedDateTime();
      final reportContent = _buildReportContent(stats, formattedDate);

      final filePath = await _saveReportToFile(reportContent, formattedDate);
      await _shareReport(filePath, formattedDate);

      _resetStats();
      _showSuccessSnackbar('تم تصدير البيانات وتصفير الإحصائيات بنجاح');
    } catch (e) {
      LoggerUtil.logger.e('Error exporting stats: $e');
      _showErrorSnackbar('حدث خطأ أثناء تصدير البيانات: $e');
    }
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}";
  }

  String _buildReportContent(Map<String, dynamic> stats, String formattedDate) {
    final buffer = StringBuffer();
    final topProducts = stats['topProducts'] as List? ?? [];

    // بناء التقرير...
    buffer.writeln('تقرير مبيعات المقهى - $formattedDate');
    // ... باقي المحتوى

    return buffer.toString();
  }

  Future<String> _saveReportToFile(String content, String formattedDate) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/coffee_shop_report_$formattedDate.txt';
    final file = File(filePath);
    await file.writeAsString(content);
    return filePath;
  }

  Future<void> _shareReport(String filePath, String formattedDate) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'تقرير مبيعات المقهى - $formattedDate',
    );
  }

  void _resetStats() {
    orderController.resetDailyStats();
    _refreshData();
  }

  Widget _buildSystemSettingsCard() {
    // حذف المعلمة context
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

  // دالة عامة لبناء البطاقات بتنسيق موحد
  Widget _buildCard({
    required Widget child,
    double elevation = 2,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(_defaultPadding),
        child: child,
      ),
    );
  }

  // استخدام الدالة العامة في _buildTopProducts مثلاً:
  Widget _buildTopProductsSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'popular_products'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: _defaultPadding),
          _buildTopProductsContent(),
        ],
      ),
    );
  }

  Widget _buildAdminHeader(_ScreenMetrics metrics) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome_admin'.tr,
                style: TextStyle(
                  fontSize: metrics.isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateTime.now().toString().substring(0, 10),
                style: TextStyle(
                  fontSize: metrics.isSmallScreen ? 12 : 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: Text('refresh'.tr),
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCardSection(_ScreenMetrics metrics) {
    return _buildAdminCards(
        metrics.isSmallScreen, metrics.isVerySmallScreen, metrics.isLandscape);
  }

  Widget _buildRecentOrdersSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_defaultPadding),
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
            const SizedBox(height: _defaultPadding),
            _buildRecentOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsContent() {
    return _buildTopProducts();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // تحسين بطاقة لعرض إحصائيات الأرباح
  Widget _buildProfitDetailsCard(_ScreenMetrics metrics) {
    final profitStats = orderController.getProfitStats();
    final todaySales = profitStats['totalSales'] ?? 0.0;
    final todayProfit = profitStats['totalProfit'] ?? 0.0;
    final profitMargin = profitStats['profitMargin'] ?? 0.0;
    final orderCount = profitStats['orderCount'] ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم مع زر إعادة التعيين والتقارير
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.green,
                      size: metrics.isSmallScreen ? 20 : 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'today_statistics'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // زر لعرض تقارير المبيعات التفصيلية
                    IconButton(
                      icon: const Icon(Icons.insert_chart),
                      tooltip: 'reports'.tr,
                      onPressed: () => Get.to(() => const SalesReportScreen()),
                      color: Colors.blue[600],
                    ),
                    // زر إعادة ضبط الإحصائيات
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'reset_stats'.tr,
                      onPressed: () => _showResetStatsDialog(context),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),

            const Divider(),

            // بيانات الإحصائيات الرئيسية في صف واحد
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // المبيعات
                  _buildStatItem(
                    icon: Icons.shopping_cart,
                    iconColor: Colors.blue,
                    title: 'daily_sales'.tr,
                    value: '${todaySales.toStringAsFixed(3)} ${'currency'.tr}',
                  ),

                  // الأرباح
                  _buildStatItem(
                    icon: Icons.trending_up,
                    iconColor: Colors.green,
                    title: 'daily_profits'.tr,
                    value: '${todayProfit.toStringAsFixed(3)} ${'currency'.tr}',
                  ),

                  // عدد الطلبات
                  _buildStatItem(
                    icon: Icons.receipt_long,
                    iconColor: Colors.orange,
                    title: 'order_count'.tr,
                    value: orderCount.toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // هامش الربح مع مؤشر التقدم
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'profit_margin'.tr}:',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${profitMargin.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              profitMargin > 20 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // مؤشر هامش الربح
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: profitMargin / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        profitMargin > 20 ? Colors.green : Colors.orange,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // بطاقة إحصائيات المبيعات القابلة للنقر للانتقال إلى التقارير
            InkWell(
              onTap: () => Get.to(() => const SalesReportScreen()),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_chart,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'reports'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'view_detailed_reports'.tr,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء عنصر إحصائي
  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // تحسين بطاقة الطلبات الحالية
  Widget _buildOrderStatusCard(_ScreenMetrics metrics) {
    final pendingCount = orderController.getPendingOrders().length;
    final processingCount = orderController.getProcessingOrders().length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'current_orders'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryColor,
                  size: metrics.isSmallScreen ? 20 : 24,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // طلبات قيد الانتظار
            InkWell(
              onTap: () => Get.to(() => const OrderManagementScreen()),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'pending_orders'.tr + ':',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$pendingCount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: pendingCount > 0 ? Colors.orange : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    if (pendingCount > 0)
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // طلبات قيد التحضير
            InkWell(
              onTap: () => Get.to(() => const OrderManagementScreen()),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'processing_orders'.tr + ':',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$processingCount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: processingCount > 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    if (processingCount > 0)
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // زر الانتقال إلى إدارة الطلبات
            if (pendingCount > 0 || processingCount > 0)
              ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: Text('manage_orders'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(36),
                ),
                onPressed: () => Get.to(() => const OrderManagementScreen()),
              ),
          ],
        ),
      ),
    );
  }

  // استخدام مخطط المبيعات في لوحة التحكم
  Widget _buildSalesSection() {
    final salesData = _prepareSalesData();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'sales_overview'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SalesChart(data: salesData),
          ],
        ),
      ),
    );
  }

  // إضافة مخطط المبيعات حسب الفئة
  Widget _buildCategorySalesSection() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'category_sales'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CategorySalesChart(
              startDate: startOfMonth,
              endDate: now,
            ),
          ],
        ),
      ),
    );
  }

  // إضافة لوحة الطلبات المعلقة في لوحة التحكم
  Widget _buildPendingOrdersPanel() {
    return GetX<OrderController>(
      builder: (controller) {
        if (controller.pendingItems.isEmpty) {
          return const SizedBox.shrink();
        }

        // استخدام المكون الجاهز
        return const PendingOrdersPanel();
      },
    );
  }

  // استخدام منسق التاريخ لعرض التواريخ بشكل أنيق
  Widget _buildDateHeader() {
    final now = DateTime.now();
    return Text(
      DateFormatter.formatDateTime(now),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      ),
    );
  }

  // دالة جديدة لعرض تبويبات المخططات البيانية
  Widget _buildSaleChartTabs() {
    // استخدام ChartUtils لتجنب أخطاء fl_chart
    ChartUtils.getBoldTextOverride(context);

    return DefaultTabController(
      length: 2,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'sales_analysis'.tr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const TabBar(
                tabs: [
                  Tab(text: 'المنتجات الأكثر مبيعاً'),
                  Tab(text: 'المبيعات حسب الفئة'),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: TabBarView(
                  children: [
                    // تقرير المبيعات حسب المنتج
                    SalesChart(data: _prepareSalesData()),

                    // تقرير المبيعات حسب الفئة
                    CategorySalesChart(
                      startDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      endDate: DateTime.now(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SaleData> _prepareSalesData() {
    final stats = orderController.getDailyStats();
    final salesData = stats['topProducts'] as List? ?? [];

    return salesData.map((product) {
      return SaleData(
        name: product['name'] as String? ?? 'غير معروف',
        value: product['revenue'] as double? ?? 0.0,
      );
    }).toList();
  }

  Widget _buildDataCardsSection(_ScreenMetrics metrics) {
    final stats = orderController.getDailyStats();
    final profitStats = orderController.getProfitStats();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DataCard(
                  title: 'daily_sales'.tr,
                  value:
                      '${profitStats['totalSales']?.toStringAsFixed(3) ?? '0'} ${'currency'.tr}',
                  subtitle: '${stats['orderCount'] ?? '0'} ${'orders'.tr}',
                  icon: Icons.shopping_cart,
                  customColor: Colors.blue,
                  onTap: () => Get.to(() => const OrderHistoryScreen()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DataCard(
                  title: 'daily_profits'.tr,
                  value:
                      '${profitStats['totalProfit']?.toStringAsFixed(3) ?? '0'} ${'currency'.tr}',
                  subtitle:
                      'هامش: ${profitStats['profitMargin']?.toStringAsFixed(1) ?? '0'}%',
                  icon: Icons.trending_up,
                  customColor: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DataCard(
                  title: 'pending_orders'.tr,
                  value: '${orderController.getPendingOrders().length}',
                  icon: Icons.pending_actions,
                  customColor: Colors.orange,
                  onTap: () => Get.to(() => const OrderManagementScreen()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DataCard(
                  title: 'processing_orders'.tr,
                  value: '${orderController.getProcessingOrders().length}',
                  icon: Icons.local_cafe,
                  customColor: Colors.blue,
                  onTap: () => Get.to(() => const OrderManagementScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
