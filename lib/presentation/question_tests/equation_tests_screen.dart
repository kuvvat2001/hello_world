import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:math_app/domain/models/task_response_data.dart';
import 'package:math_app/presentation/widgets/app_confeti_widget.dart';


class EquationTestsScreen extends StatefulWidget {
  const EquationTestsScreen({super.key, required this.tests});
  final List<Test> tests;

  @override
  // ignore: library_private_types_in_public_api
  _EquationTestsScreenState createState() => _EquationTestsScreenState();
}

class _EquationTestsScreenState extends State<EquationTestsScreen> {
  late ConfettiController _controllerCenter;

  int currentQuestionIndex = 0;
  int selectedChoiceIndex = -1;
  bool isWritingBoardOpen = false;
  GlobalKey<SignatureState> signatureKey = GlobalKey();
  List<bool> answers = [];
  void checkAnswer(int choiceIndex) {
    setState(() {
      selectedChoiceIndex = choiceIndex;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < widget.tests.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedChoiceIndex =
              -1; // Reset selected answer when moving to the next question
        });
      }
    });
  }



  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = widget.tests.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
        child: Stack(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator.adaptive())
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text('${currentQuestionIndex + 1}/${widget.tests.length}'),
                  const SizedBox(height: 20),
                  AppConfettiwidget(controllerCenter: _controllerCenter),
                  Text(
                    widget.tests.isEmpty
                        ? 'Sorular yükleniyor...'
                        : widget.tests[currentQuestionIndex].question,
                    style: const TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Math.tex(
                    widget.tests.isEmpty
                        ? 'Sorular yükleniyor...'
                        : widget.tests[currentQuestionIndex].formula ?? "",
                    textStyle: const TextStyle(fontSize: 20.0),
                    mathStyle: MathStyle.text,
                  ),
                  const Spacer(),
                  if (widget.tests[currentQuestionIndex].photo != null)
                    Image.asset(
                      widget.tests.isEmpty
                          ? 'Sorular yükleniyor...'
                          : widget.tests[currentQuestionIndex].photo ?? "",
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  const Spacer(),
                  Column(children: [
                    if (widget.tests.isEmpty)
                      const Text('Sorular yükleniyor...')
                    else
                      ...List.generate(
                        widget.tests[currentQuestionIndex].choices.length,
                        (index) {
                          final e =
                              widget.tests[currentQuestionIndex].choices[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            title: Math.tex(e.text),
                            onTap: isWritingBoardOpen
                                ? null
                                : () {
                                    if (selectedChoiceIndex == -1) {
                                      checkAnswer(index);
                                    }
                                    _handler(e);
                                  },
                            splashColor:
                                e.isCorrect ? Colors.green : Colors.red,
                          );
                        },
                      )
                  ]),
                ],
              ),
            if (isWritingBoardOpen)
              Signature(
                color: Colors.black,
                strokeWidth: 3.0,
                backgroundPainter: null,
                key: signatureKey,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isWritingBoardOpen = !isWritingBoardOpen;
          });
        },
        child: Icon(isWritingBoardOpen ? Icons.close : Icons.create),
      ),
    );
  }

  void _handler(Choice e) {
    if (widget.tests.length == (currentQuestionIndex + 1)) {
      final score = answers.where((e) => e == true).length+1;

      if (score < 6) {
        Future.delayed(
            const Duration(seconds: 2),
            () => _showActionSheett(context,
                'Siz 10 soragdan $score-sini bildiniz, täzeden synanyşmagyňyzy maslahat berýäris'));
      } else {
        _controllerCenter.play();
        Future.delayed(const Duration(seconds: 2),
            () => _showActionSheet(context, 'Dogry jogap: $score'));
      }
    } else {
      // tracker how many true answers added
      answers.add(e.isCorrect);
    }
  }

  void _showActionSheet(BuildContext context, String msg) =>
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Synagy geçdiňiz'),
          message: Text(msg),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yza çyk'),
            ),
          ],
        ),
      );

  void _showActionSheett(BuildContext context, String msg) =>
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Synagy geçmediňiz'),
          message: Text(msg),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Täzden synanyşyň'),
            ),
          ],
        ),
      );

  String split(bool istext) {
    final splited = widget.tests[currentQuestionIndex].question.split(",");
    if (istext) {
      final text = splited[0];
      return text;
    } else {
      final formula = splited[1];
      return formula;
    }
  }
}
