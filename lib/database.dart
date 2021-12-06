import 'package:flutter_complete_guide/speeds.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast.dart';

class DatabaseService {
  var db;
  var store;
  var factory;

  void createDatabase() async {
    // Declare our store (records are mapd, ids are ints)
    store = intMapStoreFactory.store();
    factory = databaseFactoryWeb;

    // Open the database
    db = await factory.openDatabase('Lichtschranke-db');
  }

  void insertIntoDatabase(List<Speeds> speed) async {
    print(store);
    var speedMap = Map.fromIterable(speed, key: (e) => e.date, value: (e) => e.speed);
    print(speedMap);
    await store.add(db, speedMap);
  }
}
