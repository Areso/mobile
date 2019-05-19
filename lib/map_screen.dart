import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final String _where;

  MapScreen(this._where);

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState(_where);
  }
}

class _MapScreenState extends State<MapScreen> {
  final String _where;
  PolylineId _polyline;
  String _kind = "districts";
  int _nav = 0;
  Map<String, dynamic> _data;

  _MapScreenState(this._where);

  Future<Set<Polyline>> loadLayer() async {
    final url = "http://51.68.172.115/hack/$_where.$_kind.json";
    final String data = utf8.decode((await http.get(
      url,
    ))
        .bodyBytes);
    final items = jsonDecode(data)[_kind];
    final polyline = items.map((data) {
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
        color: id.value == _polyline?.value
            ? hexToColor(data["color"]).withAlpha(50)
            : Colors.white12,
        width: 8,
        geodesic: true,
        consumeTapEvents: true,
        onTap: () {
          setState(() {
            _polyline = id;
            _data = data;
          });
        },
      );
    });
    final Set<Polyline> set = Set.from(polyline);
    return set;
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  String getTitle() {
    final name = _data["name"];
    if (name == "None") {
      return "Сквер";
    }
    return _data["name"];
  }

  String getArea() {
    return "Площадь: ${_data["area"]} km2";
  }

  String getDescription() {
    final services = _data["services"];
    if (services != null) {
      return "Кол-во сервисов $services";
    }
    final good = double.parse(_data["goodstreets"]);
    final amount = double.parse(_data["streets"]);
    final percents = (good / amount * 100);
    return "👍 ${percents.toStringAsFixed(0)}% из ${_data["streets"]} улиц";
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FutureBuilder(
              future: loadLayer(),
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
                    zoom: 12,
                  ),
                );
              },
            ),
            _data == null
                ? Container()
                : PositionedDirectional(
                    bottom: 0,
                    start: 0,
                    end: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 16,
                        bottom: 50,
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              child: IconButton(icon: Icon(Icons.close)),
                              onTap: () {
                                setState(() {
                                  _data = null;
                                });
                              },
                            ),
                          ),
                          Container(
                            child: Text(
                              getTitle(),
                              textScaleFactor: 2,
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(getArea()),
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              getDescription(),
                              textScaleFactor: 1.5,
                            ),
                            alignment: Alignment.topLeft,
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.domain),
              title: Text("Районы"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_hdr),
              title: Text("Парки"),
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              setState(() {
                _kind = "districts";
                _nav = 0;
                _data = null;
              });
            } else {
              setState(() {
                _kind = "gardens";
                _nav = 1;
                _data = null;
              });
            }
          },
          currentIndex: _nav,
        ),
      );
}
