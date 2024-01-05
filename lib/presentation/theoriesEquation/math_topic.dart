import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
class MathTopic {
  final String string;
  final String title;
  final String formula;
  final String imageUrl;

  MathTopic({
    required this.string,
    required this.title,
    required this.formula,
    required this.imageUrl,
  });

  factory MathTopic.fromJson(Map<String, dynamic> json) {
    return MathTopic(
      string: json['string'],
      title: json['title'],
      formula: json['formula'],
      imageUrl:json['imageUrl'],
    );
  }
}

class MathTopicCard extends StatelessWidget {
  final MathTopic topic;

  const MathTopicCard({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              topic.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            topic.string,
            style: const TextStyle(fontSize: 14),
          ),
         const Text("Kesgitleme. Üýtgeýän. ululygyň denlemäni dogry deňlige öwürýän bahasyna deňlemäniň köki diýilýär.",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
           const Text("Meselem, " ),
           const Text("(x-2)(x-3)=0",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
           const Text("deňlemäniň iki köki bardyr: , 2 we 3. Sebäbi, x=2 we x=3 bolanda bu deňleme dogry I deňlige öwrülýär. x-iň beýleki bahalarynda deňlemäniň çep bölegi 0-a deň däldir."),
          const SizedBox(height: 10),
           Center(
             child: Math.tex(
             r"(x-2)(x-3)=0",
             mathStyle: MathStyle.display,
           textStyle: const TextStyle(fontSize: 24.0, color: Colors.black),
                     ),
           ),
          const SizedBox(height: 10),
          Image.asset(topic.imageUrl),
          Text(
            topic.string,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
