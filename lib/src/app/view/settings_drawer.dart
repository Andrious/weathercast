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

import 'package:weathercast/src/app/view.dart';

import 'package:weathercast/src/app/controller.dart';

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer({this.con, Key key}) : super(key: key);
  final Switcher con;
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  List<DemoItem<dynamic>> _demoItems;

  @override
  void initState() {
    super.initState();
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
                    children: _demoItems.map((DemoItem<dynamic> item) {
                      return ExpansionPanel(
                          isExpanded: item.isExpanded,
                          headerBuilder: item.headerBuilder,
                          body: item.build()
                      );
                    }).toList()
                ),
              ),
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
