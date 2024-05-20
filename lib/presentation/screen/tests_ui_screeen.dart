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
    Key? key,
    required this.repository,
    required this.title,
    required this.pref,
  }) : super(key: key);

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

  void refresh() {
    _init(); // Verileri yeniden yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: data != null
          ? ListView.builder(
              itemCount: data!.data.length,
              itemBuilder: (BuildContext context, int index) => _LessonsItem(
                index: index,
                task: data!.data[index].task,
                pref: widget.pref,
                repository: widget.repository,
                isUnlocked: _isUnlocked(index),
                refreshParent: refresh, // Ebeveyn yenileme fonksiyonunu geçiriyoruz
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
            )
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  bool _isUnlocked(int index) {
    if (index < 4) {
      // İlk dört test her zaman açıktır
      return true;
    } else {
      // Diğer testler için kontrol
      int previousIndex = index - 1;
      int requiredCorrectAnswers = 6; // Her bir bölüm için gerekli doğru cevap sayısı
      while (previousIndex >= 3) {
        final result = _result(previousIndex);
        if (result.correct < requiredCorrectAnswers) {
          // Önceki bölümde gerekli sayıda doğru cevap alınmadıysa, kilidini açamaz
          return false;
        }
        previousIndex--;
      }
      // Önceki bölümlerde gerekli sayıda doğru cevap alındıysa, bu bölümün kilidi açılır
      return true;
    }
  }

  ({int correct, int fail}) _result(int i) {
    if (widget.pref.checkKey('${AppConstants.kTestQuestion}$i')) {
      final savedData = widget.pref.getString('${AppConstants.kTestQuestion}$i');
      final parsed = jsonDecode(savedData) as Map<String, dynamic>;
      final len = parsed.values.where((e) => e == true).length;
      return (correct: len, fail: 10 - len);
    } else {
      return (correct: 0, fail: 0);
    }
  }
}

class _LessonsItem extends StatefulWidget {
  const _LessonsItem({
    required this.index,
    required this.task,
    required this.pref,
    required this.repository,
    required this.isUnlocked,
    required this.refreshParent, // Ebeveyn yenileme fonksiyonunu ekliyoruz
  });

  final int index;
  final Task task;
  final LocalStoreRepository pref;
  final IRepository repository;
  final bool isUnlocked;
  final VoidCallback refreshParent; // Geri çağırma fonksiyonunu tanımlıyoruz

  @override
  State<_LessonsItem> createState() => _LessonsItemState();
}

class _LessonsItemState extends State<_LessonsItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.task.title),
        onTap: () {
          if (!widget.isUnlocked) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${widget.task.title} bölüm ýapyk.'),
            ));
          } else {
            _push(widget.index, context);
          }
        },
        trailing: widget.isUnlocked
            ? const Icon(Icons.lock_open)
            : const Icon(Icons.lock),
      ),
    );
  }

  void _push(int index, BuildContext context) async {
    Widget w;
    if (index >= 0 && index <= 30) {
      w = EquationTestsScreen(
        tests: widget.task.tests,
        pref: widget.pref,
        index: index,
        repository: widget.repository,
        title: widget.task.title,
      );
    } else {
      w = Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(widget.task.title)),
      );
    }
    final routeResult = await _route<bool>(context: context, widget: w);
    if (routeResult != null && routeResult) {
      // Geri döndüğünde ebeveyn ekranı yenilemek için refreshParent fonksiyonunu çağır
      widget.refreshParent();
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
}
