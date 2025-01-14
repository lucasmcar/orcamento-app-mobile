import 'package:flutter/material.dart';
import 'package:orcamento_app/screens/tabs/aprovado_tab.dart';
import 'package:orcamento_app/screens/tabs/enviado_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose(); // Libere os recursos do controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.pushNamed(context, '/config');
                    },
                    value: 'Configurações',
                    child: Text("Configurações"),
                  ),
                  PopupMenuItem(
                      onTap: () {
                        Navigator.pushNamed(context, '/edit');
                      },
                      value: 'Editar',
                      child: Text("Editar Infos")),
                  PopupMenuItem(
                      onTap: () {
                        Navigator.pushNamed(context, '/about');
                      },
                      value: 'Sobre',
                      child: Text("Sobre o app")),
                  PopupMenuItem(
                      onTap: () {
                        Navigator.pushNamed(context, '/empresa-info');
                      },
                      value: 'Empresa',
                      child: Text("Empresa"))
                ];
              })
        ],
        title: Text(
          "Feed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
            unselectedLabelColor: Colors.blue,
            indicatorWeight: 1.0,
            indicatorColor: Colors.blue,
            dividerColor: Colors.white,
            labelColor: Colors.white,
            controller: tabController,
            tabs: getTabBar()),
      ),
      body: TabBarView(
          controller: tabController, children: [EnviadoTab(), AprovadoTab()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/info-orcamento');
        },
        shape: CircleBorder(),
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.create,
          color: Colors.white,
        ),
      ),
    );
  }
}

List<Widget> getTabBar() {
  return [
    Tab(
      text: 'Enviados',
      icon: Icon(
        Icons.arrow_upward,
        color: Colors.white,
      ),
    ),
    Tab(
      text: 'Aprovados',
      icon: Icon(
        Icons.check,
        color: Colors.white,
      ),
    ),
  ];
}
