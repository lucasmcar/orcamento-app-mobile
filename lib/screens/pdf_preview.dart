import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreview extends StatelessWidget {
  final String pdfPath;

  const PdfPreview({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3,
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Visualização",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles([XFile((pdfPath))],
                    text: 'Segue o envio do orçamento');
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        onError: (error) {
          print(error.toString());
        },
        onRender: (pages) {
          print('Documento renderizado com $pages páginas.');
        },
        onPageError: (page, error) {
          print('Erro na página $page: $error');
        },
      ),
    );
  }
}
