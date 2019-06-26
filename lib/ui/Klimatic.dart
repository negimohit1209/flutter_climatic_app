import 'package:flutter/material.dart';
import '../util//utils.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  Klimatic({Key key}) : super(key: key);

  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context){
        return ChangeCity();
      })
    );
  }

  void showsStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Klimatic',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {_goToNextScreen(context);},
            color: Colors.red,
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
            iconSize: 30.0,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/umbrella.png',
                width: 490.0, height: 1200.0, fit: BoxFit.fitHeight),
          ),
          Container(
            child: Text('Spokane', style: cityStyle()),
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(30.0, 450.0, 0.0, 0.0),
              child: updateTempWidget("Manali"))
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${util.appId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.appId, city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // where we get all info or json data, we set up widget, etc.
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(content['main']['temp'].toString(),
                      style: tempStyle()),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ChangeCity extends StatelessWidget {
  const ChangeCity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Change City'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                  'images/white_snow.png',
                  width: 490.0,
                  height: 1200.0,
                  fit: BoxFit.fill,
                )
            ),
           
          ],
        ));
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}
