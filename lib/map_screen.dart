import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final String infoLink;

  MapScreen(this.infoLink);

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState(infoLink);
  }
}

class _MapScreenState extends State<MapScreen> {
  final String infoLink;
  PolylineId _polyline;

  _MapScreenState(this.infoLink);

  Future<Set<Polyline>> loadDistricts() async {
    final String data = (await http.get(infoLink)).body;
    final districts = jsonDecode(data)["districts"];
    final polyline = districts.map((data) {
      final List<LatLng> points = data["coords"].map<LatLng>((dot) {
        final xy = dot.toString().split(", ");
        final x = double.parse(xy[1]);
        final y = double.parse(xy[0]);
        return LatLng(x, y);
      }).toList();
      final id = PolylineId(data["id"] + data["name"]);

      return Polyline(
        polylineId: id,
        points: points,
        color: id.value == _polyline?.value ? hexToColor(data["color"]) : Colors.black,
        width: 8,
        geodesic: true,
        consumeTapEvents: true,
        onTap: () {
          setState(() {
            _polyline = id;
          });
        }
      );
    });
    final Set<Polyline> set = Set.from(polyline);
    return set;
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder(
          future: loadDistricts(),
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(child: Text("Loading . . ."));
            }
            return GoogleMap(
              mapType: MapType.hybrid,
              polylines: snapshot.data,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(56.8390998, 60.6068993),
                zoom: 15,
              ),
              onTap: (latlng) {

              },
            );
          },
        ),
      );
}
