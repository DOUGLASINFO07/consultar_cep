// @dart=2.9
import 'package:consultar_cep/principal.dart';
import 'package:consultar_cep/route_generator.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: "Consultar CEP",
      theme: ThemeData().copyWith(
        // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff25D366)),
        colorScheme: ThemeData().colorScheme.copyWith(
          secondary: Color(0xfffa7c01),
          primary: Color(0xff1b1d49),
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      home: Principal(),
      debugShowCheckedModeBanner: false,
    )
  );
}

