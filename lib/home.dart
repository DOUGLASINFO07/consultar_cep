import 'package:consultar_cep/models/endereco.dart';
import 'package:consultar_cep/route_generator.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _escolhaUsuarioCEP = false;
  bool _escolhaUsuarioEndereco = true;
  final _textFieldLogradouro = TextEditingController();
  final _textFieldNumero = TextEditingController();
  final _textFieldCidade = TextEditingController();
  final _textFieldCEP = TextEditingController();
  String _dropdownValueEstado = 'Escolha seu Estado';

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
            "Confira o formulário!!",
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

  _enviarPesquisa(){

    if(_escolhaUsuarioEndereco == true){
      if(_textFieldCEP.text.replaceAll("-", "").length != 8){
        _alerta_erroPesquisa();
      }else {
        Endereco endereco = Endereco();
        endereco.logradouro = _textFieldLogradouro.text;
        endereco.numero = _textFieldNumero.text;
        endereco.cidade = _textFieldCidade.text;
        endereco.estado = _dropdownValueEstado;
        endereco.cep = _textFieldCEP.text;
        print(_textFieldCEP.text);
        Navigator.pushNamed(
            context, RouteGenerator.ROTA_RESULTADO, arguments: endereco);
        _textFieldLogradouro.clear();
        _textFieldNumero.clear();
        _textFieldCidade.clear();
        _dropdownValueEstado = 'Escolha seu Estado';
        _textFieldCEP.clear();
      }
    }else{

    }

    if(_escolhaUsuarioCEP == true){
      if(_textFieldLogradouro.text == "" || _textFieldCidade.text == "" || _dropdownValueEstado == "Escolha seu Estado"){
        _alerta_erroPesquisa();
      }else {
        Endereco endereco = Endereco();
        endereco.logradouro = _textFieldLogradouro.text;
        endereco.numero = _textFieldNumero.text;
        endereco.cidade = _textFieldCidade.text;
        endereco.estado = _dropdownValueEstado;
        endereco.cep = _textFieldCEP.text;
        print(_textFieldCEP.text);
        Navigator.pushNamed(
            context, RouteGenerator.ROTA_RESULTADO, arguments: endereco);
        _textFieldLogradouro.clear();
        _textFieldNumero.clear();
        _textFieldCidade.clear();
        _dropdownValueEstado = 'Escolha seu Estado';
        _textFieldCEP.clear();
      }
    }else{

    }


  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.82,
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
                  "TIPO DE PESQUISA",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffa7c01),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // *** BOTÕES SWITCH
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white,
                      // boxShadow: [
                      //   BoxShadow(color: Colors.green, spreadRadius: 3),
                      // ],
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xfffa7c01),
                          spreadRadius: 3,
                        )
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          title: const Text(
                            "Procurar endereço",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1b1d49),
                            ),
                          ),
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: _escolhaUsuarioEndereco,
                          onChanged: (bool valor) {
                            setState(() {
                              _escolhaUsuarioEndereco = valor;
                              _escolhaUsuarioCEP = false;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: const Text(
                            "Procurar CEP",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1b1d49),
                            ),
                          ),
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: _escolhaUsuarioCEP,
                          onChanged: (bool valor) {
                            setState(() {
                              _escolhaUsuarioCEP = valor;
                              _escolhaUsuarioEndereco = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                _escolhaUsuarioCEP
                // *** CAMPOS FORMULÁRIO ENDEREÇO ***
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            // *** CAMPO LOGRADOURO ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldLogradouro,
                                keyboardType: TextInputType.name,
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
                            // *** CAMPO CIDADE ***
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: TextField(
                                autofocus: false,
                                controller: _textFieldCidade,
                                keyboardType: TextInputType.name,
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
                            DropdownButtonFormField(
                              value: _dropdownValueEstado,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 26,
                              iconEnabledColor: Color(0xfffa7c01),
                              iconDisabledColor: Color(0xfffa7c01),
                              elevation: 20,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              dropdownColor: Colors.white,
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  _dropdownValueEstado = newValue!;
                                });
                              },
                              items: <String>[
                                'Escolha seu Estado',
                                'Acre',
                                'Alagoas',
                                'Amapá',
                                'Amazonas',
                                'Bahia',
                                'Ceará',
                                'Distrito Federal',
                                'Espírito Santo',
                                'Fernando de Noronha',
                                'Goiás',
                                'Maranhão',
                                'Mato Grosso',
                                'Mato Grosso',
                                'Minas Gerais',
                                'Pará',
                                'Paraíba',
                                'Paraná',
                                'Pernambuco',
                                'Piauí',
                                'Rio de Janeiro',
                                'Rio Grande do Norte',
                                'Rio Grande do Sul',
                                'Rondônia',
                                'Roraima',
                                'Santa Catarina',
                                'São Paulo',
                                'Sergipe',
                                'Tocantins',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      )
                // *** CAMPO FORMULÁRIO CEP ***
                    : Container(
                        // *** CAMPO CEP ***
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: TextField(
                            autofocus: false,
                            controller: _textFieldCEP,
                            keyboardType: TextInputType.number,
                            onTap: () {
                              // _textFieldEmail.clear();
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite o CEP",
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
                      ),
                const SizedBox(
                  height: 40,
                ),
                // Container(
                //   child: getBanner(AdmobBannerSize.BANNER),
                // ),
                // Container(child: getBanner(AdmobBannerSize.MEDIUM_RECTANGLE)),
                // *** BOTÃO PROCURAR CEP ***
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {
                      _enviarPesquisa();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.search_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Procurar",
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
        ),
      ),
    );
  }
}
