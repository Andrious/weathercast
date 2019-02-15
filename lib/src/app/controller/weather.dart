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

import 'package:mvc_application/controller.dart' show ControllerMVC;

import 'package:weathercast/src/app/model.dart' as mod show Weather;

import 'package:weathercast/src/app/controller.dart' show WeatherCon, WeatherRepository;

class WeatherCon extends ControllerMVC {
  static WeatherCon _this;

  factory WeatherCon() {
    if (_this == null) _this = WeatherCon._();

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
  bool _error;

  Future<mod.Weather> fetchWeather({String city}) async {
    _city = city;
    _weather = null;
    _error = false;
    try {
      _weather = await weatherRepository.getWeather(city);
    }catch(_){
      _error = true;
    }
    return _weather;
  }

  Future<mod.Weather> refreshWeather({String city}) async {
    try {
      var weather = await weatherRepository.getWeather(city);
      _weather = weather;
    } catch (_) {}
    return _weather;
  }
}
