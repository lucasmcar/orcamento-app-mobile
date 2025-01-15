import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 3,
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          title: Text('Sobre o app', style: TextStyle(fontSize: 18)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Versão do aplicativo"),
                    Text("1.0.0", style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Desenvolvido por"),
                    Text(
                      "Code Experts Sistemas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Divider(),
              Center(
                  heightFactor: 3,
                  child: Text(
                    "Para que serve esse app?",
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Text(
                    textAlign: TextAlign.justify,
                    'Esse aplicativo é apenas um gerador de orçamentos em PDF.'
                    '\nEle é voltado para oficinas automotivas.'
                    '\nSerá atualizado, caso necessário, em versões futuras para outros tipos de serviços.',
                    style: GoogleFonts.roboto()),
              ),
              Center(
                  heightFactor: 3,
                  child: Text(
                    "Da utilização desse aplicativo",
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Text(
                    'Ele armazena dados como email, nome, endereço e telefone e também dados básicos do veículo.\n'
                    'localmente, apenas para preenchimento do documento.'
                    '\nCaso a empresa utilize servidor próprio e deseje armazenar esses dados,\ndeverá ter conscentimento do cliente'),
              )
            ],
          ),
        ));
  }
}
