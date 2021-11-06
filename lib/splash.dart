import 'dart:async';

import 'package:consultar_cep/route_generator.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_PRINCIPAL);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffffffff),
        padding: EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "PROCURAR",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1b1d49),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "CEP",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1b1d49),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "&",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1b1d49),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "ENDEREÇO",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1b1d49),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Image.asset('assets/imagens/logo.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
