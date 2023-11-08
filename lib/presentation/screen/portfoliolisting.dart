
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aioaapbardemo/presentation/screen/portfoliodeatil.dart';
import 'package:aioaapbardemo/presentation/screen/syn.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'api_service.dart';
import '../../Data/database.dart';
import '../../model/model.dart';
import 'filter_screen.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//
class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Data> _pagingController = PagingController(firstPageKey: 1);
  final List<String> dropdownItems = ['Domains/Industries'];
  List<String> selectedFilterIds = [];
  List<Data> gridData = [];
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  bool isDataLoaded = false;
  // void initState() {
  //   super.initState();
  //   checkInternetConnection();
  //
  //   // Listen for page requests from the paging controller
  //   _pagingController.addPageRequestListener((pageKey) {
  //     // Call fetchPage to load data for the requested page
  //     fetchPage(pageKey, limit: 10);
  //   });
  //
  //   // Load data from the local database first
  //   loadGridItemsFromDatabase().then((_) {
  //     // Once local data is loaded, fetch data from the API (if no filters are selected)
  //     if (selectedFilterIds.isEmpty) {
  //       _pagingController.addPageRequestListener((pageKey) {
  //         fetchPage(pageKey, limit: 10);
  //       });
  //     }
  //   });
  // }
  void initState() {
    super.initState();
    checkInternetConnection();
    // Load data from the local database first
    loadGridItemsFromDatabase().then((_) {
      // Once local data is loaded, fetch data from the API
      fetchDataFromApi(selectedFilterIds);
    });
  }
  // }
  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, load data from the local database
      await loadGridItemsFromDatabase();
    }
  }

  void _openDetailsPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailsPage(apiData: gridData, initialPageIndex: index),
      ),
    );
  }

  Future<void> loadGridItemsFromDatabase() async {
    if (isDataLoaded) {
      // Data is already loaded, do not reload
      return;
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
        formattedTechMapping:
            _databaseHelper.formatTechMapping(techMappingList),
        urlLink: row['urlLink'],
        domainID: row['domainID'],
      );
      await _setLocalPathsForImages(currentItem);

      loadedData.add(currentItem);
    }

    setState(() {
      gridData = loadedData;
      isDataLoaded = true; // Mark data as loaded
    });
  }
  //

  Future<void> _setLocalPathsForImages(Data item) async {
    for (var imageMapping in item.imageMapping!) {
      String directory = (await getApplicationDocumentsDirectory()).path;
      String imagePath = path.join(directory, imageMapping.portfolioImage);

      // Check if the image file exists locally
      if (File(imagePath).existsSync()) {
        // Image already exists locally, use the local path
        imageMapping.localImagePath = imagePath;
      } else {
        // Image doesn't exist locally, set the local path to null
        imageMapping.localImagePath = null;
      }
    }
  }

  void _openFilterPage() async {
    var selectedFilterIds = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (context) => FilterPage()),
    );

    // Handle selected filter IDs (selectedFilterIds is a List<String>)
    if (selectedFilterIds != null && selectedFilterIds.isNotEmpty) {
      // Update your state with selected filter IDs
      setState(() {
        // Update the selectedFilterIds state variable
        selectedFilterIds = selectedFilterIds;

        // Call fetchDataFromApi with selected filter IDs to update gridData
        fetchDataFromApi(selectedFilterIds!);
      });
    }
  }

  Future<void> checkImageStorageLocation(Data item) async {
    for (var imageMapping in item.imageMapping!) {
      String directory = (await getApplicationDocumentsDirectory()).path;
      String imagePath = path.join(directory, imageMapping.portfolioImage);

      if (File(imagePath).existsSync()) {
        print('Image exists at: $imagePath');
      } else {
        print('Image does not exist locally');
      }
    }
  }

  Future<void> fetchDataFromApi(List<String> selectedFilterIds) async {
    try {
      // Check if there are no selected filters
      if (selectedFilterIds.isEmpty) {
        // If no filters are selected, make API call without query parameters
        String apiUrl = 'https://api.tridhyatech.com/api/v1/portfolio/list-mobile';
        print('Calling API: $apiUrl'); // Print API call
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final Autogenerated data = Autogenerated.fromJson(responseData);
          setState(() {
            gridData = data.data!;
          });
        } else {
          throw Exception('Failed to load data from API');
        }

     } else {
  //     // If filters are selected, fetch data from the local database by domain ID and tech ID
      List<Data> filteredData =
      await _databaseHelper.fetchDataByDomainAndTechID(selectedFilterIds[0], selectedFilterIds[1]);

      setState(() {
        gridData = filteredData;
      });
      print('Loaded filtered data from database: $filteredData');
      // If the local database doesn't have the data, fetch from API and update the local database
      if (filteredData.isEmpty) {
        String queryParameters = 'domain_id=${selectedFilterIds[0]}&tech_id=${selectedFilterIds[1]}';
        String apiUrl = 'https://api.tridhyatech.com/api/v1/portfolio/list?$queryParameters';

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final Autogenerated data = Autogenerated.fromJson(responseData);

          setState(() {
            gridData = data.data!;
          });

          // Save grid items to the database
          for (var item in gridData) {
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
        } else {
          throw Exception('Failed to load data from API');
        }
      }
    }
  } catch (e) {
    // Handle network-related errors
    print('Error: $e');

    // Load data from the local database as a fallback mechanism
    await loadGridItemsFromDatabase();
  }
  }





  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedDropdownItem = dropdownItems.first;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the synchronization screen
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SyncScreen()),
          // );
        },
        child: Icon(Icons.sync),
      ),
      body: Column(
        children: <Widget>[
          Container(
            // Set your desired height
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [
                  Color(0xFFDEF8FF),
                  Colors.white.withOpacity(0.9200000166893005),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 29.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/Group 29.png',
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Container(
                              width: 10, child: Icon(Icons.arrow_back_ios)),
                          onPressed: () {
                            // Handle back button press
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Work/Portfolio',
                          style: TextStyle(
                            color: Color(0xFF00517C),
                            fontSize: 22,
                            fontFamily: 'Source Sans Pro',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        Spacer(),
                        CustomDropdown(
                            selectedItem: selectedDropdownItem,
                            onTap: _openFilterPage),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: gridData.length,
              itemBuilder: (BuildContext context, int index) {
                var currentItem = gridData[index];

                var imagePath = currentItem.imageMapping != null &&
                        currentItem.imageMapping!.isNotEmpty
                    ? 'https://api.tridhyatech.com/${currentItem.imageMapping![0].portfolioImage}'
                    : ''; // Set a default empty string if ImageMapping is empty

                return GridItem(
                  imagePath: imagePath,
                  itemName: currentItem.projectName ?? " ",
                  apiData: currentItem,
                  currentIndex: index,
                  onTap: () {
                    _openDetailsPage(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String selectedItem;
  final Function() onTap;

  CustomDropdown({
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Color(0xFF00517C)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem,
              style: TextStyle(color: Colors.blueGrey),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final Data? apiData;
  final int currentIndex;
  final Function() onTap;

  GridItem({
    required this.imagePath,
    required this.itemName,
    required this.apiData,
    required this.currentIndex,
    required this.onTap,
  });
  // /data/data/com.example.aioaapbardemo/app_flutter/flutter_assets
  // /data/data/com.example.aioaapbardemo/app_flutter/f255b081-c555-4ef7-a7ca-3b223e30a5cd-1.jpg
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            apiData != null &&
                    apiData!.imageMapping != null &&
                    apiData!.imageMapping!.isNotEmpty
                ? buildImage(apiData!.imageMapping![0])
                : Container(
                    width: 185,
                    height: 175,
                    color: Colors.red,
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  itemName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(ImageMapping imageMapping) {
    String localImagePath =
        "/data/user/0/com.example.aioaapbardemo/app_flutter/${imageMapping.portfolioImage}"; // Use the local path if available
    return localImagePath.isNotEmpty && File(localImagePath).existsSync()
        ? Image.file(
            File(localImagePath),
            width: 185,
            height: 175,
            fit: BoxFit.fitWidth,
          )
        : CachedNetworkImage(
            imageUrl: imagePath,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 185,
            height: 175,
            fit: BoxFit.fitWidth,
          );
  }
}
