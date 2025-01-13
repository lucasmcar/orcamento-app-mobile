import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:orcamento_app/helper/database_helper.dart';

class EnviadoTab extends StatefulWidget {
  const EnviadoTab({super.key});

  @override
  State<EnviadoTab> createState() => _EnviadoTabState();
}

class _EnviadoTabState extends State<EnviadoTab> {

  Future<List<Map<String, Object?>>?> getPdfs() async {
    final result = await DatabaseHelper.instance.getPdfs();
    print(result);
    return result;
  }

  Future<void> deletePdf(int id) async{
    return await DatabaseHelper.instance.removePdf(id);
  }

  void openPdf(String path) {
    // Aqui você pode usar um pacote como `pdf_viewer` ou `open_file` para abrir o PDF
    PDFView(filePath: path); // Exemplo com `open_fil`
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>?>(
        future: getPdfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar PDFs"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum PDF salvo"));
          }

          final pdfs = snapshot.data!;
          return ListView.builder(
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              final id =   pdf['id'] as int;
              final name = pdf['name'] as String;
              final path = pdf['path'] as String;

              return  Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Borda arredondada
              ),
              elevation: 4, // Sombra para destacar o card
              child:ListTile(
                 onLongPress: () async {deletePdf(id);},
                title: Text(name),
                subtitle: Text(path),
                trailing: IconButton(
                  icon: Icon(Icons.open_in_new),
                  onPressed: () => openPdf(path),
                ),
              ));
            },
          );
        });
  }
}
