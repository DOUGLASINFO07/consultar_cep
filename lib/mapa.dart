import 'dart:async';
import 'package:consultar_cep/models/endereco.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class Mapa extends StatefulWidget {
  Endereco _endereco;

  Mapa(this._endereco);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _listaMarcadores = {};

  double _lat = 0.0;
  double _long = 0.0;

  CameraPosition? _positionCamera;

  _recuperarLocalEndereco() async {
    List<Location> listaEnderecos = await locationFromAddress(
        widget._endereco.logradouro +
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
    _carregarMarcadores();
  }

  _carregarMarcadores() {
    // ***  MARCADORES  ***
    Set<Marker> marcadoresLocal = {};
    Marker marcadorLocalAtual = Marker(
      markerId: MarkerId("marcador-casa"),
      position: LatLng(_lat, _long),
      infoWindow: const InfoWindow(
        title: "Minha Casa",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
      rotation: 0,
      onTap: () => print("Casa clicada!"),
    );
    marcadoresLocal.add(marcadorLocalAtual);
    setState(() {
      _listaMarcadores = marcadoresLocal;
    });
    _positionCamera = CameraPosition(
      target: LatLng(_lat, _long),
      zoom: 16,
    );
  }

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  @override
  void initState() {
    _recuperarLocalEndereco();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        title: const Text("Tela do Mapa"),
      ),
      body: GoogleMap(
        // mapType: MapType.terrain,
        // mapType: MapType.satellite,
        // mapType: MapType.satellite,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:_positionCamera!,
        onMapCreated: _onMapCreated,
        markers: _listaMarcadores,
        // polygons: _polygons,
        // polylines: _polylines,
      ),
    );
  }
}
