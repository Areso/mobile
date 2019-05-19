import 'package:flutter/material.dart';

import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Object _selectedValue = "Ekaterinburg";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("District17"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Center(
                child: Row(
                  children: <Widget>[
                    Text("Твой город  ", textScaleFactor: 1.2),
                    DropdownButton(
                      items: [
                        DropdownMenuItem(
                          value: "Ekaterinburg",
                          child: Text("Екатеринбург"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      value: _selectedValue,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    MaterialPageRoute(
                        builder: (context) => MapScreen(_selectedValue)),
                  );
                },
              ),
            )
          ],
        ),
      );
}
