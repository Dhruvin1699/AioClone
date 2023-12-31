import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:aioaapbardemo/model/model.dart';
import 'package:aioaapbardemo/Data/database.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:aioaapbardemo/Data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../../Data/domaindatabse.dart';
import '../../Data/techdatabse.dart';
import '../../model/domain.dart';
import '../../model/tech.dart';
class ApiService {
  static bool isDataLoaded = false; // Add this line to define isDataLoaded
  static  DatabaseHelper _databaseHelper = DatabaseHelper.instance;// Add this line to define _databaseHelper
  static List<Data> gridData = [];

  static Future<List<Data>> fetchDataFromApi(int pageKey, List<String> selectedFilterIds, PagingController<int, Data> _pagingController, int itemsPerPage) async {
    try {
      List<Data> newData;

      // Check if there are no selected filters
      if (selectedFilterIds.isEmpty) {
        String apiUrl =
            'https://api.tridhyatech.com/api/v1/portfolio/list-mobile?page=$pageKey&limit=$itemsPerPage';

        print('Calling API: $apiUrl');
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final Autogenerated data = Autogenerated.fromJson(responseData);

          newData = data.data ?? [];
        } else {
          throw Exception('Failed to load data from API');
        }
      } else {
        String queryParameters =
            'domain_id=${selectedFilterIds[0]}&tech_id=${selectedFilterIds[1]}&page=$pageKey&limit=$itemsPerPage';
        String apiUrl =
            'https://api.tridhyatech.com/api/v1/portfolio/list?$queryParameters';

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final Autogenerated data = Autogenerated.fromJson(responseData);

          newData = data.data ?? [];
        } else {
          throw Exception('Failed to load data from API');
        }
      }

      // if (newData.isNotEmpty) {
      //   // Increment page number only if new data is available
      //   pageKey++;
      //
      //   for (var item in newData) {
      //     await _databaseHelper.insertData({
      //       'projectName': item.projectName,
      //       'imageMapping': json.encode(item.imageMapping),
      //       'techMapping': json.encode(item.techMapping),
      //       'domainName': item.domainName,
      //       'description': item.description,
      //       'domainID': item.domainID,
      //       'techID': (item.techMapping != null && item.techMapping!.isNotEmpty)
      //           ? item.techMapping![0].techID
      //           : null,
      //     });
      //
      //     print('Data inserted into the database for projectName: ${item.projectName}');
      //   }
      //
      //   _pagingController.appendPage(newData, pageKey);
      // }
      if (newData.isNotEmpty) {
        // Increment page number only if new data is available
        pageKey++;

        for (var item in newData) {
          Database db = await _databaseHelper.database;
          List<Map<String, dynamic>> existingData = await db.query(
            'gridItems',
            columns: ['projectName'],
            where: 'projectName = ?',
            whereArgs: [item.projectName],
          );
          if (existingData.isEmpty) {
            // If data with the same projectName does not exist, insert the data into the database
            await _databaseHelper.insertData({
              'projectName': item.projectName,
              'imageMapping': json.encode(item.imageMapping),
              'techMapping': json.encode(item.techMapping),
              'domainName': item.domainName,
              'description': item.description,
              'domainID': item.domainID,
              'techID': (item.techMapping != null && item.techMapping!.isNotEmpty)
                  ? item.techMapping![0].techID
                  : null,
            });

            print('Data inserted into the database for projectName: ${item.projectName}');
          } else {
            print('Data already exists in the database for projectName: ${item.projectName}');
          }
        }

        _pagingController.appendPage(newData, pageKey);
      }
      else {
        _pagingController.appendLastPage([]);
      }

      return newData; // Return the fetched data
    } catch (e) {
      print('Error: $e');
      // Handle errors here if needed
      throw e;
    }
  }

  static Future<void> downloadAndSaveImage(Data item) async {
    // Your existing downloadAndSaveImage logic
    for (var imageMapping in item.imageMapping!) {
      String imageUrl = 'https://api.tridhyatech.com/${imageMapping.portfolioImage}';
      String directory = (await getApplicationDocumentsDirectory()).path;
      String imagePath = path.join(directory, imageMapping.portfolioImage);

      if (File(imagePath).existsSync()) {
        // Image already exists locally, use the local path
        imageMapping.localImagePath = imagePath;
      } else {
        // Check if the app is offline before making an HTTP request
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          // App is offline, use a placeholder or handle accordingly
          // For example, you can set localImagePath to null or an empty string
          imageMapping.localImagePath = null;
        } else {
          // App is online, download and save the image
          http.Response response = await http.get(Uri.parse(imageUrl));
          Uint8List bytes = response.bodyBytes;

          print('Image URL: $imageUrl');
          print('Saving image to: $imagePath');

          await File(imagePath).writeAsBytes(bytes);
          imageMapping.localImagePath = imagePath;
        }
      }
    }
  }




  static Future<List<DomainData>> fetchDomainItems() async {
    final response = await http.get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/domain'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Domain domain = Domain.fromJson(data);
      await DomainDatabase.insertDomains(domain.data ?? []);
      print('data:$domain.data');
      return domain.data ?? [];
    } else {
      throw Exception('Failed to load domain items');
    }
  }

  static Future<List<TechData>> fetchTechStackItems() async {
    final response = await http.get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/tech'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Tech tech = Tech.fromJson(data);
      await TechDatabase.insertTechStack(tech.data ?? []);
      return tech.data ?? [];
    } else {
      throw Exception('Failed to load tech stack items');
    }
  }
}

