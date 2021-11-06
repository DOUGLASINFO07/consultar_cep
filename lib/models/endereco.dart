class Endereco{

  String _logradouro ="";
  String _numero = "";
  String _bairro = "";
  String _cidade = "";
  String _cep  = "";
  String _estado  = "";

  Endereco();

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get logradouro => _logradouro;

  set logradouro(String value) {
    _logradouro = value;
  }
}