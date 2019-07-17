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

import 'package:weathercast/src/controller.dart';

class LocationMod extends DBInterface {
  factory LocationMod() {
    _this ??= LocationMod._();
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
    locations = await getRecs();
    for (Map location in locations) {
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
      Map<String, dynamic> rec = await LocationMod().saveMap(tableName, {'city': city});
      saved = rec.isNotEmpty;
      if (saved) _locations.add(city);
    }
    return saved;
  }

  static Future<List<Map<String, dynamic>>> getRecs() async {
    List<Map<String, dynamic>> recs;

    try {
      recs = await LocationMod()
          .rawQuery('SELECT * FROM $tableName WHERE deleted = 0');
    } catch (ex) {
      recs = [];
    }
    return recs;
  }

  static Future<bool> deleteRec(String city) async {
    List<Map<String, dynamic>> recs = await getRecs();
    int id = -1;
    for (Map<String, dynamic> rec in recs) {
      if (rec['city'] == city) {
        id = rec['id'];
        break;
      }
    }
    bool delete = id > -1;
    if(delete) delete = await LocationMod().delete(tableName, id) > 0;
    return delete;
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
