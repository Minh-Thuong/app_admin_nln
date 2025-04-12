import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildSalesChart(List<FlSpot> salesSpots) {
  double maxYValue = salesSpots.isNotEmpty
      ? salesSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
      : 0;
  maxYValue = maxYValue * 1.1;

  // Đảm bảo horizontalInterval không phải 0
  double horizontalInterval = maxYValue > 0 ? maxYValue / 5 : 1;
  // Đảm bảo interval không phải 0
  double interval = maxYValue > 0 ? maxYValue / 5 : 1;
  return LineChart(
    LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: horizontalInterval,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey[300]!,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey[300]!,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
              int index = value.toInt();
              return index >= 0 && index < days.length
                  ? Text(days[index], style: TextStyle(fontSize: 12))
                  : const Text('');
            },
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            getTitlesWidget: (value, meta) => Text(
              '${(value / 1000).toInt()}k',
              style: const TextStyle(fontSize: 10),
            ),
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: maxYValue,
      lineBarsData: [
        LineChartBarData(
          spots: salesSpots,
          isCurved: false,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 3,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: Colors.blue,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withValues(alpha: 0.2),
          ),
        ),
      ],
    ),
  );
}
