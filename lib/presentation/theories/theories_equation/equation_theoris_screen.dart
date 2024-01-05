import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_app/presentation/theories/theories_equation/equatin_topic.dart';

class EquationScreen extends StatelessWidget {
  const EquationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Deňlelemler we Deňsizlikler'),
      ),
      body: FutureBuilder(
        future: loadMathTopics(),
        builder: (context, AsyncSnapshot<List<MathTopic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: MathTopicCard(topic: snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<MathTopic>> loadMathTopics() async {
    String jsonString = await rootBundle.loadString('assets/math_topics.json');
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => MathTopic.fromJson(json)).toList();
  }
}
