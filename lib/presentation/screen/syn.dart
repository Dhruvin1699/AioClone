// // sync_screen.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'api_service.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:aioaapbardemo/presentation/screen/portfoliodeatil.dart';
// import 'package:aioaapbardemo/presentation/screen/syn.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
//
//
// import '../../Data/database.dart';
// import '../../model/model.dart';
// import 'filter_screen.dart';
// import '../../model/model.dart';
//
// class SyncScreen extends StatefulWidget {
//   @override
//   _SyncScreenState createState() => _SyncScreenState();
// }
//
// class _SyncScreenState extends State<SyncScreen> {
//   bool isSyncing = false;
//   List<Data> gridData = [];
//   DatabaseHelper _databaseHelper = DatabaseHelper.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Synchronization'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (isSyncing)
//               CircularProgressIndicator()
//             else
//               ElevatedButton(
//                 onPressed: () async {
//                   // Trigger the synchronization process
//                   await synchronizeData();
//                 },
//                 child: Text('Sync Now'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> synchronizeData() async {
//     setState(() {
//       isSyncing = true;
//     });
//
//     try {
//       // Call fetchDataFromApi method from ApiService
//       List<Data> apiData = await ApiService.fetchDataFromApi(selectedFilterId);
//
//       // Additional synchronization logic...
//
//       // Update the local gridData with the fetched data
//       setState(() {
//         gridData = apiData;
//       });
//
//       // Simulate a delay to mimic the synchronization process
//       await Future.delayed(Duration(seconds: 2));
//
//       // Synchronization successful
//       showSuccessMessage('Data synchronized successfully!');
//     } catch (e) {
//       // Handle synchronization errors
//       showErrorMessage('Synchronization failed. Check your network connection.');
//     } finally {
//       setState(() {
//         isSyncing = false;
//       });
//     }
//   }
//
//
//   void showSuccessMessage(String message) {
//     // Implement how to display success messages to the user
//     print('Success: $message');
//   }
//
//   void showErrorMessage(String message) {
//     // Implement how to display error messages to the user
//     print('Error: $message');
//   }
// }
