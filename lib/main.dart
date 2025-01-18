import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orcamento_app/routes/router_generator.dart';
import 'package:orcamento_app/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ['D0E8090B6B0F8C8E75E89C059FDF7FAC'], // Substitua pelo seu
    tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
  );
  MobileAds.instance.updateRequestConfiguration(configuration);

  MobileAds.instance.initialize();
  runApp(MaterialApp(
    title: 'Orçamento App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme: GoogleFonts.robotoTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const Splash(),
    initialRoute: '/splash', // Define a rota inicial
    onGenerateRoute: RouterGenerator.generateRoute, // Define o gerador de rotas
  ));
}
