import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper/database_helper.dart';

Future<void> sharePdf(File filePath) async {
  final file = XFile(filePath.path);
  await Share.shareXFiles([file],
      text: 'Segue o envio do orçamento solicitado!');
}

Future<bool> requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    return true;
  } else {
    // Mostra uma mensagem caso o usuário negue
    print('Permissão negada');
    return false;
  }
}

Future<File> generatePdf({
  int? nOrcamento,
  String? logoPath,
  required String oficinaNome,
  required String oficinaEndereco,
  required String oficinaEmail,
  required String oficinaTelefone,
  required String oficinaCnpj,
  required String oficinaCidade,
  required String clienteNome,
  required String clienteTelefone,
  required String clienteEmail,
  required String clienteEndereco,
  required String veiculoModelo,
  required String veiculoMarca,
  required String veiculoCor,
  required String veiculoAno,
  required String veiculoPlaca,
  required List<Map<String, dynamic>> itens,
  required double totalPagamento,
  //required String apiUrl,
}) async {
  final pdf = pw.Document();

  // URL for approval
  //final approvalUrl = '$apiUrl/$generatedNOrcamento';

  final nOrcamento = Random();
  final generatedNOrcamento = 100000 + nOrcamento.nextInt(900000);

  // Gera um número entre 100000 e 999999
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Container(
            height: double.infinity,
            width: double.infinity,
            child: pw.Padding(
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(

                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [

                  //Cabeçalho
                        pw.Column(children: [
                            pw.Center(
                                child: pw.Text(oficinaNome.toUpperCase(),
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Row(

                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [pw.Text(oficinaEndereco)]),
                            pw.Row(

                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text("Telefone: $oficinaTelefone"),
                                  pw.SizedBox(
                                    height: 2
                                  ),
                                  pw.Text("Email:  $oficinaEmail"),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Text("CNPJ: $oficinaCnpj"),
                                ]),
                          pw.Divider(),
                          ]),
                  //Corpo
                  // Título do orçamento
                  pw.Center(
                    child: pw.Text(
                      'Orçamento',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Column(

                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [

                      // Informações do cliente

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text("Nº DO ORÇAMENTO - $generatedNOrcamento"),
                          ]),
                      pw.SizedBox(height: 16),
                      pw.Center(child: pw.Text('Informações do Cliente', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.SizedBox(height: 16),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Cliente: $clienteNome'),
                          pw.SizedBox(width: 10),
                          pw.Text('Contato: $clienteTelefone'),
                          pw.SizedBox(width: 10),
                          pw.Text('Email: ${clienteEmail ?? ""}'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [pw.Text('Endereço: $clienteEndereco'),]

                      ),

                      pw.SizedBox(height: 16),
                      // Informações do carro
                      pw.Center(child: pw.Text('Informações do Carro', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.SizedBox(height: 16),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Carro: $veiculoModelo'),
                          pw.SizedBox(width: 10),
                          pw.Text('Marca: $veiculoMarca'),
                          pw.SizedBox(width: 10),
                          pw.Text('Cor: $veiculoCor'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Ano: $veiculoAno'),
                          pw.SizedBox(width: 10),
                          pw.Text('Placa: $veiculoPlaca'),
                        ],
                      ),

                      pw.SizedBox(height: 16),
                      // Itens do orçamento
                      pw.Text('Itens do Orçamento:'),
                      pw.ListView.builder(
                        itemCount: itens.length,
                        itemBuilder: (context, index) {
                          final item = itens[index];
                          return pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Text(item['descricao'],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                              softWrap: true,
                              ),
                              pw.SizedBox(width: 10),
                              pw.Text(
                                NumberFormat.currency(
                                  locale: 'pt_BR',
                                  symbol: 'R\$',
                                ).format(item['preco']),
                              )
                            ],
                          );
                        },
                      ),
                      pw.SizedBox(height: 16),
                      // Valor total
                      pw.Text(
                          'Valor Total: ${NumberFormat.currency(
                            locale: 'pt_BR',
                            symbol: 'R\$',
                          ).format(totalPagamento)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 16),
                      pw.Row(children: [
                        pw.Text(
                            "$oficinaCidade, ${DateFormat("dd/MM/yyyy").format(DateTime.now())}"),
                      ])
                      // QR Code para aprovação
                      /*pw.Text('Aprovação:'),
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: generatedNOrcamento.toString(),
              width: 100,
              height: 100,
            ),*/
                      // Link para aprovação
                      //pw.Text(
                      //'Escaneie o QR Code ou clique no link para aprovar o orçamento:'),
                      //pw.UrlLink(
                      //child: pw.Text(
                      //approvalUrl,
                      //style: pw.TextStyle(color: PdfColors.blue),
                      //),
                      //destination: approvalUrl,
                      //),
                    ],
                  )
                  //Rodape
                ])));
      },
    ),
  );

  // Salvar ou compartilhar o PDF
  // Obter o diretório de documentos
  final output = await getApplicationDocumentsDirectory();
  final file =
      //File('${output.path}/orcamento_${DateTime.now().toIso8601String()}.pdf');
      File('${output.path}/orc-$generatedNOrcamento.pdf');
  savePdfToDatabase('orc-${generatedNOrcamento.toString()}.pdf', output.path);
  // Salvar o arquivo PDF
  await file.writeAsBytes(await pdf.save());
  return file;
}

Future<void> savePdfToDatabase(String name, String path) async {
  final pdf = {
    'name': name,
    'path': path,
    'createdAT': DateTime.now().toIso8601String(),
  };
  await DatabaseHelper.instance.insertPdf(pdf);
}
