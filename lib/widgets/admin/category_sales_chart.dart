import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/category.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المبيعات حسب الفئة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: _createBarGroups(),
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            Category? category = categoryController.findById(
              categoryController.categories[group.x].id,
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
        leftTitles:  AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles:  AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
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

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> _createBarGroups() {
    final categories = categoryController.categories;
    final orders = orderController.getOrdersByDateRange(widget.startDate, widget.endDate);

    return categories.asMap().entries.map((entry) {
      final categoryId = entry.value.id;
      double totalRevenue = 0;

      for (final order in orders) {
        for (final item in order.items) {
          final product = categoryController.findById(categoryId);
          if (product != null) {
            totalRevenue += item.price * item.quantity;
          }
        }
      }

      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: totalRevenue,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.7),
                AppTheme.primaryColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
