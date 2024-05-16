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
                                  //reservedSize: 28,
                                  // interval: _interval,
                                  getTitlesWidget: bottomTitleWidgets,
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
                              verticalInterval: 0.1,
                              //checkToShowHorizontalLine: (value) => value % 10 == 0,
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // uytgedip bilersin
    final s = switch (value.toInt()) {
      0 => 'Test 1',
      1 => 'Test 2',
      2 => 'Test 3',
      3 => 'Test 4',
      4 => 'Test 5',
      5 => 'Test 6',
      6 => 'Test 7',
      7 => 'Test 8',
      8 => 'Test 9',
      9 => 'Test 10',
      10 => 'Test 11',
      11 => 'Test 12',
      _ => '',
    };
    return Text(s, style: const TextStyle(fontSize: 10));
  }

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
