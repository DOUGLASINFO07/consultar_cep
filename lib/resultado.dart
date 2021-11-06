import 'package:consultar_cep/models/endereco.dart';
import 'package:consultar_cep/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Resultado extends StatefulWidget {

  Endereco _endereco;

  Resultado(this._endereco);

  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  final _textFieldLogradouro = TextEditingController();
  final _textFieldNumero = TextEditingController();
  final _textFieldCidade = TextEditingController();
  final _textFieldCEP = TextEditingController();
  final _textFieldBairro = TextEditingController();
  final _textFieldEstado = TextEditingController();

  String get logradouro => widget._endereco.logradouro;
  String get numero => widget._endereco.numero;
  String get cidade => widget._endereco.cidade;
  String get estado => widget._endereco.estado;
  String get cep => widget._endereco.cep;

  bool _status = false;
  bool _statusFavorito = false;

  double _lat = 0.0;
  double _long = 0.0;

  List _listaEndereco = [];
  Map<String, dynamic> _ultimoEnderecoRemovido = Map();
  var arquivo;
  int? arquivoRemover;

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File(diretorio.path + "/dados.json");
  }

  _salvarTarefa() {
    Map<String, dynamic> endereco = {};
    endereco["logradouro"] = _textFieldLogradouro.text;
    endereco["numero"] = _textFieldNumero.text;
    endereco["bairro"] = _textFieldBairro.text;
    endereco["cidade"] = _textFieldCidade.text;
    endereco["estado"] = _textFieldEstado.text;
    endereco["cep"] = _textFieldCEP.text;
    _listaEndereco.add(endereco);
    setState(() {
      _listaEndereco;
    });
    _salvarArquivo();
  }

  _salvarArquivo() async {
    arquivo = await _getFile();
    //Criar Dados
    String dados = json.encode(_listaEndereco);
    arquivo.writeAsString(dados);
  }

  _deletarArquivo() async {
    print("TESTE: " + _listaEndereco.length.toString());
    _listaEndereco.removeLast();
    _salvarArquivo();
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

  _recuperarCep(String cep) async {
    String url = "https://viacep.com.br/ws/${cep}/json/";
    http.Response response;
    response = await http.get(url);
    json.decode(response.body);
    if (json.decode(response.body)["erro"].toString() == "true") {
      _alerta_erroPesquisa();
    } else {
      Map<String, dynamic> retorno = json.decode(response.body);
      String _logradouro = retorno["logradouro"];
      String _complemento = retorno["complemento"];
      String _bairro = retorno["bairro"];
      String _localidade = retorno["localidade"];
      String _uf = retorno["uf"];
      _textFieldLogradouro.text = _logradouro;
      if(_complemento == ""){
        _textFieldNumero.text = "Nº.0 até o final";
      }else{
        _textFieldNumero.text = _complemento;
      }
      _textFieldBairro.text = _bairro;
      _textFieldCidade.text = _localidade;
      _textFieldEstado.text = _uf;
      _textFieldCEP.text = cep;
      setState(() {
        _status = true;
      });
    }
  }

  _recuperarEndereco() async {
    List<Location> listaEnderecos = await locationFromAddress(
        widget._endereco.logradouro +
            "," +
            widget._endereco.numero +
            "," +
            widget._endereco.cidade +
            "," +
            widget._endereco.estado);
    if (listaEnderecos != null && listaEnderecos.length > 0) {
      for (Location item in listaEnderecos) {
        setState(() {
          _lat = item.latitude;
          _long = item.longitude;
        });
      }
    }

    List<Placemark> listaEnderecos1 = await placemarkFromCoordinates(
        _lat, _long); //latitude e longitude deve ser um método get.
    if (listaEnderecos1 != null && listaEnderecos1.length > 0) {
      Placemark endereco1 = listaEnderecos1[0];
      for (Placemark item in listaEnderecos1) {
        _textFieldLogradouro.text =  endereco1.thoroughfare.toString();
        if( endereco1.subThoroughfare.toString() == ""){
          _textFieldNumero.text = "Nº.0 até o final";
        }else{
          _textFieldNumero.text = endereco1.subThoroughfare.toString();
        }
        _textFieldBairro.text = endereco1.subLocality.toString();
        _textFieldCidade.text = endereco1.subAdministrativeArea.toString();
        _textFieldEstado.text = endereco1.administrativeArea.toString();
        _textFieldCEP.text = endereco1.postalCode.toString();
        setState(() {
          _status = true;
        });
      }
    }
  }

  _recuperarresultado(){
    if(cep == ""){
      _recuperarEndereco();
    }else{
      _recuperarCep(cep);
    }
  }

  //ALERTA ERRO AO LOCALIZAR ENDEREÇO
  _alerta_erroPesquisa() {
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
                "Ok",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
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
            "Nenhum endereço encontrado!!",
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
    _recuperarresultado();
    _lerArquivo().then((dados) {
      setState(() {
        _listaEndereco = json.decode(dados);
        print("CONTEÙDO DO ARQUIVO: " + _listaEndereco.toString());
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Tela Resultado"),
      ),
      body: Center(
        child: _status == false
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Color(0xfffa7c01),
              )
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xff1b1d49),
                      Color(0xff2e327c),
                    ],
                  )),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "DADOS DO ENDEREÇO",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfffa7c01),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            // *** CAMPO LOGRADOURO ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldLogradouro,
                                keyboardType: TextInputType.name,
                                enabled: false,
                                onTap: () {
                                  // _textFieldEmail.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "Rua, avenida...",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // *** CAMPO NÚMERO ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldNumero,
                                keyboardType: TextInputType.number,
                                enabled: false,
                                onTap: () {
                                  // _textFieldEmail.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "Número",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // *** CAMPO BAIRRO ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldBairro,
                                keyboardType: TextInputType.name,
                                enabled: false,
                                onTap: () {
                                  // _textFieldEmail.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "Nome do bairro",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // *** CAMPO CIDADE ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldCidade,
                                keyboardType: TextInputType.name,
                                enabled: false,
                                onTap: () {
                                  // _textFieldEmail.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "Nome da cidade",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // *** CAMPO ESTADO ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldEstado,
                                keyboardType: TextInputType.name,
                                enabled: false,
                                onTap: () {
                                  // _textFieldEmail.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "Nome da cidade",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // *** CAMPO CEP ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldCEP,
                                keyboardType: TextInputType.name,
                                enabled: false,
                                onTap: () {
                                  // _textFieldEmail.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "Nome do bairro",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // *** BOTÃO VER NO MAPA
                            SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () {
                                  Endereco endereco = Endereco();
                                  endereco.cep = _textFieldCEP.text;
                                  endereco.logradouro = _textFieldLogradouro.text;
                                  endereco.cidade = _textFieldCidade.text;
                                  endereco.estado = _textFieldEstado.text;
                                  Navigator.pushNamed(
                                      context, RouteGenerator.ROTA_MAPA, arguments: endereco);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Ver no mapa",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white24,
                                  // backgroundColor: Theme.of(context).colorScheme.secondary,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    // side: BorderSide(color: Colors.red)
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // *** BOTÃO COMPARTILHAR
                            SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () {
                                  Share.share("*ENDEREÇO*\n"
                                      "*Logradouro:* ${_textFieldLogradouro.text}\n"
                                      "*Nº:* ${_textFieldNumero.text}\n"
                                      "*Bairro:* ${_textFieldBairro.text}\n"
                                      "*Cidade:* ${_textFieldCidade.text}\n"
                                      "*Estado:* ${ _textFieldEstado.text}\n"
                                      "*CEP:* ${_textFieldCEP.text} ");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Compartilhar",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white24,
                                  // backgroundColor: Theme.of(context).colorScheme.secondary,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    // side: BorderSide(color: Colors.red)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        backgroundColor: Color(0xfffa7c01),
        foregroundColor: _statusFavorito ? Color(0xff1b1d49) : Colors.white,
        elevation: 6,
        mini: false,
        splashColor: Colors.redAccent,
        child: Icon(Icons.star),
        onPressed: () {
         setState(() {
           if(_statusFavorito == true){
           _statusFavorito = false;
             _deletarArquivo();
           }else{
             _statusFavorito = true;
           _salvarTarefa();
           }
         });
        },
        tooltip: "Adicionar Favorito",
      ),
    );
  }
}
