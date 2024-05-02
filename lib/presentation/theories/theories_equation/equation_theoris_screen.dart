import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class EquationLessonsScreen extends StatefulWidget {
  const EquationLessonsScreen({super.key, required this.books});
  final String? books;

  @override
  // ignore: library_private_types_in_public_api
  _EquationLessonsScreenState createState() => _EquationLessonsScreenState();
}

class _EquationLessonsScreenState extends State<EquationLessonsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = widget.books != null && widget.books!.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
        child: Column(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator.adaptive())
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.books != null)
                    SizedBox(
                      height: 200,
                      child: PDFView(
                        filePath: "assets/for_tests/ALGEBRA.pdf",
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
