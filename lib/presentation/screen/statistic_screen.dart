import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/utils/const.dart';
import 'package:math_app/presentation/widgets/chart_widget.dart';

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
  final List<int> _listValue = [];
  bool isLoading = false;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    isLoading = true;
    final data = await widget.repository.getTasks();
    for (var i = 0; i < data.data.length; i++) {
      if (widget.pref.checkKey('${AppConstants.kTestQuestion}$i')) {
        final savedData =
            widget.pref.getString('${AppConstants.kTestQuestion}$i');
        final parsed = jsonDecode(savedData) as Map<String, dynamic>;
        _listValue.add(parsed.values.where((e) => e == true).length);
      }
      setState(() {});
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : AnalyticsBarChart(items: _listValue),
    );
  }
}
