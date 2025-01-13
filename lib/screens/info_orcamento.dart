import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:orcamento_app/helper/database_helper.dart';
import 'package:orcamento_app/models/empresa.dart';
import 'package:orcamento_app/screens/pdf_page.dart';
import 'package:orcamento_app/screens/pdf_preview.dart';
import 'package:permission_handler/permission_handler.dart';

class InfoOrcamento extends StatefulWidget {
  const InfoOrcamento({super.key});

  @override
  State<InfoOrcamento> createState() => _InfoOrcamentoState();
}

class _InfoOrcamentoState extends State<InfoOrcamento> {
  final List<Map<String, dynamic>> _itens = [];
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
  double _totalPagamento = 0.0;

  final GlobalKey<FormState> _infoKey = GlobalKey<FormState>();
  int _currentStep = 0;

  //Dados do cliente
  final TextEditingController _clienteNomeController = TextEditingController();
  final TextEditingController _clienteEmailController = TextEditingController();
  final TextEditingController _clienteEnderecoController =
      TextEditingController();
  final TextEditingController _clienteTelefoneController =
      TextEditingController();

  //Dados do veiculo
  final TextEditingController _veiculoMarcaController = TextEditingController();
  final TextEditingController _veiculoModeloController =
      TextEditingController();
  final TextEditingController _veiculoAnoController = TextEditingController();
  final TextEditingController _veiculoPlacaController = TextEditingController();
  final TextEditingController _veiculoCorController = TextEditingController();

  //Descriçao orçamento
  final TextEditingController _itemDescricaoController =
      TextEditingController();
  final TextEditingController _itemPrecoController = TextEditingController();

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####', // Formato do telefone
    filter: {"#": RegExp(r'[0-9]')}, // Permitir apenas números
  );

  final _placaMaskFormatter = MaskTextInputFormatter(mask: '###-####');

  Empresa? empresa;
  // Função para carregar os dados da oficina
  Future<void> loadEmpresaData() async {
    final empresaData = await DatabaseHelper.instance.getEmpresa();
    if (empresaData != null) {
      setState(() {
        empresa = Empresa.fromMap(
            empresaData.map((key, value) => MapEntry(key, value.toString())));
      });
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID (substitua pelo seu)
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd.load();
  }



  // Solicitar permissão para acessar o armazenamento
  Future<bool> _requestStoragePermission() async {
    final status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Abre as configurações para o usuário ativar a permissão manualmente
      openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permissão de armazenamento negada.")),
      );
      return false;
    }
    return false; // Ensure a boolean is always returned
  }

  // Método para gerar o PDF e salvar no dispositivo
  Future<void> _generateAndSavePDF(BuildContext context) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    // Continue com a geração do PDF
    final pdfPath = await generatePdf(
      oficinaNome: (empresa)?.nome ?? '',
      oficinaEndereco: (empresa)?.endereco ?? '',
      oficinaTelefone: (empresa)?.telefone ?? '',
      oficinaCnpj: (empresa)?.cnpj ?? '',
      oficinaEmail: (empresa)?.email ?? '',
      oficinaCidade: (empresa)?.cidade ?? '',
      clienteNome: _clienteNomeController.text,
      clienteTelefone: _clienteTelefoneController.text,
      clienteEndereco: _clienteEnderecoController.text,
      clienteEmail: _clienteEmailController.text,
      veiculoModelo: _veiculoModeloController.text,
      veiculoMarca: _veiculoMarcaController.text,
      veiculoCor: _veiculoCorController.text,
      veiculoAno: _veiculoAnoController.text,
      veiculoPlaca: _veiculoPlacaController.text,
      itens: _itens,
      totalPagamento: _totalPagamento,
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfPreview(pdfPath: pdfPath.path)));

    // Mostra feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Orçamento salvo em $pdfPath!")),
    );



    // Opcional: Compartilhar o PDF
    //sharePdf(pdfPath);
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    loadEmpresaData(); // Carregar os dados da oficina assim que a página for carregada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar Orçamento',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: _infoKey,
              child: Expanded(
                child: Stepper(
                  controlsBuilder: controlsBuilder,
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 3) {
                      setState(() {
                        _currentStep++;
                      });
                    } /*else {
                      _generateAndSavePDF();
                    }*/
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  steps: [
                    Step(
                        stepStyle: StepStyle(connectorColor: Colors.deepPurple),
                        isActive: _currentStep >= 0,
                        title: Icon(Icons.person),
                        content: Column(
                          children: [
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Nome obrigatório' : null,
                              controller: _clienteNomeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Nome do cliente"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? 'Endereço obrigatório'
                                  : null,
                              controller: _clienteEnderecoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Endereço"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Email obrigatório' : null,
                              controller: _clienteEmailController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Email"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              inputFormatters: [_phoneMaskFormatter],
                              validator: (value) => value!.isEmpty
                                  ? 'Telefone obrigatório'
                                  : null,
                              controller: _clienteTelefoneController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Telefone"),
                            ),
                          ],
                        )),
                    Step(
                        isActive: _currentStep >= 1,
                        title: Icon(Icons.car_crash),
                        content: Column(
                          children: [
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Marca obrigatório' : null,
                              controller: _veiculoMarcaController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Marca"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Modelo obrigatório' : null,
                              controller: _veiculoModeloController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Modelo"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Ano obrigatório' : null,
                              controller: _veiculoAnoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Ano"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Placa obrigatória' : null,
                              inputFormatters: [_placaMaskFormatter],
                              controller: _veiculoPlacaController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Placa"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Cor obrigatória' : null,
                              controller: _veiculoCorController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Cor"),
                            ),
                          ],
                        )),
                    Step(
                      isActive: _currentStep >= 2,
                      title: Icon(Icons.list),
                      content: SizedBox(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _itemDescricaoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Descrição"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _itemPrecoController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  labelText: "Preço"),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _addItem,
                              child: Text("Adicionar Item"),
                            ),
                            SizedBox(height: 20),
                            _itens.isEmpty
                                ? Text("Nenhum item adicionado ainda.")
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _itens.length,
                                    itemBuilder: (context, index) {
                                      final item = _itens[index];
                                      return ListTile(
                                          title: Text(item['descricao']),
                                          subtitle:
                                              Text("R\$ ${item['preco']}"),
                                          trailing: IconButton(
                                            color: Colors.red,
                                            onPressed: () =>
                                                _removeItens(index),
                                            icon: Icon(Icons.remove),
                                          ));
                                    },
                                  ),
                            SizedBox(height: 10),
                            Text(
                              "Total: R\$ $_totalPagamento",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: Icon(Icons.check),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Text(("Confirme os dados: "))),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                "Dados do cliente",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                                "Nome do Cliente: ${_clienteNomeController.text}"),
                            Text("Contato: ${_clienteTelefoneController.text}"),
                            Text("Email: ${_clienteEmailController.text}"),
                            Text(
                                "Endereço: ${_clienteEnderecoController.text}"),
                            SizedBox(height: 10),
                            Center(
                              child: Text("Dados do veículo",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text(
                                "Modelo do Veículo: ${_veiculoModeloController.text}"),

                            Text("Ano: ${_veiculoAnoController.text}"),
                            Text("Marca: ${_veiculoMarcaController.text}"),
                            Text("Placa: ${_veiculoPlacaController.text}"),
                            Text("Cor: ${_veiculoCorController.text}"),
                            SizedBox(height: 10),
                            Center(
                              child: Text("Descrição e valores",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text("Itens:"),
                            ..._itens.map((item) => Text(
                                "- ${item['descricao']}: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(item['preco'])}")),
                            SizedBox(height: 10),
                            Text(
                                "Valor Total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_totalPagamento)}"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {_generateAndSavePDF(context);},
                              child: Text(
                                "Visualizar e enviar o orçamento",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 3,
                    )
                  ],
                ),
              ),
            ),
            _isAdLoaded ?
            Container(
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ): Container()
          ],
        ),
      ),
    );
  }

  Widget controlsBuilder(context, details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          onPressed: _currentStep > 0
              ? () {
                  setState(() {
                    _currentStep--;
                  });
                }
              : null,
          child: Text(
            "Anterior",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          onPressed: _currentStep < 3
              ? () {
                  setState(() {
                    _currentStep++;
                  });
                }
              : null,
          child: Text(
            "Próximo",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _addItem() {
    if (_itemDescricaoController.text.isNotEmpty &&
        _itemPrecoController.text.isNotEmpty) {
      setState(() {
        _itens.add({
          'descricao': _itemDescricaoController.text,
          'preco': double.parse(_itemPrecoController.text),
        });
        _totalPagamento += double.parse(_itemPrecoController.text);
        _itemDescricaoController.clear();
        _itemPrecoController.clear();
      });
    }
  }

  void _removeItens(int index) {
    setState(() {
      _totalPagamento -=
          _itens[index]['preco']; // Subtrai o valor do item removido do total
      _itens.removeAt(index); // Remove o item da lista
    });
  }

  /*void _generatePDF() {
    // Chama a função para gerar o PDF com dados do Stepper
    generatePdf(
      // Id do orçamento (exemplo)
      clienteNome: _clienteNomeController.text,
      clienteTelefone: _clienteTelefoneController.text,
      clienteEndereco: _clienteEnderecoController.text,
      veiculoModelo: _veiculoModeloController.text,
      veiculoAno: _veiculoAnoController.text,
      veiculoPlaca: _veiculoPlacaController.text,
      veiculoCor: _veiculoCorController.text,
      veiculoMarca: _veiculoMarcaController.text,
      itens: _itens,
      totalPagamento: _totalPagamento,
      //apiUrl: 'https://example.com/approve', // URL para aprovação
    );
  }*/
}
