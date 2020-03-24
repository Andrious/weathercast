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
///          Created  21 Feb 2019
///
///

import 'dart:core'
    show Duration, Future, List, String, bool, dynamic, int;

import 'dart:async' show Future, Timer;

import 'package:flutter/material.dart';

import 'package:weathercast/src/view.dart' show StateMVC;

import 'package:weathercast/src/controller.dart'
    show ControllerMVC, Prefs, WeatherCon;

import 'package:weathercast/src/home/view/drawer/weather_locations/mvc.dart'
    show DemoItem, LocationMod, weatherLocations;

/// Weather forecast locations controller.
class LocationCon extends ControllerMVC {
  factory LocationCon() {
    _this ??= LocationCon._();
    return _this;
  }
  // Make only one instance of this class.
  static LocationCon _this;
  LocationCon._();

  static List<String> get locations => _locations;
  static List<String> _locations;

  static String get value => _value;
  static String _value = LocationMod.city;

  /// Called by the App's init() function.
  Future<bool> init() async {
    bool init = await LocationMod.openDB();
    try {
      if (init) {
        _locations = await LocationMod.getLocations();
      }
    } catch (ex) {
      _locations = [];
    }
    return init;
  }

  /// Return a list of locations.
  List<DemoItem<dynamic>> listLocations(
          {StateMVC state, FormFieldSetter<String> onSaved}) =>
      weatherLocations(state: state, onSaved: onSaved);

  /// Called to retrieve the list of Weather forecast locations.
  Future<List<String>> rebuild() async {
    _locations = await LocationMod.getLocations();
    super.refresh();
    return _locations;
  }

  /// Returns a row representing one particular location.
  static Row option(int index, FormFieldState<String> field) {
    String location = _locations?.elementAt(index);
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Radio<String>(
        value: location,
        groupValue: field.value,
        onChanged: field.didChange,
      ),
      Text(location),
      FlatButton(
        onPressed: () {
          LocationCon().delete(location);
        },
        child: Icon(Icons.clear, color: Colors.grey),
      ),
    ]);
  }

  /// Save the specified location to the database.
  Future<bool> save(String value) => LocationMod.saveLocation(city: value);

  Future<bool> delete(String value) async {
    bool delete = await LocationMod.deleteCity(value);
    refresh();
    return delete;
  }
}

typedef TimerCallback = void Function(Timer timer);

/// The Location Timer to 'cycle' through the weather forecast location.
class LocationTimer {
  static Timer _timer;

  /// A counter to iterate through the locations.
  static int _index = 0;

  /// Number of seconds between intervals.
  static int _seconds = 0;

  /// The callback function executed between intervals.
  static TimerCallback _callback = _timerCallback;

  /// Gets the number of seconds between intervals.
  static int get intervals => _seconds;

  /// Called in the App's init() function.
  static Future<bool> init() async {
    _index = LocationCon._locations.indexOf(LocationCon.value);
    int seconds = await Prefs.getIntF('intervals');
    setTimer(seconds: seconds);
    return Future.value(true);
  }

  /// Turn off the timer
  static void initState() {
    cancel();
  }

  /// Restart the timer.
  static void dispose() {
    setTimer();
  }

  /// Starts the timer with the specified interval and callback function.
  static void setTimer({int seconds, TimerCallback callback}) {
    if (seconds != null) {
      if (seconds < 0) seconds = 0;
      _seconds = seconds;
    }
    if (_seconds == 0) {
      cancel();
      return;
    }
    if (callback != null) {
      cancel();
      _callback = callback;
    }
    if (_callback == null) {
      cancel();
      return;
    }
    _timer = Timer.periodic(Duration(seconds: _seconds), _callback);
    Prefs.setInt('intervals', _seconds);
  }

  /// Turn off the Timer.
  static void cancel() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
  }

  /// The Callback timer assigned by default.
  static _timerCallback(Timer timer) {
    List<String> locations = LocationCon.locations;
    if (locations == null || locations.length < 2) return;
    if (_index < 0) _index = 0;
    String location = locations.elementAt(_index);
    _index++;
    if (_index == locations.length) _index = 0;
    WeatherCon().getWeather(location);
  }
}
