import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsBarChart extends StatelessWidget {
  const AnalyticsBarChart({super.key, required this.items});
  final List<int> items;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24).copyWith(bottom: 12),
            child: const Text(
              "Netijeler",
              style: TextStyle(fontSize: 26),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: items.isEmpty
                ? const Center(child: Text('---'))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final barsSpace = 10.0 * constraints.maxWidth / 200;
                        final barsWidth = 10.0 * constraints.maxWidth / _width;
                        return BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.center,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < items.length) {
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 4, // Aradaki boşluk
                                        child: Transform.rotate(
                                          angle: -45 * 3.1415927 / 180,
                                          child: Text('Test ${index + 1}', style: const TextStyle(fontSize: 10)),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                  reservedSize: 50, // Yeterli boşluk sağlanır
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) =>
                                      rightTitles(value, meta, context),
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              verticalInterval: items.length > 0 ? (items.length / items.length) : 1, // Dikey aralığı dinamik olarak ayarla
                              getDrawingHorizontalLine: (value) => const FlLine(
                                color: Colors.grey,
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (value) => const FlLine(
                                color: Colors.grey,
                                strokeWidth: 1,
                              ),
                              drawHorizontalLine: true,
                              drawVerticalLine: true,
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                top: BorderSide(color: Colors.grey),
                              ),
                            ),
                            groupsSpace: barsSpace,
                            barGroups: List.generate(
                              items.length,
                              (i) => makeGroupData(
                                i,
                                items[i].toDouble(),
                                barsWidth,
                                barsSpace,
                                context,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      );

  Widget rightTitles(double value, TitleMeta meta, BuildContext context) {
    Widget axisTitles = Text(
      (num.tryParse(meta.formattedValue) ?? 0) is int
          ? meta.formattedValue
          : '',
    );
    if (value == meta.max) {
      final remainder = value % meta.appliedInterval;
      if (remainder != 0.0 && remainder / meta.appliedInterval < 0.5) {
        axisTitles = const SizedBox.shrink();
      }
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: axisTitles);
  }

  double get _width => switch (items.length) {
        < 7 && > 4 => 150,
        > 10 => 300,
        < 4 => 50,
        _ => 200,
      };

  BarChartGroupData makeGroupData(int x, double y, double barsWidth,
          double barsSpace, BuildContext context) =>
      BarChartGroupData(
        x: x,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: y,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            width: barsWidth,
            color: Colors.blueAccent,
          ),
        ],
      );
}
