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
      gridData = await ApiService.fetchDataFromApi(selectedFilterIds, gridData);

      // Save the synced data to the local state
      setState(() {
        syncedData = gridData;
      });

      // Download and save images for the fetched data in the background
      _downloadImagesInBackground(gridData);

      // Navigate to the HomeScreen after synchronization
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

// import 'package:flutter/material.dart';
// import 'package:aioaapbardemo/model/model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_service.dart'; // Import your ApiService class
// import 'portfoliolisting.dart'; // Import your HomeScreen class
// class SynchronizationScreen extends StatefulWidget {
//   @override
//   _SynchronizationScreenState createState() => _SynchronizationScreenState();
// }
//
// class _SynchronizationScreenState extends State<SynchronizationScreen> {
//   bool isSyncing = true;
//   List<Data> syncedData = [];
//   List<String> selectedFilterIds = [];
//   List<Data> gridData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Check synchronization status and last sync date
//     checkSyncStatus();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (isSyncing) CircularProgressIndicator(),
//             if (syncedData.isNotEmpty)
//               Text('Synced Data Count: ${syncedData.length}'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> checkSyncStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isDataSynced = prefs.getBool('isDataSynced') ?? false;
//     String lastSyncDate = prefs.getString('lastSyncDate') ?? '';
//     print('Checking synchronization status...');
//     // Check if data is already synced
//     if (isDataSynced) {
//       if (isWithinSyncRange(lastSyncDate)) {
//         Future<void> syncData() async {
//           try {
//             // Fetch data using your ApiService
//             gridData = await ApiService.fetchDataFromApi(selectedFilterIds, gridData);
//
//             // Save the synced data to the local state
//             setState(() {
//               syncedData = gridData;
//             });
//
//             // Download and save images for the fetched data in the background
//             _downloadImagesInBackground(gridData);
//
//             // Save synchronization status and last sync date
//             saveSyncStatus();
//
//             // Introduce a delay before navigating to HomeScreen
//             await Future.delayed(Duration(seconds: 1), () {
//               // Check if the widget is still mounted before navigating
//               if (mounted) {
//                 // Navigate to the HomeScreen after synchronization
//                 print('Navigating to HomeScreen');
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               }
//             });
//           } catch (e) {
//             // Handle errors during synchronization
//             print('Error during synchronization: $e');
//           } finally {
//             setState(() {
//               isSyncing = false;
//             });
//           }
//         }
//
//       } else {
//         syncData();
//       }
//     } else {
//       syncData();
//     }
//
//   }
//
//   Future<void> syncData() async {
//     try {
//       // Fetch data using your ApiService
//       gridData = await ApiService.fetchDataFromApi(selectedFilterIds, gridData);
//
//       // Save the synced data to the local state
//       setState(() {
//         syncedData = gridData;
//       });
//
//       // Download and save images for the fetched data in the background
//       _downloadImagesInBackground(gridData);
//
//       // Save synchronization status and last sync date
//       saveSyncStatus();
//
//       // Navigate to the HomeScreen after synchronization
//       print('Navigating to HomeScreen');
//       Future<void> syncData() async {
//         try {
//           // Fetch data using your ApiService
//           gridData = await ApiService.fetchDataFromApi(selectedFilterIds, gridData);
//
//           // Save the synced data to the local state
//           setState(() {
//             syncedData = gridData;
//           });
//
//           // Download and save images for the fetched data in the background
//           _downloadImagesInBackground(gridData);
//
//           // Save synchronization status and last sync date
//           saveSyncStatus();
//
//           // Introduce a delay before navigating to HomeScreen
//           await Future.delayed(Duration(seconds: 1), () {
//             // Check if the widget is still mounted before navigating
//             if (mounted) {
//               // Navigate to the HomeScreen after synchronization
//               print('Navigating to HomeScreen');
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//             }
//           });
//         } catch (e) {
//           // Handle errors during synchronization
//           print('Error during synchronization: $e');
//         } finally {
//           setState(() {
//             isSyncing = false;
//           });
//         }
//       }
//
//     } catch (e) {
//       // Handle errors during synchronization
//       print('Error during synchronization: $e');
//     } finally {
//       setState(() {
//         isSyncing = false;
//       });
//     }
//   }
//
//   void saveSyncStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isDataSynced', true);
//     prefs.setString('lastSyncDate', DateTime.now().toIso8601String());
//   }
//
//   bool isWithinSyncRange(String lastSyncDate) {
//     // Add your logic to determine if the last sync date is within the allowed range
//     // For example, you can compare it with the current date
//     return true;
//   }
//
//   Future<void> _downloadImagesInBackground(List<Data> apiData) async {
//     await Future.forEach(apiData, (item) async {
//       await ApiService.downloadAndSaveImage(item);
//     });
//   }
// }
