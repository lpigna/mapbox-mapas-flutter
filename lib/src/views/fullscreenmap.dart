import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key key}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  String selectedStyle = 'mapbox://styles/leonard9500/ckeq9ikxt4qq419psxfvvnb76';

  final center = LatLng(-34.688763, -58.501002);
  final oscuroStyle = 'mapbox://styles/leonard9500/ckeq9ikxt4qq419psxfvvnb76';
  final streetStyle = 'mapbox://styles/leonard9500/ckeq9n8w81bzr19lobdyhwp7q';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/symbols/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _crearMapa(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _botonesFlotantes(),
    );
  }

  Column _botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        //Simbolos
        FloatingActionButton(
          child: Icon(Icons.face),
          onPressed: () {

            mapController.addSymbol(SymbolOptions(
              geometry: center,
              textField: 'Estoy Aqui',
              // iconImage: 'attraction-15',
              iconImage: 'assetImage',
              iconSize: 1,
              textOffset: Offset(0, 5),

            ));
            
          },
        ),

        SizedBox(height: 5),
        //Zoom In
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {

            mapController.animateCamera(CameraUpdate.zoomIn());//Para hacer el Zoom
            
          },
        ),
        
        SizedBox(height: 5),
        //Zoom Out
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {

            mapController.animateCamera(CameraUpdate.zoomOut());//Para alejar

          }
        ),

        SizedBox(height: 10),
        //Cambiar Estilo
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () { 
              if(selectedStyle == oscuroStyle)
                selectedStyle = streetStyle;
              else
                selectedStyle = oscuroStyle;
              
              _onStyleLoaded();
              setState(() {});
            },
        )
      ],
    );
  }

  MapboxMap _crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 14),
    );
  }


  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }


}
