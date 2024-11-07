import 'package:sqflite/sqflite.dart';
import 'package:pass_guard/models/credential.dart';
import 'database_service.dart';

class PassGuardDb {
  final tableName = 'credentials';
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        "title" TEXT NOT NULL,
        "email" TEXT NOT NULL,
        "password" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
        );""");
  }

  Future<int> create(
      {required String title,
      required String email,
      required String password}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName(title,email,password) VALUES (?,?,?)''',
      [title, email, password],
    );
  }

  Future<List<Credential>> fetchAll() async {
    final database = await DatabaseService().database;
    final credentials =
        await database.rawQuery('''SELECT * from $tableName;''');
    return credentials
        .map((cred) => Credential.fromSqfliteDatabase(cred))
        .toList();
  }

  Future<Credential> fetchById(int id) async {
    final database = await DatabaseService().database;
    final credentials = await database
        .rawQuery('''SELECT * from $tableName where id=?''', [id]);
    return Credential.fromSqfliteDatabase(credentials.first);
  }

  Future<int> update({required int id, required String? title}) async {
    final database = await DatabaseService().database;

    return await database.update(
      tableName,
      {
        if (title != null) 'title': title,
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
