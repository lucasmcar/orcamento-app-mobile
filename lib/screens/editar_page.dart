import 'package:flutter/material.dart';

import '../helper/database_helper.dart';
import '../models/empresa.dart';

class EditarPage extends StatefulWidget {
  const EditarPage({super.key});

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  Empresa? empresa;
  final GlobalKey<FormState> _editEmpresaKey = GlobalKey<FormState>();

  final TextEditingController _editNomeController = TextEditingController();
  final TextEditingController _editEnderecoController = TextEditingController();
  final TextEditingController _editCidadeController = TextEditingController();
  final TextEditingController _editCnpjController = TextEditingController();
  final TextEditingController _editTelefoneController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();
  String? id;

  bool _isLoading = true;
  bool _isSaving = false;

  Future<void> loadEmpresaData() async {
    final empresaData = await DatabaseHelper.instance.getEmpresa();

    if (empresaData != null) {
      setState(() {
        empresa = Empresa.fromMap(
            empresaData.map((key, value) => MapEntry(key, value.toString())));

        id = (empresa)?.id.toString();
        _editNomeController.text = (empresa)!.nome!;
        _editEnderecoController.text = (empresa)!.endereco!;
        _editCidadeController.text = (empresa)!.cidade!;
        _editCnpjController.text = (empresa)!.cnpj!;
        _editEmailController.text = (empresa)!.email!;
        _editTelefoneController.text = (empresa)!.telefone!;
      });
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadEmpresaData();

    // Carregar os dados da oficina assim que a página for carregada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3,
        elevation: 7,
        title: Text(
          "Editar informações",
          style: TextStyle(fontSize: 18),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading && empresa != null
          ? Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  //CircularProgressIndicator(),
                  Text("Não ha dados há serem editados")
                ]))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _editEmpresaKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(right: 16, left: 16, top: 8),
                            child: TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Campo obrigatório' : null,
                              controller: _editNomeController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                labelText: "Nome",
                              ),
                            )),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                            controller: _editEnderecoController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Endereço",
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(right: 16, left: 16),
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                            controller: _editCidadeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Cidade",
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(right: 16, left: 16),
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                            controller: _editCnpjController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Cnpj",
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(right: 16, left: 16),
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                            controller: _editEmailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Email",
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(right: 16, left: 16),
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                            controller: _editTelefoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Telefone",
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(padding: EdgeInsets.only(right: 16, left: 16), child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              if (_editEmpresaKey.currentState!.validate()) {
                                final empresa = Empresa(
                                  id: id,
                                  nome: _editNomeController.text,
                                  endereco: _editEnderecoController.text,
                                  email: _editEmailController.text,
                                  cnpj: _editCnpjController.text,
                                  telefone: _editTelefoneController.text,
                                  cidade: _editCidadeController.text,
                                );
                                editarEmpresa(
                                    context,
                                    Empresa(
                                      id: empresa.id,
                                      nome: empresa.nome,
                                      endereco: empresa.endereco,
                                      cnpj: empresa.cnpj,
                                      email: empresa.email,
                                      telefone: empresa.telefone,
                                      cidade: empresa.cidade,
                                    ));
                              }
                            },
                            child: Text("Salvar Informações")))

                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void editarEmpresa(BuildContext context, Empresa empresa) {
    if (_editEmpresaKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;

      db.editEmpresa({
        'id': empresa.id,
        'nome': empresa.nome,
        'endereco': empresa.endereco,
        'cidade': empresa.cidade,
        'email': empresa.email,
        'cnpj': empresa.cnpj,
        'telefone': empresa.telefone,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados salvos com sucesso!')),
      );
    }
  }
}
