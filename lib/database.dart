import 'package:flutter_complete_guide/speeds.dart';
import 'package:hive/hive.dart';

class DatabaseService {
  var speedBoxdb;
  var store;
  var factory;

  void createDatabase() async {
    speedBoxdb = await Hive.openBox('Lichtschranke-db');
  }

  void insertIntoDatabase(Speeds speedItem) async {
    speedBoxdb.add(speedItem);
  }
}
