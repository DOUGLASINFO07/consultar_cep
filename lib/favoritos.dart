import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  List _listaEndereco = [];
  var arquivo;

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File(diretorio.path + "/dados.json");
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  _salvarArquivo() async {
    arquivo = await _getFile();
    //Criar Dados
    String dados = json.encode(_listaEndereco);
    arquivo.writeAsString(dados);
  }

   _removerEndereco(index) {
    _listaEndereco.removeAt(index);
    _salvarArquivo();
    setState(() {
      _listaEndereco;
    });
  }

  //ALERTA EXCLUIR ENDEREÇO DE FAVORITOS
  _alerta_erroPesquisa(index) {
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
            TextButton(
                child: Text(
                  "Sim",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onPressed: () {
                  _removerEndereco(index);
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
            "Confirmar exclusão?",
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
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaEndereco = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _listaEndereco.length,
        itemBuilder: (context, index) {
          return ListTile(
            onLongPress: (){
              _alerta_erroPesquisa(index);
            } ,
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            onTap: () {
              // _alerta_erroPesquisa(index) ;
            },
            leading: const CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage("assets/imagens/icone.jpg"),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Logradouro: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text( "${_listaEndereco[index]["logradouro"]}" , style: TextStyle(color: Colors.white),),
                  ],
                ),Row(
                  children: <Widget>[
                    Text("Número: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text("${_listaEndereco[index]["numero"]}", style: TextStyle(color: Colors.white),),
                  ],
                ),Row(
                  children: <Widget>[
                    Text("Bairro: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text("${_listaEndereco[index]["bairro"]}", style: TextStyle(color: Colors.white),),
                  ],
                ),Row(
                  children: <Widget>[
                    Text("Cidade: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text("${_listaEndereco[index]["cidade"]}", style: TextStyle(color: Colors.white),),
                  ],
                ),Row(
                  children: <Widget>[
                    Text("Estado: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text("${_listaEndereco[index]["estado"]}", style: TextStyle(color: Colors.white),),
                  ],
                ),Row(
                  children: <Widget>[
                    Text("CEP: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text("${_listaEndereco[index]["cep"]}", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ],
            ),
          );
        },
    );
  }
}
