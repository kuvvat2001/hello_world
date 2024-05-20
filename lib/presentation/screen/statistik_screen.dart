import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/utils/const.dart';
import 'package:math_app/presentation/widgets/analytics_bar_chart.dart';
import 'package:math_app/presentation/widgets/line_chart_widget.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({
    super.key,
    required this.repository,
    required this.pref,
  });
  final IRepository repository;
  final LocalStoreRepository pref;

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final List<int> correctAnswers = [];
  final List<int> wrongAnswers = [];
  bool isLoading = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });

    final data = await widget.repository.getTasks();
    for (var i = 0; i < data.data.length; i++) {
      if (widget.pref.checkKey('${AppConstants.kTestQuestion}$i')) {
        final savedData =
            widget.pref.getString('${AppConstants.kTestQuestion}$i');
        final parsed = jsonDecode(savedData) as Map<String, dynamic>;
        final correctCount = parsed.values.where((e) => e == true).length;
        final wrongCount = parsed.values.where((e) => e == false).length;
        correctAnswers.add(correctCount);
        wrongAnswers.add(wrongCount);
      } else {
        correctAnswers.add(0); // Test sonucu yoksa 0 ekleyin
        wrongAnswers.add(0); // Test sonucu yoksa 0 ekleyin
      }
    }
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text("Statistikalar"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Analytics Bar Chart",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  AnalyticsBarChart(items: correctAnswers),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Line Chart",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 300, // Yeterli yükseklik ayarlayalım
                    child: LineChartWidget(correctAnswers: correctAnswers, wrongAnswers: wrongAnswers),
                  ),
                ],
              ),
            ),
    );
  }
}
