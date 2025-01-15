import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  TextEditingController _nrValidadeController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _clienteController = TextEditingController();
  TextEditingController _veiculoController = TextEditingController();
  TextEditingController _servicoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
  }

  final GlobalKey _serverKey = GlobalKey<FormState>();
  final GlobalKey _validatedOrcamentKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _nrDaysIsChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3,
        title: Text(
          "Configuração",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.yellow,
                      ),
                      Text(
                          "Apenas ative essas configurações se \npossuir servidor próprio")
                    ])),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Usará servidor próprio?"),
                    Switch(
                        splashRadius: 6,
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                          _savePreferences();
                        }),
                  ]),
            ),
            AnimatedOpacity(
                opacity: _isChecked ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeIn,
                child: _isChecked
                    ? Column(
                        children: [
                          Form(
                            key: _serverKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 16, left: 16),
                                  child: TextFormField(
                                      controller: _urlController,
                                      decoration: const InputDecoration(
                                        labelText: 'URL',
                                        hintText: 'Url do servidor sem "/"',
                                      )),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(right: 16, left: 16),
                                    child: TextFormField(
                                        controller: _clienteController,
                                        decoration: const InputDecoration(
                                          labelText: 'Rota do cliente',
                                          hintText: 'Sem "/"',
                                        ))),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 16, left: 16),
                                  child: TextFormField(
                                      controller: _veiculoController,
                                      decoration: const InputDecoration(
                                        labelText: 'Rota do veículo',
                                        hintText: 'Sem "/"',
                                      )),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 16, left: 16),
                                  child: TextFormField(
                                      controller: _servicoController,
                                      validator: (value) => value!.isEmpty
                                          ? 'Campo obrigatório'
                                          : null,
                                      decoration: const InputDecoration(
                                        labelText: 'Rota de dados do servico',
                                        hintText: 'Sem "/"',
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container()),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Definir validade do orçamento?"),
                    Switch(
                        splashRadius: 6,
                        value: _nrDaysIsChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _nrDaysIsChecked = value!;
                          });
                          _savePreferences();
                        }),
                  ]),
            ),
            AnimatedOpacity(
              opacity: _nrDaysIsChecked ? 1.0 : 0,
              duration: Duration(milliseconds: 300),
              child: _isChecked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                            key: _validatedOrcamentKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 16, left: 16),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          1 /
                                          4,
                                      child: TextFormField(
                                        controller: _nrValidadeController,
                                        decoration: InputDecoration(
                                            labelText: "Nº Dias"),
                                      )),
                                )
                              ],
                            ))
                      ],
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _savePreferences() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('servidor_proprio', _isChecked);
    await _prefs.setBool('nr_dias_validade', _nrDaysIsChecked);
  }

  Future<void> _loadPreferences() async {
    final _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = _prefs.getBool('servidor_proprio')!;
      _nrDaysIsChecked = _prefs.getBool('nr_dias_validade')!;
    });
  }
}
