import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:math_app/domain/models/task_response_data.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/question_tests/equation_tests_screen.dart';

class TestsUiScreen extends StatefulWidget {
  const TestsUiScreen({
    super.key,
    required this.repository,
    required this.title,
  });
  final IRepository repository;
  final String title;

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
                itemCount: data!.data.length,
                // Toplamda 4 tema
                itemBuilder: (BuildContext context, int index) =>
                    _LessonsItem(index, data!.data[index].task),

                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
              )
            : const Center(child: CircularProgressIndicator.adaptive()));
  }
}

class _LessonsItem extends StatelessWidget {
  const _LessonsItem(this.index, this.task);
  final int index;
  final Task task;

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
    widget = EquationTestsScreen(tests: task.tests);
  } else {
    widget = Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(task.title)),
    );
  }
  _route(context: context, widget: widget);
}

  Future<T?> _route<T>(
          {required BuildContext context, required Widget widget}) =>
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
