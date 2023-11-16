import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/domain.dart';

class DomainDatabase {
  static Future<Database> get database async {
    final String dbName = 'domain_database.db';
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE domains(id TEXT PRIMARY KEY, domainName TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertDomains(List<DomainData> domains) async {
    final Database db = await database;
    Batch batch = db.batch();
    domains.forEach((domain) {
      batch.insert(
        'domains',
        {
          'id': domain.id,
          'domainName': domain.domainName,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit();
  }
  static Future<List<DomainData>> getDomains() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('domains');
    return List.generate(maps.length, (i) {
      return DomainData(
        id: maps[i]['id'],
        domainName: maps[i]['domainName'],
      );
    });
  }
}
