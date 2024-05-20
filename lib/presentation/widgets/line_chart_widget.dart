import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  final List<int> correctAnswers;
  final List<int> wrongAnswers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _getSpots(correctAnswers),
              isCurved: true,
              color: Colors.green,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: _getSpots(wrongAnswers),
              isCurved: true,
              color: Colors.red,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < correctAnswers.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4,
                      child: Transform.rotate(
                        angle: -45 * 3.1415927 / 180,
                        child: Text('Test ${index + 1}', style: const TextStyle(fontSize: 10)),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                reservedSize: 50,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4,
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
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
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getSpots(List<int> answers) {
    return answers
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();
  }
}
