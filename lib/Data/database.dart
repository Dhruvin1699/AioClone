import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  bool isDataLoaded = false;
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initializeDatabaseAndLoadData() async {
    _database = await _initDatabase();
    await loadDataFromDatabase(); // Load data on initialization
    isDataLoaded = true;
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

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE gridItems (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      projectName TEXT ,
      imageMapping TEXT,
      techMapping TEXT,
      domainName TEXT,
      description TEXT,
      domainID TEXT,
      techID TEXT
  
    )
  ''');
  }
Future<List<Map<String, dynamic>>?> getPaginatedData(int limit, int offset) async {
    return await _database?.rawQuery(
      'SELECT * FROM gridItems LIMIT ? OFFSET ?',
      [limit,offset]

    );
  }

  Future<void> saveDataToDatabase(Data data) async {
    // Convert techMapping list to JSON string
    String techMappingJson = json.encode(data.techMapping);

    // Convert imageMapping list to JSON string
    String imageMappingJson = json.encode(data.imageMapping);

    String? localImagePath = data.imageMapping != null && data.imageMapping!.isNotEmpty
        ? "/data/user/0/com.example.aioaapbardemo/app_flutter/${data.imageMapping![0].localImagePath}"
        : null;
    Map<String, dynamic> row = {
      'projectName': data.projectName,
      'techMapping': techMappingJson,
      'imageMapping': imageMappingJson,
      'domainName': data.domainName,
      'description': data.description,
      'domainID': data.domainID,
      'techID': (data.techMapping != null && data.techMapping!.isNotEmpty)
          ? data.techMapping![0].techID
          : null,
      'localImagePath': localImagePath,

    };

    // Check if the data already exists in the database based on projectName
    Database db = await instance.database;
    List<Map<String, dynamic>> existingData = await db.query(
      'gridItems',
      where: 'projectName = ?',
      whereArgs: [data.projectName],
    );

    if (existingData.isEmpty) {
      // If data with the same projectName does not exist, i'techID': data.techMapping != null && data.techMapping.isNotEmpty ? data.techMapping[0].techID : null,nsert the data into the database
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


  Future<void> updateLocalImagePath(String projectName, String localImagePath) async {
    // Prepend the path to the existing localImagePath
    String fullPath = "/data/user/0/com.example.aioaapbardemo/app_flutter/$localImagePath";

    Database db = await instance.database;
    await db.update(
      'gridItems',
      {'localImagePath': fullPath},
      where: 'projectName = ?',
      whereArgs: [projectName],
    );
  }



  Future<List<Data>> loadDataFromDatabase() async {

    List<Map<String, dynamic>> rows = await getAllGridItems();
    List<Data> dataList = rows.map((row) {
      // Parse techMapping from JSON string
      List<TechMapping> techMappingList =
      (json.decode(row['techMapping']) as List<dynamic>)
          .map((dynamic item) => TechMapping.fromJson(item))
          .toList();

      // Parse imageMapping from JSON string
      List<ImageMapping> imageMappingList =
          (json.decode(row['imageMapping']) as List<dynamic>)
              .map((dynamic item) => ImageMapping.fromJson(item))
              .toList();

      return Data(
        projectName: row['projectName'],
        techMapping: techMappingList,
        imageMapping: imageMappingList,
        domainName: row['domainName'],
        description: row['description'],
        formattedTechMapping: formatTechMapping(techMappingList),
        urlLink: null, // Ensure 'urlLink' field exists in your Data class
      );
    }).toList();

    return dataList;
  }

  //
  Future<List<Data>> fetchDataByDomainAndTechID(
      String? domainID, String? techID) async {
    final db = await instance.database;

    if (domainID != null && techID != null) {
      print('Domain ID: $domainID, Tech ID: $techID');
      final result = await db.rawQuery('''
      SELECT * FROM gridItems WHERE domainID = ? OR techID = ?
    ''', [domainID, techID]);

      List<Data> data = [];

      for (var row in result) {
        // Explicitly cast the row values to expected types
        List<TechMapping> techMappingList =
            (json.decode(row['techMapping'] as String) as List<dynamic>)
                .map((dynamic item) => TechMapping.fromJson(item))
                .toList();

        List<ImageMapping> imageMappingList =
            (json.decode(row['imageMapping'] as String) as List<dynamic>)
                .map((dynamic item) => ImageMapping.fromJson(item))
                .toList();

        data.add(Data(
          projectName: row['projectName'] as String,
          techMapping: techMappingList,
          imageMapping: imageMappingList,
          domainName: row['domainName'] as String,
          description: row['description'] as String,
          formattedTechMapping: '',
          urlLink: null,
          // Add other fields accordingly
        ));
      }
      data.forEach((item) {
        print('Fetched Data: $item');
      });
      return data;

    } else if (domainID != null) {
      // Handle the case where only domain ID is provided
      final result = await db.rawQuery('''
      SELECT * FROM gridItems WHERE domainID = ?
    ''', [domainID]);

      // Process result and return data
    } else if (techID != null) {
      // Handle the case where only tech ID is provided
      final result = await db.rawQuery('''
      SELECT * FROM gridItems WHERE techID = ?
    ''', [techID]);

      // Process result and return data
    }

    // Handle the case when both domain ID and tech ID are null
    return [];
  }


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

  }
