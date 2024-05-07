import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:math_app/domain/models/task_response_data.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/theories/theories_equation/equation_theoris_screen.dart';

class LessonsUiScreen extends StatefulWidget {
  const LessonsUiScreen({
    super.key,
    required this.repository,
    required this.title,
  });
  final IRepository repository;
  final String title;


  @override
  State<LessonsUiScreen> createState() => _LessonsUiScreenState();
}

class _LessonsUiScreenState extends State<LessonsUiScreen> {
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
          title: const Text("Sapaklar"),
          backgroundColor: Colors.blue,
        ),
        body: data != null
            ? ListView.builder(
              shrinkWrap: true,
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
        title:  Text(task.title),
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
    widget = EquationLessonsScreen(books:task.books,);
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

}
