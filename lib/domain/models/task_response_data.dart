// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

TaskResponse taskResponseFromJson(String str) =>
    TaskResponse.fromJson(json.decode(str));

String taskResponseToJson(TaskResponse data) => json.encode(data.toJson());

class TaskResponse {
  final List<Datum> data;

  TaskResponse({
    required this.data,
  });

  TaskResponse copyWith({
    List<Datum>? data,
  }) =>
      TaskResponse(
        data: data ?? this.data,
      );

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
  @override
  String toString() => 'TaskResponse(data: $data)';
}

class Datum {
  final Task task;

  Datum({
    required this.task,
  });

  Datum copyWith({
    Task? task,
  }) =>
      Datum(
        task: task ?? this.task,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        task: Task.fromJson(json["task"]),
      );

  Map<String, dynamic> toJson() => {
        "task": task.toJson(),
      };
  @override
  String toString() => 'Datum(task: $task)';
}

class Task {
  final String title;
  final List<Test> tests;
  final String books;

  Task({
    required this.title,
    required this.tests,
    required this.books,
  });

  Task copyWith({
    String? title,
    List<Test>? tests,
    String? books,
  }) =>
      Task(
        title: title ?? this.title,
        tests: tests ?? this.tests,
        books: books ?? this.books,
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json["title"],
        books: json["books"],
        tests: List<Test>.from(json["tests"].map((x) => Test.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "books": books,
        "tests": List<dynamic>.from(tests.map((x) => x.toJson())),
        
      };

  @override
  String toString() => 'Task(title: $title, tests: $tests,books: $books)';
}

class Test {
  final String? photo;
  final String? formula;
  final String question;
  final List<Choice> choices;
  int correctIndex;


  Test({
    required this.photo,
    required this.formula,
    required this.question,
    required this.choices,
    this.correctIndex=-1,
  });

  Test copyWith({
    String? photo,
    String? formula,
    String? question,
    List<Choice>? choices,
  }) =>
      Test(
        photo: photo ?? this.photo,
        formula: formula ?? this.formula,
        question: question ?? this.question,
        choices: choices ?? this.choices,
      );

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        formula: json["formula"],
        photo: json["photo"],
        question: json["question"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "photo": photo,
        "formula": formula,
        "question": question,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      };

  @override
  String toString() =>
      'Test(question: $question, formula: $formula,photo: $photo,choices: $choices, )';
}

class Choice {
  final String text;
  final bool isCorrect;

  Choice({
    required this.text,
    required this.isCorrect,
  });

  Choice copyWith({
    String? text,
    bool? isCorrect,
  }) =>
      Choice(
        text: text ?? this.text,
        isCorrect: isCorrect ?? this.isCorrect,
      );

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        text: json["text"],
        isCorrect: json["isCorrect"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isCorrect": isCorrect,
      };

  @override
  String toString() => 'Choice(text: $text, isCorrect: $isCorrect)';
}
