import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/order.dart';

class CategorySalesChart extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const CategorySalesChart({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<CategorySalesChart> createState() => _CategorySalesChartState();
}

class _CategorySalesChartState extends State<CategorySalesChart> {
  final categoryController = Get.find<CategoryController>();
  final orderController = Get.find<OrderController>();
  Worker? _ordersWorker;

  // Cache for bar groups to avoid recursive calls
  List<BarChartGroupData>? _cachedBarGroups;
  double? _cachedMaxY;

  @override
  void initState() {
    super.initState();
    // Use worker instead of direct ever to avoid state issues
    _ordersWorker = ever(orderController.orders, (_) {
      if (mounted) {
        // Clear cache when orders change
        _cachedBarGroups = null;
        _cachedMaxY = null;
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(CategorySalesChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear cache when date range changes
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _cachedBarGroups = null;
      _cachedMaxY = null;
    }
  }

  @override
  void dispose() {
    _ordersWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'المبيعات حسب الفئة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GetX<CategoryController>(
                builder: (controller) {
                  final categories = controller.categories;
                  if (categories.isEmpty) {
                    return const Center(child: Text('لا توجد بيانات للعرض'));
                  }

                  // Clear cache when categories change
                  if (_cachedBarGroups == null) {
                    _createBarGroupsSafely();
                  }

                  return BarChart(
                    BarChartData(
                      barTouchData: barTouchData,
                      titlesData: titlesData,
                      borderData: borderData,
                      barGroups: _cachedBarGroups ?? [],
                      gridData: const FlGridData(show: false),
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _cachedMaxY ?? 100,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Safe version that doesn't cause recursion
  void _createBarGroupsSafely() {
    final categories = categoryController.categories;
    final orders = orderController.orders;

    // Prevent work if no data
    if (categories.isEmpty) {
      _cachedBarGroups = [];
      _cachedMaxY = 100.0;
      return;
    }

    // Calculate sales for each category - Step 1
    Map<String, double> categorySales = {};
    for (var category in categories) {
      categorySales[category.id] = 0;
    }

    // Aggregate sales - Step 2
    for (var order in orders) {
      // Apply date filter
      if (order.createdAt.isAfter(widget.startDate) &&
          order.createdAt
               .isBefore(widget.endDate.add(const Duration(days: 1))) &&
          order.status == OrderStatus.completed) {
        for (var item in order.items) {
          final product = orderController.findProductById(item.productId);
          if (product != null) {
            final categoryId = product.categoryId;
            if (categorySales.containsKey(categoryId)) {
              categorySales[categoryId] = (categorySales[categoryId] ?? 0) +
                  (item.price * item.quantity);
            }
          }
        }
      }
    }

    // Build bar groups with the calculated data - Step 3
    List<BarChartGroupData> barGroups = [];
    double maxY = 0.0;

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final sales = categorySales[category.id] ?? 0;

      // Track max value for Y axis
      if (sales > maxY) {
        maxY = sales;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: sales,
              color: _getBarColor(i),
              width: 20,
              borderRadius: BorderRadius.circular(2),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 100, // Temporary value, will be replaced
                color: Colors.grey.shade200,
              ),
            ),
          ],
        ),
      );
    }

    // Set the maxY with padding and ensure it's never 0
    _cachedMaxY = maxY > 0 ? maxY * 1.2 : 100;

    // Now update the groups with new rods that have correct background values
    for (int i = 0; i < barGroups.length; i++) {
      final group = barGroups[i];
      final List<BarChartRodData> newRods = [];

      for (var rod in group.barRods) {
        // Create a new rod with updated backDrawRodData
        newRods.add(BarChartRodData(
          toY: rod.toY,
          color: rod.color,
          width: rod.width,
          borderRadius: rod.borderRadius,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _cachedMaxY!,
            color: Colors.grey.shade200,
          ),
        ));
      }

      // Replace with new group containing updated rods
      barGroups[i] = BarChartGroupData(
        x: group.x,
        barRods: newRods,
      );
    }

    // Cache the result
    _cachedBarGroups = barGroups;
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            final categories = categoryController.categories;
            if (groupIndex >= categories.length) return null;

            Category? category = categoryController.findById(
              categories[groupIndex].id,
            );
            if (category == null) return null;

            return BarTooltipItem(
              '${category.name}\n',
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${rod.toY.toStringAsFixed(3)} د.ب',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final categories = categoryController.categories;
    final index = value.toInt();
    if (index >= 0 && index < categories.length) {
      Category? category = categoryController.findById(categories[index].id);
      if (category == null) return const SizedBox();
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: Text(
          category.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return const SizedBox();
  }

  Color _getBarColor(int index) {
    const colors = [
      AppTheme.primaryColor,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.indigo,
      Colors.pink,
    ];

    return colors[index % colors.length];
  }
}
