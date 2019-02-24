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

import 'package:mvc_application/mvc.dart' show DBInterface, Database, Prefs;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;

class LocationMod extends DBInterface {
  factory LocationMod() {
    if (_this == null) _this = LocationMod._();
    return _this;
  }
  // Make only one instance of this class.
  static LocationMod _this;
  LocationMod._();

  @override
  get name => 'Weather';

  @override
  get version => 1;

  static const String tableName = 'Locations';
  static List<String> _locations = [];

  @override
  Future onCreate(Database db, int version) async {
    await db.execute("""
     CREATE TABLE $tableName(
              id INTEGER PRIMARY KEY
              ,city TEXT
              ,deleted INTEGER DEFAULT 0
              )
     """);
  }

  static Future<bool> openDB() => LocationMod().open();

  static void dispose() => LocationMod().disposed();

  static Future<List<String>> getLocations() async {
    List<Map<String, dynamic>> locations;

    try {
      locations = await LocationMod()
        .rawQuery('SELECT * FROM $tableName WHERE deleted = 0');
    }catch(ex){
      locations = [];
    }
    for(Map location in locations){
      _locations.add(location['city']);
    }
    return _locations;
  }

  static String get city => _city;
  static String _city = Prefs.getString('city', 'Chicago');

  static Future<bool> saveLocation({String city}) async {
    bool saved = true;
    if (city == null || city.isEmpty) return saved;
    _city = city;
    if (!_locations.contains(city)) {
      saved = await LocationMod().saveMap(tableName, {'city': city});
      if (saved) _locations.add(city);
    }
    return saved;
  }

  Future onConfigure(Database db) {
    return db.execute("PRAGMA foreign_keys=ON;");
  }
}
