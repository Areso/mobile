import 'package:flutter/material.dart';

import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedValue = "2";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("DRHMT"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 80),
                child: Text(
                  "Выбирете город",
                  textScaleFactor: 1.6,
                ),
              ),
            ),
            Center(
              child: Container(
                child: DropdownButton(
                  items: [
                    DropdownMenuItem(
                      value: "http://51.68.172.115/hack/Ekaterinburg.districts.json",
                      child: Text("Екатеринбург"),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text("Карабаш"),
                    ),
                    DropdownMenuItem(
                      value: "3",
                      child: Text("Челябинск"),
                    ),
                    DropdownMenuItem(
                      value: "4",
                      child: Text("Череповец"),
                    ),
                    DropdownMenuItem(
                      value: "5",
                      child: Text("Арзамас"),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  value: _selectedValue,
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 80,
              start: 130,
              end: 130,
              child: MaterialButton(
                child: Text("Войти"),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MapScreen(_selectedValue)),
                  );
                },
              ),
            )
          ],
        ),
      );
}
