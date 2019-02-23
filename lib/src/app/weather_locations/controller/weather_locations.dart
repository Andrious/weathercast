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

import 'package:flutter/material.dart';

import 'package:mvc_application/mvc.dart';

import 'package:weathercast/src/app/weather_locations/mvc.dart';

class LocationCon extends ControllerMVC {
  factory LocationCon() {
    if (_this == null) _this = LocationCon._();
    return _this;
  }
  // Make only one instance of this class.
  static LocationCon _this;
  LocationCon._();

  static List<Location> get locations => _locations;
  static List<Location> _locations;

  static String get value => _value;
  static String _value;

  Future<bool> init() async {
    bool init = await LocationMod.openDB();
    if (init) _locations = await LocationMod.getLocations();
    return init;
  }

  @override
  void initState() {
    _value = LocationMod.city;
  }

  List<DemoItem<dynamic>> listLocations(StateMVC state) =>
      weatherLocations(state);

  Future<List<Location>> rebuild() async {
    _locations = await LocationMod.getLocations();
    super.refresh();
    return _locations;
  }

  static Row option(int index, FormFieldState<String> field) {
    Location location = _locations?.elementAt(index);
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Radio<String>(
        value: location.city,
        groupValue: field.value,
        onChanged: field.didChange,
      ),
      const Text('Bahamas')
    ]);
  }

  static void save(String value){
    LocationMod.saveLocation(city: value);

  }
}
