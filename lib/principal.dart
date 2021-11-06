import 'package:consultar_cep/favoritos.dart';
import 'package:consultar_cep/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Principal extends StatefulWidget {

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  int _indiceAtual = 0;

  //ALERTA FECHAR APLICAÇÂO
  _alertaFecharAplicacao() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          buttonPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          actions: <Widget>[
            TextButton(
                child: Text(
                  "Sim",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                }
            ),
            TextButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text("ATENÇÃO!"),
          titleTextStyle: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          // titlePadding: EdgeInsets.all(10),
          content: const Text(
            "Deseja fechar a aplicação?",
          ),
          // contentPadding: EdgeInsets.all(10),
          contentTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tels =[
      Home(),
      Favoritos(),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,

      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: <Widget>[
            Image.asset(
              "assets/imagens/empresa.png",
              height: 30,
              width: 100,
            ),
            Text("Consultar CEP")
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "Sair",
            icon: Icon(Icons.logout),
            onPressed: () => _alertaFecharAplicacao(),
          ),
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(15),
        child: tels[_indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice){
          setState(() {
            _indiceAtual = indice;
          });
        },

        type: BottomNavigationBarType.shifting,
        fixedColor: Theme.of(context).colorScheme.primary,
        iconSize: 30,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0xfffa7c01),
            label: "Início",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xfffa7c01),
            label: "Favoritos",
            icon: Icon(Icons.star),

          ),
        ],
      ),
    );
  }
}
