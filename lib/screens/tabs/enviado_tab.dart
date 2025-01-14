import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orcamento_app/helper/database_helper.dart';

import '../pdf_preview.dart';

class EnviadoTab extends StatefulWidget {
  const EnviadoTab({super.key});

  @override
  State<EnviadoTab> createState() => _EnviadoTabState();
}

class _EnviadoTabState extends State<EnviadoTab> {
  bool _isLoading = false;
  Future<List<Map<String, Object?>>?> getPdfs() async {
    final result = await DatabaseHelper.instance.getPdfs();
    print(result);
    return result;
  }

  Future<void> deletePdf(int id) async {
    return await DatabaseHelper.instance.removePdf(id);
  }

  void openPdf(String path) {
    print(path);
    // OpenFile.open(path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreview(pdfPath: path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator()) // Loading global
        : FutureBuilder<List<Map<String, Object?>>?>(
            future: getPdfs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Erro ao carregar PDFs"));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text("Nenhum PDF salvo"));
              }

              final pdfs = snapshot.data!;
              return ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: (context, index) {
                  final pdf = pdfs[index];
                  final id = pdf['id'] as int;
                  final name = pdf['name'] as String;
                  final path = pdf['path'] as String;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Borda arredondada
                    ),
                    elevation: 4, // Sombra para destacar o card
                    child: ListTile(
                      onLongPress: () => _showDeleteConfirmationDialog(id),
                      title: Text(name),
                      subtitle: Text(path),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {
                          openPdf("$path/Orcamentos/$name");
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirmar exclusão",
          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16)),
        ),
        content: Text("Tem certeza que deseja excluir este PDF?",
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancelar
            child: Text("Cancelar",
                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16))),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirmar
            child: Text("Excluir",
                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Mostra o loading enquanto deleta
      setState(() => _isLoading = true);

      // Chama o método deletePdf para realizar a exclusão
      await deletePdf(id);

      // Recarrega a lista de PDFs para refletir as alterações
      await getPdfs();

      // Oculta o loading
      setState(() => _isLoading = false);
    }
  }
}
