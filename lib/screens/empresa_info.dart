import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orcamento_app/helper/database_helper.dart';
import 'package:orcamento_app/models/empresa.dart';

class EmpresaInfo extends StatefulWidget {
  const EmpresaInfo({super.key});

  @override
  State<EmpresaInfo> createState() => _EmpresaInfoState();
}

class _EmpresaInfoState extends State<EmpresaInfo> {
  final _empresaKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  String? _imagePath; // Caminho da imagem selecionada

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Caminho local da imagem
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          titleSpacing: 3,
          title: const Text(
            'Cadastro da Empresa',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 5.0,
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _empresaKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        heightFactor: 2,
                        child: Text(
                          "Insira as informações da empresa",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                        child: TextFormField(
                          controller: _nomeController,
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Nome',
                            hintText: 'Nome da empresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          controller: _enderecoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Endereço',
                            hintText: 'Endereço da empresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          controller: _cidadeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Cidade',
                            hintText: 'Cidade da empresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Email',
                            hintText: 'Email da empresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          controller: _cnpjController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Cnpj',
                            hintText: 'Cnpj da empresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          controller: _telefoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Telefone',
                            hintText: 'Telefone da empresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, right: 8, left: 8),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: _imagePath == null
                              ? Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: const Center(
                                    child:
                                        Text("Clique para selecionar a imagem"),
                                  ),
                                )
                              : Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(File(_imagePath!)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 8.0, right: 8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              final empresa = Empresa(
                                  nome: _nomeController.text,
                                  endereco: _enderecoController.text,
                                  cidade: _cidadeController.text,
                                  email: _emailController.text,
                                  cnpj: _cnpjController.text,
                                  telefone: _telefoneController.text,
                                  imagem_path: _imagePath);

                              _salvarDados(context, empresa);
                              clearFields();
                            },
                            child: const Text('Salvar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/edit');
                          },
                          child: Text("Ir para ediacao"))
                    ]))));
  }

  void _salvarDados(BuildContext context, Empresa empresa) {
    if (_empresaKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;

      db.insertEmpresa({
        'nome': empresa.nome,
        'endereco': empresa.endereco,
        'cidade': empresa.cidade,
        'email': empresa.email,
        'cnpj': empresa.cnpj,
        'telefone': empresa.telefone,
        'imagem_path': _imagePath
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados salvos com sucesso!')),
      );
    }
  }

  void clearFields() {
    _telefoneController.clear();
    _nomeController.clear();
    _cnpjController.clear();
    _emailController.clear();
    _enderecoController.clear();
  }
}
