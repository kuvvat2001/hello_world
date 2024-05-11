import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_app/domain/models/task_response_data.dart';

class ResultScreen extends StatefulWidget {
  final List<Test> tests;

  const ResultScreen({Key? key, required this.tests}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<bool?> testResults = [];

  @override
  void initState() {
    super.initState();
    loadTestResults();
  }

  void loadTestResults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < widget.tests.length; i++) {
        bool? result = prefs.getBool('test_$i');
        testResults.add(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: widget.tests.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Test ${index + 1}'),
            subtitle: testResults.isNotEmpty && testResults[index] != null
                ? testResults[index]!
                    ? Text('Correct')
                    : Text('Incorrect')
                : Text('No result yet'),
          );
        },
      ),
    );
  }
}
