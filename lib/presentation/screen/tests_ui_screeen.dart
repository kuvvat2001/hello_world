import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/domain/models/task_response_data.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/question_tests/equation_tests_screen.dart';
import 'package:math_app/presentation/utils/const.dart';

class TestsUiScreen extends StatefulWidget {
  const TestsUiScreen({
    super.key,
    required this.repository,
    required this.title,
    required this.pref,
  });
  final IRepository repository;
  final String title;
  final LocalStoreRepository pref;

  @override
  State<TestsUiScreen> createState() => _TestsUiScreenState();
}

class _TestsUiScreenState extends State<TestsUiScreen> {
  TaskResponse? data;

  @override
  void didChangeDependencies() {
    _init();
    log('didChangeDependencies');
    super.didChangeDependencies();
  }

  void _init() async {
    final repo = await widget.repository.getTasks();
    setState(() {
      data = repo;
    });

    log('$data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.blue,
        ),
        body: data != null
            ? ListView.builder(
                itemCount: isAllowedMore ? data!.data.length : 4,
                // Toplamda 4 tema
                itemBuilder: (BuildContext context, int index) => _LessonsItem(
                  index: index,
                  task: data!.data[index].task,
                  pref: widget.pref,
                  repository: widget.repository,
                ),

                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
              )
            : const Center(child: CircularProgressIndicator.adaptive()));
  }

  bool get isAllowedMore {
    final results = <Map<String, dynamic>>[];
    for (var i = 0; i < data!.data.take(4).length; i++) {
      if (widget.pref.checkKey('${AppConstants.kTestQuestion}$i')) {
        final savedData =
            widget.pref.getString('${AppConstants.kTestQuestion}$i');
        final parsed = jsonDecode(savedData) as Map<String, dynamic>;
        results.add(parsed);
      }
    }
    if (results.length < 4) return false;
    final result =
        results.every((e) => e.values.where((e) => e == true).length > 6);
    return result;
  }
}

class _LessonsItem extends StatelessWidget {
  const _LessonsItem({
    required this.index,
    required this.task,
    required this.pref,
    required this.repository,
  });
  final int index;
  final Task task;
  final LocalStoreRepository pref;
  final IRepository repository;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        onTap: () => _push(index, context),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.black,
        ),
      ),
    );
  }

  void _push(int index, BuildContext context) {
    Widget widget;
    if (index >= 0 && index <= 30) {
      widget = EquationTestsScreen(
        tests: task.tests,
        pref: pref,
        index: index,
        repository: repository,
      );
    } else {
      widget = Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(task.title)),
      );
    }
    _route(context: context, widget: widget);
  }

  Future<T?> _route<T>({
    required BuildContext context,
    required Widget widget,
  }) =>
      Navigator.push<T?>(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
      );

  List<Color> getColorList(int elementSayisi) {
    List<Color> colors = [];
    for (int i = 0; i < elementSayisi; i++) {
      colors.add(_getThemeColor(i));
    }
    return colors;
  }

  Color _getThemeColor(int index) {
    List<Color> colors = [Colors.white, Colors.white];
    return colors[index % colors.length];
  }
}
