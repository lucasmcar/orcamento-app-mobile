import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerAd();
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

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
              ),
              if (_isAdLoaded)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
            ],
          ),
        ));
  }

  void _loadBannerAd() async {
    try {
      AnchoredAdaptiveBannerAdSize? bannerAdSize =
          await AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait,
        MediaQuery.of(context).size.width.truncate(),
      );

      if (bannerAdSize != null) {
        _bannerAd = BannerAd(
          adUnitId:
              'ca-app-pub-0785743061078544/7741568304', // Substitua pelo seu ID
          size: bannerAdSize,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (Ad ad) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              print('Erro ao carregar o banner: $error');
            },
          ),
        );
        await _bannerAd.load();
      } else {
        print('Erro: Não foi possível calcular o tamanho do banner.');
      }
    } catch (e) {
      print('Erro ao inicializar o banner: $e');
    }
  }
}
