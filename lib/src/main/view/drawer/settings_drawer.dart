///
/// Copyright (C) 2018 Andrious Solutions
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
///          Created  10 Sep 2018
///

import 'package:flutter/material.dart';

import 'package:weathercast/src/view.dart' show StateMVC, TemperatureUnits;

import 'package:weathercast/src/controller.dart';

import 'package:weathercast/src/main/view/drawer/weather_locations/mvc.dart'
    as loc show LocationCon, DemoItem;

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer({this.con, Key key}) : super(key: key);
  final Switcher con;
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends StateMVC<SettingsDrawer> {
  _SettingsDrawerState() : super(loc.LocationCon());
  List<loc.DemoItem<dynamic>> _demoItems;
  double _discreteValue = LocationTimer.intervals.toDouble();

  @override
  void initState() {
    super.initState();
    LocationTimer.initState();
    _demoItems = loc.LocationCon().listLocations(
        state: this,
        onSaved: (String v) {
          WeatherCon().getWeather(v);
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    LocationTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool unitSet = widget.con.temperatureUnits == TemperatureUnits.celsius;
    String unitLabel = unitSet ? 'Celsius' : 'Fahrenheit';
    String subTitle =
        'Use ${unitSet ? 'metric' : 'imperial'} measurements for temperatur untis';
    return Drawer(
      child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Settings',
                style: const TextStyle(color: Colors.white),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Text(unitLabel),
            ListTile(
              title: const Text('Temperature Untis'),
              subtitle: Text(subTitle),
              trailing: Switch(
                value: unitSet,
                onChanged: widget.con.onChanged,
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Container(
                margin: const EdgeInsets.all(24.0),
                child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _demoItems[index].isExpanded = !isExpanded;
                      });
                    },
                    children: _demoItems.map((loc.DemoItem<dynamic> item) {
                      return ExpansionPanel(
                          isExpanded: item.isExpanded,
                          headerBuilder: item.headerBuilder,
                          body: item.build());
                    }).toList()),
              ),
            ),
            Slider(
              value: _discreteValue,
              min: 2.0,
              max: 10.0,
              divisions: 1,
              label: '${_discreteValue.round()}',
              onChanged: (double value) {
                setState(() {
                  _discreteValue = value;
                  Navigator.pop(context);
                });
              },
            ),
          ]),
    );
  }

  static void onTap() {
    var test = true;
  }
}

class Switcher {
  Switcher({this.temperatureUnits, this.onChanged});
  TemperatureUnits temperatureUnits = TemperatureUnits.celsius;
  ValueChanged<bool> onChanged = (bool value) {};
}
