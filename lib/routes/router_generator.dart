import 'package:flutter/material.dart';
import 'package:orcamento_app/screens/config_page.dart';
import 'package:orcamento_app/screens/empresa_info.dart';
import 'package:orcamento_app/screens/info_orcamento.dart';
import 'package:orcamento_app/screens/sobre_page.dart';

import '../screens/editar_page.dart';
import '../screens/home_page.dart';
import '../screens/not_found_page.dart';
import '../screens/splash.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/config':
        return MaterialPageRoute(builder: (_) => ConfigPage());
      case '/about':
        return MaterialPageRoute(builder: (_) => SobrePage());
      case '/empresa-info':
        return MaterialPageRoute(builder: (_) => EmpresaInfo());
      case '/info-orcamento':
        return MaterialPageRoute(builder: (_) => InfoOrcamento());
      case '/edit':
        return MaterialPageRoute(builder: (_) => EditarPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => NotFoundPage(),
    );
  }
}