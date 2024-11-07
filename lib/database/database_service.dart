import 'package:pass_guard/database/credentials_table.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = "pass_guard.db";
    final path = await getDatabasesPath();
    //join method helps to construct full path
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    return PassGuardDb().createTable(database);
  }
}
