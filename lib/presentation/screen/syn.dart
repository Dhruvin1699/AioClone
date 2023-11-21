import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:aioaapbardemo/model/model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'api_service.dart'; // Import your ApiService class
import 'portfoliolisting.dart'; // Import your HomeScreen class

class SynchronizationScreen extends StatefulWidget {
  @override
  _SynchronizationScreenState createState() => _SynchronizationScreenState();
}

class _SynchronizationScreenState extends State<SynchronizationScreen> {
  bool isSyncing = true; // Set isSyncing to true initially
  List<Data> syncedData = [];
   final PagingController<int, Data> _pagingController = PagingController(firstPageKey: 1);
  List<String> selectedFilterIds = [
  ]; // Define and initialize selectedFilterIds
  List<Data> gridData = []; // Define and initialize gridData

  @override
  void initState() {
    super.initState();
    // Start synchronization automatically when the screen is loaded
    syncData();
    _fetchDomainAndTechStackItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSyncing) CircularProgressIndicator(),
            // Show a loading indicator during synchronization
            if (syncedData.isNotEmpty)
              Text('Synced Data Count: ${syncedData.length}'),
          ],
        ),
      ),
    );
  }


  Future<void> _fetchDomainAndTechStackItems() async {
    try {
      await ApiService.fetchDomainItems();
      await ApiService.fetchTechStackItems();
    } catch (e) {
      print('Error fetching domain and tech stack items: $e');
    }
  }
  Future<void> syncData() async {
    try {
      // Check if the app is online before attempting synchronization
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // Fetch data using your ApiService
        gridData = await ApiService.fetchDataFromApi(
          1,
          selectedFilterIds,
          _pagingController,
          50,
        );
        // Save the synced data to the local state
        setState(() {
          syncedData = gridData;
        });

        // Download and save images for the fetched data in the background
        _downloadImagesInBackground(gridData);
      }

      // Navigate to the HomeScreen after synchronization or directly if offline
      print('Navigating to HomeScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Handle errors during synchronization
      print('Error during synchronization: $e');
    } finally {
      setState(() {
        isSyncing = false;
      });
    }
  }

  Future<void> _downloadImagesInBackground(List<Data> apiData) async {
    await Future.forEach(apiData, (item) async {
      await ApiService.downloadAndSaveImage(item);
    });
  }
}



