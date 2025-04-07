import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';

class SalesChart extends StatefulWidget {
  final List<SaleData> data;

  const SalesChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  late final OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Get.find<OrderController>();

    // مراقبة التغييرات في الطلبات وتحديث المخطط
    ever(orderController.orders, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: widget.data
              .asMap()
              .entries
              .map((entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.value,
                        gradient: _barsGradient,
                        borderRadius: BorderRadius.circular(4),
                      )
                    ],
                    showingTooltipIndicators: [0],
                  ))
              .toList(),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: widget.data.isEmpty
              ? 100
              : widget.data
                      .map((e) => e.value)
                      .reduce((a, b) => a > b ? a : b) *
                  1.2,
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
            return BarTooltipItem(
              '${widget.data[group.x].name}\n',
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${rod.toY.toStringAsFixed(2)} د.ب',
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

  Widget getTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < widget.data.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: Text(
          widget.data[index].name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      );
    }
    return const SizedBox();
  }

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
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppTheme.primaryColor.withOpacity(0.7),
          AppTheme.primaryColor,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}

class SaleData {
  final String name;
  final double value;

  const SaleData({
    required this.name,
    required this.value,
  });
}
