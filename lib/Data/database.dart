
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database_name.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }
  String formatTechMapping(List<TechMapping>? techMapping) {
    return techMapping?.isNotEmpty ?? false
        ? techMapping!.map((techMap) => techMap.techName).join(', ')
        : '';
  }
  // Future<void> _createDb(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE gridItems (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       projectName TEXT,
  //       imageMapping TEXT,
  //       techMapping TEXT,
  //       domainName TEXT,
  //       description TEXT
  //     )
  //   ''');
  // }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE gridItems (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      projectName TEXT,
      imageMapping TEXT,
   
      techMapping TEXT,
      domainName TEXT,
      description TEXT
    )
  ''');
  }

  Future<void> saveDataToDatabase(Data data) async {
    // Convert techMapping list to JSON string
    String techMappingJson = json.encode(data.techMapping);

    // Convert imageMapping list to JSON string
    String imageMappingJson = json.encode(data.imageMapping);

    // Create a map of values to be inserted into the database
    Map<String, dynamic> row = {
      'projectName': data.projectName,
      'techMapping': techMappingJson, // Save techMapping as JSON string
      'imageMapping': imageMappingJson, // Save imageMapping as JSON string
      'domainName': data.domainName,
      'description': data.description,
    };

    // Check if the data already exists in the database based on projectName
    Database db = await instance.database;
    List<Map<String, dynamic>> existingData = await db.query(
      'gridItems',
      where: 'projectName = ?',
      whereArgs: [data.projectName],
    );

    if (existingData.isEmpty) {
      // If data with the same projectName does not exist, insert the data into the database
      await db.insert('gridItems', row);
    } else {
      // If data with the same projectName already exists, you can choose to update it or ignore it
      // For example, you can update the existing data with the new values
      await db.update(
        'gridItems',
        row,
        where: 'projectName = ?',
        whereArgs: [data.projectName],
      );
      // Alternatively, you can ignore the new data and do nothing
      // To ignore, simply don't perform any action here
    }
  }

  //
  Future<List<Data>> loadDataFromDatabase() async {
    List<Map<String, dynamic>> rows = await getAllGridItems();
    List<Data> dataList = rows.map((row) {
      // Parse techMapping from JSON string
      List<TechMapping> techMappingList = (json.decode(row['techMapping']) as List<dynamic>)
          .map((dynamic item) => TechMapping.fromJson(item))
          .toList();

      // Parse imageMapping from JSON string
      List<ImageMapping> imageMappingList = (json.decode(row['imageMapping']) as List<dynamic>)
          .map((dynamic item) => ImageMapping.fromJson(item))
          .toList();

      return Data(
        projectName: row['projectName'],
        techMapping: techMappingList,
        imageMapping: imageMappingList,
        domainName: row['domainName'],
        description: row['description'],
      formattedTechMapping: '', urlLink: null, // Ensure 'urlLink' field exists in your Data class
      );
    }).toList();

    return dataList;
  }

// ... other methods ...


  Future<void> initializeDatabase() async {
    _database = await _initDatabase();
  }
  Future<void> insertData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert('gridItems', row);
  }

  Future<List<Map<String, dynamic>>> getAllGridItems() async {
    Database db = await instance.database;
    return await db.query('gridItems');
  }
  Future<void> saveFilterToDatabase(Filter filter) async {
    Database db = await instance.database;
    await db.insert('filters', filter.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Filter>> getAllFilters() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('filters');

    return List.generate(maps.length, (index) {
      return Filter.fromMap(maps[index]);
    });
  }
}
class Filter {
  final int id;
  final String title;
  bool isSelected;

  Filter({required this.id, required this.title, this.isSelected = false});

  // Convert a Filter object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isSelected': isSelected ? 1 : 0,
    };
  }

  // Create a Filter object from a Map
  factory Filter.fromMap(Map<String, dynamic> map) {
    return Filter(
      id: map['id'],
      title: map['title'],
      isSelected: map['isSelected'] == 1,
    );
  }
}

