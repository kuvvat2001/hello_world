import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/domain/models/task_response_data.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/utils/const.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.repository,
    required this.title,
    required this.pref,
  });
  final IRepository repository;
  final String title;
  final LocalStoreRepository pref;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
                itemBuilder: (BuildContext context, int index) => _ResultItem(
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

class _ResultItem extends StatefulWidget {
  const _ResultItem({
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
  State<_ResultItem> createState() => _ResultItemState();
}

class _ResultItemState extends State<_ResultItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.task.title),
        onTap: () {
          if (_result(widget.index).correct > 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Siziň ${_result(widget.index).correct} dogryňyz ${_result(widget.index).fail} ýalňyşyňyz bar',
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Siz bu bölümi geçmediňiz",
                style: TextStyle(color: Colors.red, fontSize: 17),
              ),
            ));
          }
        },
        trailing: _result(widget.index).correct > 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_result(widget.index).correct}',
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_result(widget.index).fail}',
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  )
                ],
              )
            : const Icon(
                Icons.radio_button_unchecked_outlined,
                color: Colors.red,
              ),
      ),
    );
  }

  ({int correct, int fail}) _result(int i) {
    if (widget.pref.checkKey('${AppConstants.kTestQuestion}$i')) {
      final savedData =
          widget.pref.getString('${AppConstants.kTestQuestion}$i');
      final parsed = jsonDecode(savedData) as Map<String, dynamic>;
      final len = parsed.values.where((e) => e == true).length;
      return (correct: len, fail: 10 - len);
    } else {
      return (correct: 0, fail: 0);
    }
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
