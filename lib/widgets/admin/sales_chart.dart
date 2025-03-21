import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';

class SalesChart extends StatelessWidget {
  final List<SaleData> data;

  const SalesChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: data
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
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: data.isEmpty ? 100 : data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2,
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipPadding: EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              '${data[group.x].name}\n',
              TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${rod.toY.toStringAsFixed(2)} د.ب',
                  style: TextStyle(
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
    if (index >= 0 && index < data.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: Text(
          data[index].name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      );
    }
    return SizedBox();
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
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
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
