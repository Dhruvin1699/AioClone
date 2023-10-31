import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/tech.dart';


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TechDatabase {
  static Future<Database> get database async {
    final String dbName = 'tech_database.db';
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tech(id TEXT PRIMARY KEY, techName TEXT)',
        );
      },
      version: 1,
    );
  }

  // static Future<void> insertTech(String id, String techName) async {
  //   final Database db = await database;
  //   await db.insert(
  //     'tech',
  //     {
  //       'id': id,
  //       'techName': techName,
  //     },
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
  static Future<void> insertTechStack(List<TechData> techStack) async {
    final Database db = await database;
    Batch batch = db.batch();
    techStack.forEach((tech) {
      batch.insert(
        'tech',
        {
          'id': tech.id,
          'techName': tech.techName,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit();
  }


  static Future<List<TechData>> getTechStack() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tech');
    return List.generate(maps.length, (i) {
      return TechData(
        id: maps[i]['id'],
        techName: maps[i]['techName'],
      );
    });
  }
}
