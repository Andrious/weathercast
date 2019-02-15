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

import 'package:flutter/material.dart' show Colors, MaterialColor, ThemeData;

import 'package:weathercast/src/app/model.dart' show WeatherCondition;

import 'package:mvc_application/controller.dart' show ControllerMVC;

class ThemeCon extends ControllerMVC {
  static ThemeCon _this;
  static ThemeData theme;
  static MaterialColor color;

  factory ThemeCon() {
    if (_this == null) _this = ThemeCon._();

    return _this;
  }
  ThemeCon._();

  static ThemeCon weatherChanged({WeatherCondition condition}) {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        theme = ThemeData(
          primaryColor: Colors.orangeAccent,
        );
        color = Colors.yellow;
        break;
      case WeatherCondition.hail:
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
        theme = ThemeData(
          primaryColor: Colors.lightBlueAccent,
        );
        color = Colors.lightBlue;
        break;
      case WeatherCondition.heavyCloud:
        theme = ThemeData(
          primaryColor: Colors.blueGrey,
        );
        color = Colors.grey;

        break;
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        theme = ThemeData(
          primaryColor: Colors.indigoAccent,
        );
        color = Colors.indigo;

        break;
      case WeatherCondition.thunderstorm:
        theme = ThemeData(
          primaryColor: Colors.deepPurpleAccent,
        );
        color = Colors.deepPurple;
        break;
      case WeatherCondition.unknown:
        theme = ThemeData.light();
        color = Colors.lightBlue;
        break;
    }
    return _this;
  }
}
