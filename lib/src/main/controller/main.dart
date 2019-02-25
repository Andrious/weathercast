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

import 'package:flutter/material.dart';

import 'package:weathercast/src/model.dart' as mod show Weather;

import 'package:weathercast/src/view.dart';

import 'package:weathercast/src/controller.dart';

class WeatherCon extends ControllerMVC {
  static WeatherCon _this;

  factory WeatherCon() {
    if (_this == null) {
      _this = WeatherCon._();
    }

    return _this;
  }
  WeatherCon._();

  final WeatherRepository weatherRepository = WeatherRepository();

  String get city => _city;
  String _city;

  mod.Weather get weather => _weather;
  mod.Weather _weather;

  Future<mod.Weather> get future => Future.value(_weather);

  bool get error => _error;
  bool _error = false;

  @override
  void initState() => initFetch();

  /// Initially retrieve 'the last' city forecast.
  Future<void> initFetch() async {
    _city = Prefs.getString('city');
    await getWeather(_city);
  }

  /// Fetch the data from the database.
  Future<mod.Weather> fetchWeather({String city}) async {
    if (city == null) return _weather;
    _city = city;
    _weather = null;
    _error = false;
    try {
      _weather = await weatherRepository.getWeather(city);
      Prefs.setString('city', _city);
      LocationCon().save(_city);
    } catch (_) {
      _error = true;
    }
    return _weather;
  }

  Future<void> getWeather(String city) =>
      fetchWeather(city: city).then((weather) => rebuild());

  /// Rebuild the Widget tree.
  void rebuild() {
    ThemeCon.weatherChanged(condition: weather?.condition).refresh();
    refresh();
  }

  Future<mod.Weather> refreshWeather({String city}) async {
    try {
      var weather = await weatherRepository.getWeather(city);
      // If there's no error. Record the response.
      _weather = weather;
    } catch (_) {}
    return _weather;
  }

  Switcher settingsDrawer(BuildContext context) => Switcher(
      temperatureUnits: Settings.temperatureUnits,
      onChanged: (bool set) {
        Settings.temperatureUnitsToggled();
        WeatherCon().refresh();
        Navigator.pop(context);
      });

  /// Called by the View's onPressed() function.
  void onPressed(String city) => getWeather(city);

  void onRefresh() {
    refreshWeather(city: city).then((weather) {
      rebuild();
    });
  }

  void weatherInterval({int seconds}) {
    LocationTimer.setTimer(seconds: seconds);
  }
}
