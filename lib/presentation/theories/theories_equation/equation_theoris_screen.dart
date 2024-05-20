import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EquationLessonsScreen extends StatefulWidget {
  final String? books;
  final String title;

  const EquationLessonsScreen({
    Key? key,
    required this.title,
    this.books,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EquationLessonsScreenState createState() => _EquationLessonsScreenState();
}

class _EquationLessonsScreenState extends State<EquationLessonsScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.asset(
              widget.books ?? '',
              canShowScrollHead: false,

              // Eğer null ise boş string atanıyor.
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Widget oluşturulduğunda PDF dosyasını yükleme işlemi yapılıyor.
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    if (widget.books != null && widget.books!.isNotEmpty) {
      // PDF dosyasının yolu mevcut ve boş değilse isLoading false olarak ayarlanıyor.
      setState(() {
        isLoading = false;
      });
    }
  }
}
