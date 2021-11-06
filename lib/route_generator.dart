import 'package:consultar_cep/home.dart';
import 'package:consultar_cep/mapa.dart';
import 'package:consultar_cep/principal.dart';
import 'package:consultar_cep/resultado.dart';
import 'package:consultar_cep/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String ROTA_SPLASH = "/";
  static const String ROTA_HOME = "/home";
  static const String ROTA_PRINCIPAL = "/principal";
  static const String ROTA_RESULTADO = "/resultado";
  static const String ROTA_MAPA = "/mapa";
  // static const String ROTA_MENSAGENS = "/mensagens";

  static var args;

  static Route<dynamic> generateRoute(RouteSettings settings) {
   args = settings.arguments;

    switch (settings.name) {
      case ROTA_SPLASH:
        return MaterialPageRoute(
          builder: (_) => Splash(),
        );
      case ROTA_HOME:
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case ROTA_PRINCIPAL:
        return MaterialPageRoute(
          builder: (_) => Principal(),
        );
      case ROTA_RESULTADO:
        return MaterialPageRoute(
          builder: (_) => Resultado(args),
        );
      case ROTA_MAPA:
        return MaterialPageRoute(
          builder: (_) => Mapa(args),
        );
      //   case ROTA_MENSAGENS:
      //   return MaterialPageRoute(
      //     builder: (_) => Mensagens(args),
      //   );
      default:
        return _errorRota();
    }
  }

  static Route<dynamic> _errorRota() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tela não encontrada"),
          ),
          body: const Center(
            child: Text(
              "Tela não encontrada",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
