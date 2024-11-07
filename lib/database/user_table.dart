import 'package:pass_guard/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class UserTable {
  final tableName = 'user';
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        
        "email" TEXT NOT NULL,
        "password" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
        );""");
  }

  Future<int> create({required String email, required String password}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName(email,password) VALUES (?,?)''',
      [email, password],
    );
  }

  Future<List<User>> fetchAll() async {
    final database = await DatabaseService().database;
    final user = await database.rawQuery('''SELECT * from $tableName;''');
    return user.map((u) => User.fromSqfliteDatabase(u)).toList();
  }

  Future<User> fetchById(int id) async {
    final database = await DatabaseService().database;
    final user = await database
        .rawQuery('''SELECT * from $tableName where id=?''', [id]);
    return User.fromSqfliteDatabase(user.first);
  }

  Future<int> update({required int id, required String? password}) async {
    final database = await DatabaseService().database;

    return await database.update(
      tableName,
      {
        if (password != null) 'password': password,
      },
      where: 'id=?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id=?''', [id]);
  }
}
