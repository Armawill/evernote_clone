import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    // await sql.deleteDatabase(path.join(dbPath, 'notes.db'));
    return sql.openDatabase(
      path.join(dbPath, 'notes.db'),
      onCreate: _createDb,
      onOpen: _openDB,
      version: 1,
    );
  }

  static Future<void> _openDB(sql.Database db) async {
    // await db.execute('DROP TABLE user_notes');
    // db.execute(
    //     'CREATE TABLE user_notes(id TEXT PRIMARY KEY, title TEXT, text TEXT, date TEXT, notebook TEXT, isInTrash INTEGER)');
  }

  static Future<void> _createDb(sql.Database db, int version) async {
    await db.execute(
        'CREATE TABLE user_notes(id TEXT PRIMARY KEY, title TEXT, text TEXT, date TEXT, notebook TEXT, isInTrash INTEGER)');
    await db.execute(
        'CREATE TABLE user_notebooks(id TEXT PRIMARY KEY, title TEXT)');
    await db.insert(
      'user_notebooks',
      {
        'id': DateTime.now().toString(),
        'title': 'Interesting',
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getNotebooks(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getNotesForNotebook(
      String table, String notebook) async {
    final db = await DBHelper.database();
    return db.query(
      table,
      where: 'notebook = ?',
      whereArgs: [notebook],
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(
      table,
      where: 'id == ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
