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

  static Future<List<Location>> getLocations() async {
    return Location.listLocations(await LocationMod()
        .rawQuery('SELECT * FROM $tableName WHERE deleted = 0'));
  }

  static String get city => _city;
  static String _city = Prefs.getString('city', 'Chicago');

  static Future<bool> saveLocation({String city}) async {
    bool saved = false;
    if (city == null || city.isEmpty)
      int index = lst.firstWhere(test);
    if (index >= 0) result = lst[index];
      saved = await LocationMod().saveMap(tableName, {'city': city});
    return saved;
  }

  Future onConfigure(Database db) {
    return db.execute("PRAGMA foreign_keys=ON;");
  }
}

class Location<E> implements Comparable<Location> {
  Location.fromMap(Map m) {
    city = m["city"];
  }

  Map get toMap => {"city": _city};

  String get city => _city;
  set city(String value) {
    if (value == null) value = "";
    _city = value.trim();
  }

  String _city;

  int compareTo(Location other) => _city.compareTo(other._city);

  static Future<List<Location>> listLocations(
      List<Map<String, dynamic>> query) async {
    List<Location> locationList = [];
    for (Map city in query) {
      Location location = Location.fromMap(city);
      locationList.add(location);
    }
    return locationList;
  }
}
