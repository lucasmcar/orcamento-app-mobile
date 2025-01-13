import 'package:flutter/material.dart';

class AprovadoTab extends StatefulWidget {
  const AprovadoTab({super.key});

  @override
  State<AprovadoTab> createState() => _AprovadoTabState();
}

class _AprovadoTabState extends State<AprovadoTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Orçamentos Aprovados"),
    );
  }
}
