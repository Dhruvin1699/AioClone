import 'dart:convert';
import 'dart:io';

import 'package:aioaapbardemo/presentation/screen/portfoliodeatil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../Data/database.dart';
import '../../model/model.dart';
import 'filter_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//
class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Data> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 5);

  final List<String> dropdownItems = ['Domains/Industries'];
  List<String> selectedFilterIds = [];
  List<Data> gridData = [];
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  bool isDataLoaded = false;
  int currentPage = 1;
  int itemsPerPage = 10;
  List<Data> filteredData = [];
  bool get isOnline => false;


  void initState() {
    super.initState();
    // checkInternetConnection();

    _pagingController.addPageRequestListener((pageKey) async{
      if (ConnectivityResult.none == await Connectivity().checkConnectivity()) {
        loadGridItemsFromDatabase(pageKey);
      } else {
        fetchDataFromApi(pageKey);
      }
    });
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, load data from the local database
      await loadGridItemsFromDatabase(0);
    }
  }

  void _openDetailsPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
            apiData: _pagingController.itemList, initialPageIndex: index),
      ),
    );
  }


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


  Future<void> loadGridItemsFromDatabase(int page) async {
    int offset = (page) * itemsPerPage;
    print("loadGridItemsFromDatabase page $page offset $offset");

    List<Data> loadedData = [];

    // Check if there are selected filters
    if (selectedFilterIds.isNotEmpty) {
      loadedData = await _databaseHelper.fetchDataByDomainAndTechID(
          selectedFilterIds[0], selectedFilterIds[1]);
    } else {
      List<Map<String, dynamic>>? newdata =
      await _databaseHelper.getPaginatedData(itemsPerPage, offset);

      print("rows ${newdata?.length}");

      for (var row in newdata!) {
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
    }

    if (loadedData.length < itemsPerPage) {
      _pagingController.appendLastPage(loadedData);
    } else {
      final newPage = page + 1;
      _pagingController.appendPage(loadedData, newPage);
    }
  }



  void _openFilterPage() async {
    var selectedFilterIds1 = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
          builder: (context) =>
              FilterPage(selectedFilterIds: this.selectedFilterIds)),
    );

    // Handle selected filter IDs (selectedFilterIds is a List<String>)
    print('Selected filter IDs from filter page: $selectedFilterIds1');

    // Update your state with selected filter IDs

    // Update the selectedFilterIds state variable
    this.selectedFilterIds = selectedFilterIds1 ?? [];

    // Check if the app is offline
    if (ConnectivityResult.none == await Connectivity().checkConnectivity()) {
      print('App is offline. Loading filtered data from the local database.');

      _pagingController.refresh();
    } else {
      // Call fetchDataFromApi with selected filter IDs to update gridData
      print('App is online. Refreshing paging controller.');
      _pagingController.refresh();
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
  //
  Future<void> fetchDataFromApi(int pageKey) async {
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



      if (newData.isNotEmpty) {
        // Increment page number only if new data is available
        pageKey++;



        _pagingController.appendPage(newData, pageKey);
      } else {
        _pagingController.appendLastPage([]);
      }
    } catch (e) {
      print('Error: $e');
      await loadGridItemsFromDatabase(pageKey);
    }
  }

  Future<List<Data>> fetchFilterData(List<String> selectedFilterIds, int pageKey) async {
    print('Fetching data for filter IDs: $selectedFilterIds');

    List<Data> filteredData = await _databaseHelper.fetchDataByDomainAndTechID(selectedFilterIds[0], selectedFilterIds[1]);
    String queryParameters =
        'domain_id=${selectedFilterIds[0]}&tech_id=${selectedFilterIds[1]}&page=$pageKey&limit=$itemsPerPage';
    String apiUrl = 'https://api.tridhyatech.com/api/v1/portfolio/list?$queryParameters';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Autogenerated data = Autogenerated.fromJson(responseData);

      return data.data ?? filteredData;
    } else {
      throw Exception('Failed to load data from API');
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
                          padding: const EdgeInsets.only(left: 8.0),
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
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[


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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PageGridViewBuilder<Data>(
            pagingController: _pagingController,
            itemBuilder: (context, item, index) {
                var imagePath = item.imageMapping != null &&
                        item.imageMapping!.isNotEmpty
                    ? 'https://api.tridhyatech.com/${item.imageMapping![0].portfolioImage}'
                    : '';

                return GridItem(
                  imagePath: imagePath,
                  itemName: item.projectName ?? " ",
                  apiData: item,
                  currentIndex: index,
                  onTap: () {
                    _openDetailsPage(index);
                  },
                );
            },
          ),
              ))
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: apiData != null &&
                    apiData!.imageMapping != null &&
                    apiData!.imageMapping!.isNotEmpty
                    ? buildImage(apiData!.imageMapping![0])
                    : Container(
                  width: 185,
                  height: 175,
                  color: Colors.red,
                ),
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
        : ConnectivityResult.none == Connectivity().checkConnectivity()
            ? Container(
                width: 185,
                height: 175,
                color: Colors.red,
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

class PageGridViewBuilder<T> extends StatefulWidget {
  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext, T, int) itemBuilder;

  PageGridViewBuilder({
    required this.pagingController,
    required this.itemBuilder,
  });

  @override
  _PageGridViewBuilderState createState() => _PageGridViewBuilderState<T>();
}

class _PageGridViewBuilderState<T> extends State<PageGridViewBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, T>(
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: (context, item, index) =>
            widget.itemBuilder(context, item, index),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
    );
  }
}
