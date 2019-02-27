///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  22 Feb 2019
///
///

import 'dart:async' show Completer, Future;

import 'package:flutter/material.dart';

import 'package:mvc_application/mvc.dart' show StateMVC;

import 'package:weathercast/src/model.dart' as model;

import 'package:weathercast/src/view.dart'
    show
        CitySelection,
        GradientContainer,
        LastUpdated,
        Location,
        SettingsDrawer,
        StateMVC,
        TemperatureUnits,
        WeatherTemperature;

import 'package:weathercast/src/controller.dart'
    show Settings, ThemeCon, WeatherCon;

class Weather extends StatefulWidget {
  Weather({Key key}) : super(key: key);

  @override
  State createState() => _WeatherState();
}

class _WeatherState extends StateMVC<Weather> {
  _WeatherState() : super(WeatherCon()) {
    _weatherCon = controller;
  }
  WeatherCon _weatherCon;
  Completer<void> _refreshCompleter = Completer<void>();

  // Scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SettingsDrawer(con: _weatherCon.settingsDrawer(context)),
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              _weatherCon.onPressed(city);
            },
          )
        ],
      ),
      body: Center(
        child: Builder(builder: (_) {
          if (_weatherCon.city == null || _weatherCon.city.isEmpty) {
            return Text('Please Select a Location');
          }
          if (_weatherCon.error) {
            return Text(
              'Something went wrong!',
              style: TextStyle(color: Colors.red),
            );
          }
          if (_weatherCon.weather == null) {
            return CircularProgressIndicator();
          }
          final model.Weather weather = _weatherCon.weather;

          _refreshCompleter?.complete();
          _refreshCompleter = Completer();

          return GradientContainer(
            color: ThemeCon.color,
            child: RefreshIndicator(
              onRefresh: () {
                _weatherCon.onRefresh();
                return _refreshCompleter.future;
              },
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Location(location: weather.location),
                    ),
                  ),
                  Center(
                    child: LastUpdated(dateTime: weather.lastUpdated),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: Center(
                      child: WeatherTemperature(
                        weather: weather,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class WeatherAppMenu {
  static State _state;

  static PopupMenuButton<String> show(State state) {
    _state = state;
    return PopupMenuButton<String>(
      onSelected: _showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(value: 'Settings', child: Text('Settings')),
            const PopupMenuItem<String>(value: 'About', child: Text('About')),
          ],
    );
  }

  static _showMenuSelection(String value) async {
    switch (value) {
      case 'Settings':
        UnitsOfTemp.show(
          context: _state.context,
        );
        break;
      case 'About':
        showAboutDialog(
            context: _state.context,
            applicationName: "Flutter Weather",
            children: [Text('A Flutter Weather App')]);
        break;
      default:
    }
  }
}

class UnitsOfTemp {
  static Future<void> show({
    @required BuildContext context,
  }) {
    bool unitSet = Settings.temperatureUnits == TemperatureUnits.celsius;
    String unitLabel = unitSet ? 'Celsius' : 'Fahrenheit';
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(title: Text(unitLabel), children: <Widget>[
              Container(
                  padding: EdgeInsets.all(9.0),
                  child: Center(
                    child: Column(children: [
                      Switch(
                          value: unitSet,
                          onChanged: (bool set) {
                            Settings.temperatureUnitsToggled();
                            WeatherCon().refresh();
                            Navigator.pop(context);
                          })
                    ]),
                  )),
            ]));
  }
}
