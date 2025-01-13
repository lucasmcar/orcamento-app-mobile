import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o app'),
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
                ],),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Desenvolvido por"),
                  Text("Code Experts Sistemas", style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
            ),
            Text(
                'Esse aplicativo é apenas um gerador de orçamentos.'
                    'Ele é voltado para oficinas automotivas'
                'Ele será atualizado em versões futuras para outros tipos de serviços',
              style: GoogleFonts.roboto()
              ),

            Text('Ele não armazena dados sensiveis, apenas dados para consultas, localmente ou em servidor próprio da empresa. E são utilizados apenas para controle.'),
          ],
        ),
      )
    );
  }
}
