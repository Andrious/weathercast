///
/// Copyright (C) 2019 Felix Angelov of Skokie, Illinois
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

import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        EdgeInsets,
        Expanded,
        Form,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        Navigator,
        Padding,
        Row,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        TextEditingController,
        TextFormField,
        Widget;

import 'package:weathercast/src/home/view/drawer/weather_locations/mvc.dart' show LocationTimer;

class CitySelection extends StatefulWidget {
  @override
  State<CitySelection> createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState(){
    super.initState();
    LocationTimer.initState();
  }

  @override
  void dispose(){
    LocationTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City'),
      ),
      body: Form(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Chicago',
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context, _textController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
