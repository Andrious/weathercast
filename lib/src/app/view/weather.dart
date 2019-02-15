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
///          Created  13 Feb 2019
///
///

import 'dart:async' show Completer;

import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Colors,
        EdgeInsets,
        Icon,
        IconButton,
        Icons,
        Key,
        ListView,
        MaterialApp,
        MaterialPageRoute,
        Navigator,
        Padding,
        RefreshIndicator,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget,
        WidgetBuilder,
        required;

import 'package:mvc_application/mvc.dart' show StateMVC;

import 'package:weathercast/src/app/model.dart' as model;

import 'package:weathercast/src/app/view.dart'
    show
        CitySelection,
        WeatherTemperature,
        GradientContainer,
        LastUpdated,
        Location;

import 'package:weathercast/src/app/controller.dart' show WeatherCon, ThemeCon;

class WeatherApp extends StatefulWidget {
  WeatherApp({Key key}) : super(key: key);

  @override
  State createState() => _WeatherAppState();
}

class _WeatherAppState extends StateMVC<WeatherApp> {
  _WeatherAppState() : super(ThemeCon());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeCon.theme,
      home: Weather(),
    );
  }
}

class Weather extends StatefulWidget {
  Weather({Key key}) : super(key: key);

  @override
  State createState() => _WeatherState();
}

class _WeatherState extends StateMVC<Weather> {
  WeatherCon _weatherCon = WeatherCon();
  Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              _weatherCon.fetchWeather(city: city).then((weather) {
                ThemeCon.weatherChanged(condition: weather?.condition)
                    .refresh();
                refresh();
              });
            },
          )
        ],
      ),
      body: Center(
        child: BuildWidget(builder: (_) {
          if (_weatherCon.city == null) {
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
                _weatherCon.refreshWeather(city: _weatherCon.city).then((weather) {
                  ThemeCon.weatherChanged(condition: weather?.condition).refresh();
                  refresh();
                });
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

class BuildWidget extends StatefulWidget {
  BuildWidget({@required this.builder, Key key}) : super(key: key);
  final WidgetBuilder builder;
  @override
  State createState() => _WidgetBuilderState();
}

class _WidgetBuilderState extends State<BuildWidget> {
  @override
  Widget build(BuildContext context) => widget.builder(context);
}
