import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PdfReader extends StatefulWidget {
  final String pdfFile;
  final String title;

  const PdfReader({Key? key, required this.pdfFile, required this.title})
      : super(key: key);

  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  PDFDocument? doc;
  void initPdf() async {
    doc = await PDFDocument.fromURL(widget.pdfFile);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF129575),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Iconsax.arrow_left_24,
            color: Colors.white,
          ),
        ),
      ),
      body: doc != null
          ? PDFViewer(document: doc!)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
