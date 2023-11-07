import 'package:flutter/material.dart';
import 'package:aioaapbardemo/model/model.dart';
import 'api_service.dart'; // Import your ApiService class
import 'portfoliolisting.dart'; // Import your HomeScreen class

class SynchronizationScreen extends StatefulWidget {
  @override
  _SynchronizationScreenState createState() => _SynchronizationScreenState();
}

class _SynchronizationScreenState extends State<SynchronizationScreen> {
  bool isSyncing = true; // Set isSyncing to true initially
  List<Data> syncedData = [];

  List<String> selectedFilterIds = [
  ]; // Define and initialize selectedFilterIds
  List<Data> gridData = []; // Define and initialize gridData

  @override
  void initState() {
    super.initState();
    // Start synchronization automatically when the screen is loaded
    syncData();
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

  Future<void> syncData() async {
    try {
      // Fetch data using your ApiService
      // List<Data> apiData = await ApiService.fetchDataFromApi(
      //     selectedFilterIds, gridData);
      gridData = await ApiService.fetchDataFromApi(selectedFilterIds,gridData);
      // Save the synced data to the local state
      setState(() {
        syncedData = gridData;
      });

      // Download and save images for the fetched data in the background
      _downloadImagesInBackground(gridData);

      // Navigate to the HomeScreen after synchronization
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
