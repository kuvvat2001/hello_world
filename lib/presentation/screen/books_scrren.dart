import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Book {
  final String name;
  final String filePath;

  Book({required this.name, required this.filePath});
}

class BooksScreen extends StatelessWidget {
  final List<Book> books = [
    Book(
        name: "Kitap ismi 1", filePath: "assets/for_tests/lesson/lesson_4.pdf"),
    Book(
        name: "Kitap ismi 2", filePath: "assets/for_tests/lesson/lesson_5.pdf"),
    Book(
        name: "Kitap ismi 3", filePath: "assets/for_tests/lesson/lesson_6.pdf"),
    // Daha fazla kitap eklenebilir...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitaplar'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Colors.blue,
            margin: const EdgeInsets.all(4),
            elevation: 4,
            child: ListTile(
              title: Text(books[index].name, style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PDFViewerScreen(filePath: books[index].filePath, title:books[index].name,),
                  ),
                );
              },
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;

  PDFViewerScreen({required this.filePath,required this.title});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PdfViewerController _pdfViewerController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadPDF();
  }

  void _loadPDF() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.asset(widget.filePath,
              controller: _pdfViewerController),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
