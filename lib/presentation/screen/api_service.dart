import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:aioaapbardemo/model/model.dart';
import 'package:aioaapbardemo/Data/database.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:aioaapbardemo/Data/database.dart';
class ApiService {
  static bool isDataLoaded = false; // Add this line to define isDataLoaded
  static  DatabaseHelper _databaseHelper = DatabaseHelper.instance;// Add this line to define _databaseHelper
  static List<Data> gridData = [];

  static Future<List<Data>> fetchDataFromApi(
      List<String> selectedFilterIds, List<Data> gridData) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // App is offline, fetch data from the local database
        // return await loadGridItemsFromDatabase();
      }

      if (selectedFilterIds.isEmpty) {
        // If no filters are selected, make API call without query parameters
        String apiUrl = 'https://api.tridhyatech.com/api/v1/portfolio/list-mobile';

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final Autogenerated data = Autogenerated.fromJson(responseData);

          // Save grid items to the database
          for (var item in data.data!) {
            await downloadAndSaveImage(item);

            // Always insert data into the local database
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
          }

          return data.data!;
        } else {
          throw Exception('Failed to load data from API');
        }
      } else {
        // If filters are selected, fetch data from the local database by domain ID
        List<Data> filteredData = await _databaseHelper.fetchDataByDomainAndTechID(
          selectedFilterIds[0],
          selectedFilterIds[1],
        );

        // If the local database doesn't have the data, fetch from API and update the local database
        if (filteredData.isEmpty) {
          String queryParameters =
              'domain_id=${selectedFilterIds[0]}&tech_id=${selectedFilterIds[1]}';
          String apiUrl = 'https://api.tridhyatech.com/api/v1/portfolio/list?$queryParameters';

          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = json.decode(response.body);
            final Autogenerated data = Autogenerated.fromJson(responseData);

            // Save grid items to the database
            // for (var item in data.data!) {
            //   await downloadAndSaveImage(item);
            //
            //   // Always insert data into the local database
            //   await _databaseHelper.insertData({
            //     'projectName': item.projectName,
            //     'imageMapping': json.encode(item.imageMapping),
            //     'techMapping': json.encode(item.techMapping),
            //     'domainName': item.domainName,
            //     'description': item.description,
            //     'domainID': item.domainID,
            //     'techID': (item.techMapping != null && item.techMapping!.isNotEmpty)
            //         ? item.techMapping![0].techID
            //         : null,
            //   });
            // }

            return data.data!;
          } else {
            throw Exception('Failed to load data from API');
          }
        } else {
          return filteredData;
        }
      }
    } catch (e) {
      // Handle network-related errors
      print('Error: $e');

      // Load data from the local database as a fallback mechanism
      // return await loadGridItemsFromDatabase();
      return [];
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


  static Future<List<Data>> loadGridItemsFromDatabase() async {
    if (isDataLoaded) {
      // Data is already loaded, do not reload
      return gridData;
    }

    List<Map<String, dynamic>> rows = await _databaseHelper.getAllGridItems();
    List<Data> loadedData = [];

    print("rows ${rows.length}");

    for (var row in rows) {
      List<TechMapping> techMappingList =
      (json.decode(row['techMapping']) as List<dynamic>)
          .map((dynamic item) => TechMapping.fromJson(item))
          .toList();

      var currentItem = Data(
        projectName: row['projectName'],
        imageMapping: (json.decode(row['imageMapping']) as List<dynamic>)
            .map((dynamic item) => ImageMapping.fromJson(item))
            .toList(),
        techMapping: techMappingList,
        domainName: row['domainName'],
        description: row['description'],
        formattedTechMapping: _databaseHelper.formatTechMapping(techMappingList),
        urlLink: row['urlLink'],
        domainID: row['domainID'],
      );

      loadedData.add(currentItem);
    }

    // Instead of using setState, you can directly assign loadedData to gridData
    gridData = loadedData;
    isDataLoaded = true; // Mark data as loaded

    return gridData; // Return the loaded data
  }

}

