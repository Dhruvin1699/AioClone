// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../../model/domain.dart';
// import '../../model/model.dart';
// import '../../model/tech.dart';
// // class FilterPage extends StatefulWidget {
// //   @override
// //   State<FilterPage> createState() => _FilterPageState();
// // }
// //
// // class _FilterPageState extends State<FilterPage> {
// //   List<String> items = ['Domains/industries', 'Technology/Tech Stack'];
// //   String selectedFilter = 'Domains/industries';
// //
// //   // List<String> domainItems = [];
// //   // List<String> techStackItems = [];
// //
// //   String selectedDomain = '';
// //   List<FilterItem> items = [];
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //
// //   List<bool> checkboxValues = [];
// //
// //
// //   static Future<List<DomainData>> fetchDomainItems() async {
// //     final response = await http.get(
// //         Uri.parse('https://api.tridhyatech.com/api/v1/lookup/domain'));
// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> data = json.decode(response.body);
// //       Domain domain = Domain.fromJson(data);
// //       return domain.data ?? [];
// //     } else {
// //       throw Exception('Failed to load domain items');
// //     }
// //   }
// //
// //   static Future<List<TechData>> fetchTechStackItems() async {
// //     final response = await http.get(
// //         Uri.parse('https://api.tridhyatech.com/api/v1/lookup/tech'));
// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> data = json.decode(response.body);
// //       Tech tech = Tech.fromJson(data);
// //       return tech.data ?? [];
// //     } else {
// //       throw Exception('Failed to load tech stack items');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // List<String> currentItems =
// //     // selectedFilter == 'Domains/industries' ? domainItems : techStackItems;
// //
// //     return Scaffold(
// //       body: Column(
// //         children: <Widget>[
// //           // Top Container
// //           Container(
// //             height: 135,
// //             padding: EdgeInsets.all(8.0),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 begin: Alignment(0.00, -1.00),
// //                 end: Alignment(0, 1),
// //                 colors: [
// //                   Color(0xFFDEF8FF),
// //                   Colors.white.withOpacity(0.9200000166893005)
// //                 ],
// //               ),
// //             ),
// //             child: Column(
// //               children: <Widget>[
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 28.0),
// //                   child: Container(
// //                     height: 40,
// //                     child: Row(
// //                       children: <Widget>[
// //                         Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Image.asset(
// //                             'images/Group 29.png',
// //                             width: 150,
// //                             height: 50,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: EdgeInsets.all(0),
// //                   child: Row(
// //
// //                     children: <Widget>[
// //                       IconButton(
// //                         icon: Container(
// //                             width: 10, child: Icon(Icons.arrow_back_ios)),
// //                         onPressed: () {
// //                           // Handle back button press
// //                         },
// //                       ),
// //                       SizedBox(width: 10),
// //                       Text(
// //                         'Filter',
// //                         style: TextStyle(
// //                           color: Color(0xFF00517C),
// //                           fontSize: 22,
// //                           fontFamily: 'Source Sans Pro',
// //                           fontWeight: FontWeight.w700,
// //                           height: 0,
// //                         ),
// //                       ),
// //                       // Spacer(), ElevatedButton(
// //                       //   onPressed: () {
// //                       //     selectedItems.forEach((item) {
// //                       //       print('Selected Item: $item');
// //                       //       // You can perform any action with the selected items here.
// //                       //     });
// //                       //     // Close the filter page or perform any other action as needed.
// //                       //     Navigator.pop(context);
// //                       //   },
// //                       //   child: Text('Apply'),
// //                       // ),
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           // Filter out selected items
// //                           List<FilterItem> selectedItemsList = items.where((item) => item.isSelected).toList();
// //
// //                           // Perform actions with selectedItemsList, for example, print their titles
// //                           selectedItemsList.forEach((item) {
// //                             print('Selected Item: ${item.title}');
// //                           });
// //
// //                           // Close the filter page or perform any other action as needed.
// //                           Navigator.pop(context, selectedItemsList);
// //                         },
// //                         child: Text('Apply'),
// //                       ),
// //
// //
// //                       // ElevatedButton(onPressed: () {
// //                       //   Navigator.pop(context, selectedDomain);
// //                       // }, child: Text('Apply'))
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // Rest of the content
// //           Expanded(
// //             child: Row(
// //               children: <Widget>[
// //                 // Left Sidebar
// //                 Container(
// //                   width: 200,
// //                   height: double.infinity,
// //                   child: ListView.builder(
// //                     itemCount: items.length,
// //                     itemBuilder: (context, index) {
// //                       return ListTile(
// //                         title: Text(items[index]),
// //                         onTap: () {
// //                           setState(() {
// //                             selectedFilter = items[index];
// //                           });
// //                         },
// //                         selected: selectedFilter == items[index],
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 // Right Content
// //
// //                 Expanded(
// //                   child: FutureBuilder<List<FilterItem>>(
// //                     future: _loadData(),
// //                     builder: (context, snapshot) {
// //                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                         return Center(child: CircularProgressIndicator());
// //                       } else if (snapshot.hasError) {
// //                         return Center(child: Text('Error loading data'));
// //                       } else if (snapshot.hasData) {
// //                         List<FilterItem> currentItems = snapshot.data!;
// //                         return ListView.builder(
// //                           itemCount: currentItems.length,
// //                           itemBuilder: (context, index) {
// //                             FilterItem item = currentItems[index];
// //                             return Container(
// //                               height: 50,
// //                               margin: EdgeInsets.only(bottom: 10),
// //                               padding: EdgeInsets.symmetric(horizontal: 16),
// //                               decoration: BoxDecoration(
// //                                 border: Border.all(color: Colors.grey),
// //                                 borderRadius: BorderRadius.circular(5),
// //                               ),
// //                               child: Row(
// //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                 children: <Widget>[
// //                                   // Checkbox(
// //                                   //   value: selectedItems.contains(item),
// //                                   //   onChanged: (value) {
// //                                   //     setState(() {
// //                                   //       if (value != null && value) {
// //                                   //         selectedItems.add(item);
// //                                   //       } else {
// //                                   //         selectedItems.remove(item);
// //                                   //       }
// //                                   //     });
// //                                   //   },
// //                                   // ),
// //                                   Checkbox(
// //                                     value: item.isSelected,
// //                                     onChanged: (value) {
// //                                       setState(() {
// //                                         if (value != null) {
// //                                           item.isSelected = value;
// //                                         }
// //                                       });
// //                                     },
// //                                   ),
// //
// //                                   Text(item.title),
// //                                 ],
// //                               ),
// //                             );
// //                           },
// //                         );
// //                       } else {
// //                         return Center(child: Text('No data'));
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Future<List<FilterItem>> _loadData() async {
// //     try {
// //       List<FilterItem> itemsData = [];
// //       if (selectedFilter == 'Domains/industries') {
// //         List<DomainData> domainData = await fetchDomainItems();
// //         items = domainData.map((data) =>
// //             FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
// //             .toList();
// //       } else {
// //         List<TechData> techData = await fetchTechStackItems();
// //         items = techData.map((data) =>
// //             FilterItem(id: data.id ?? '', title: data.techName ?? '')).toList();
// //       }
// //
// //       setState(() {
// //         items = itemsData;
// //       });
// //
// //       return itemsData;
// //     } catch (error) {
// //       throw Exception('Failed to load data: $error');
// //     }
// //   }
// //   // Set<FilterItem> selectedItems = Set<FilterItem>();
// // }
// // class FilterItem {
// //   final String id;
// //   final String title;
// //   bool isSelected;
// //
// //   FilterItem({required this.id, required this.title, this.isSelected = false});
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../model/domain.dart';
// import '../../model/tech.dart';
//
// class FilterPage extends StatefulWidget {
//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }
//
// class _FilterPageState extends State<FilterPage> {
//   List<FilterItem> items = [];
//   String selectedFilter = 'Domains/industries';
//   List<String> item = ['Domains/industries', 'Technology/Tech Stack'];
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch data when the screen initializes
//     _loadData();
//   }
//
//   static Future<List<DomainData>> fetchDomainItems() async {
//     final response = await http
//         .get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/domain'));
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       Domain domain = Domain.fromJson(data);
//       return domain.data ?? [];
//     } else {
//       throw Exception('Failed to load domain items');
//     }
//   }
//
//   static Future<List<TechData>> fetchTechStackItems() async {
//     final response = await http
//         .get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/tech'));
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       Tech tech = Tech.fromJson(data);
//       return tech.data ?? [];
//     } else {
//       throw Exception('Failed to load tech stack items');
//     }
//   }
//
//   Future<void> _loadData() async {
//     try {
//       List<FilterItem> loadedItems = [];
//       if (selectedFilter == 'Domains/industries') {
//         List<DomainData> domainData = await fetchDomainItems();
//         loadedItems = domainData
//             .map((data) =>
//                 FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
//             .toList();
//       } else {
//         List<TechData> techData = await fetchTechStackItems();
//         loadedItems = techData
//             .map((data) =>
//                 FilterItem(id: data.id ?? '', title: data.techName ?? ''))
//             .toList();
//       }
//
//       setState(() {
//         items = loadedItems;
//       });
//     } catch (error) {
//       throw Exception('Failed to load data: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//         body: Column(children: <Widget>[
//           // Your filter options UI
//           // ...
//           Container(
//             height: 135,
//             padding: EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(0.00, -1.00),
//                 end: Alignment(0, 1),
//                 colors: [
//                   Color(0xFFDEF8FF),
//                   Colors.white.withOpacity(0.9200000166893005)
//                 ],
//               ),
//             ),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(top: 28.0),
//                   child: Container(
//                     height: 40,
//                     child: Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.asset(
//                             'images/Group 29.png',
//                             width: 150,
//                             height: 50,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(0),
//                   child: Row(
//                     children: <Widget>[
//                       IconButton(
//                         icon: Container(
//                             width: 10, child: Icon(Icons.arrow_back_ios)),
//                         onPressed: () {
//                           // Handle back button press
//                         },
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         'Filter',
//                         style: TextStyle(
//                           color: Color(0xFF00517C),
//                           fontSize: 22,
//                           fontFamily: 'Source Sans Pro',
//                           fontWeight: FontWeight.w700,
//                           height: 0,
//                         ),
//                       ),
//                       Spacer(),
//                       // ElevatedButton(
//                       //   onPressed: () {
//                       //     // Filter out selected items
//                       //     List<String> selectedItemsList = items
//                       //         .where((item) => item.isSelected)
//                       //         .map((item) => item.title) // Extract titles as strings
//                       //         .toList();
//                       //
//                       //     // Close the filter page and pass the selectedItemsList back to the home screen
//                       //     Navigator.pop(context, selectedItemsList);
//                       //   },
//                       //   child: Text('Apply'),
//                       // ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Filter out selected items and extract their IDs
//                           List<String> selectedItemsIds = items
//                               .where((item) => item.isSelected)
//                               .map((item) => item.id) // Extract IDs as strings
//                               .toList();
//
//                           // Close the filter page and pass the selectedItemsIds back to the home screen
//                           Navigator.pop(context, selectedItemsIds);
//                         },
//                         child: Text('Apply'),
//                       ),
//                       // ElevatedButton(onPressed: () {
//                       //   Navigator.pop(context, selectedDomain);
//                       // }, child: Text('Apply'))
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Row(
//               children: <Widget>[
//                 // Left Sidebar
//                 Container(
//                   width: 200,
//                   height: double.infinity,
//                  child: ListView.builder(
//                     itemCount: item.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(item[index]),
//                         onTap: () {
//                           setState(() {
//                             selectedFilter = item[index];
//                             // Load data based on the selected filter
//                             _loadData();
//                           });
//                         },
//                         selected: selectedFilter == item[index],
//                       );
//                     },
//                   ),
//                 ),
//
//                 // List of items fetched from API
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       FilterItem item = items[index];
//                       return ListTile(
//                         title: Text(item.title),
//                         trailing: Checkbox(
//                           value: item.isSelected,
//                           onChanged: (value) {
//                             setState(() {
//                               item.isSelected = value ?? false;
//                             });
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 // Apply button
//               ],
//             ),
//           )
//         ]));
//   }
// }
//
// class FilterItem {
//   final String id;
//   final String title;
//   bool isSelected;
//
//   FilterItem({required this.id, required this.title, this.isSelected = false});
// }
/// deatils page code without page view
/// // import 'package:flutter/material.dart';
// // import '../../model/model.dart';
// //
// // class DetailsPage extends StatefulWidget {
// //   final Data data;
// //
// //   DetailsPage({required this.data, required List<Data> apiData});
// //
// //   @override
// //   State<DetailsPage> createState() => _DetailsPageState();
// // }
// //
// // class _DetailsPageState extends State<DetailsPage> {
// //   late String selectedPhoto;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Set the initial selected photo if imageMapping is not empty
// //     if (widget.data.imageMapping != null && widget.data.imageMapping!.isNotEmpty) {
// //       selectedPhoto = 'https://api.tridhyatech.com/${widget.data.imageMapping![0].portfolioImage}';
// //     } else {
// //       selectedPhoto = ''; // Set a default image if imageMapping is empty
// //     }
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     String techName = widget.data.techMapping?.isNotEmpty ?? false
// //         ? widget.data.techMapping!.map((techMap) => techMap.techName).join(', ')
// //         : '';
// //     String domainName = widget.data.domainName ?? '';
// //     String descriptionText = widget.data.description ?? '';
// //     String projectName = widget.data.projectName ?? '';
// //     List<ImageMapping> imageMapping = widget.data.imageMapping ?? [];
// //     // String selectedPhoto = '';
// //     //
// //     // // Set the initial selected photo if imageMapping is not empty
// //     // if (imageMapping.isNotEmpty) {
// //     //   selectedPhoto = 'https://api.tridhyatech.com/${imageMapping[0].portfolioImage}';
// //     // }
// //
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: <Widget>[
// //             // Your UI components for the details page
// //             Container(
// //               height: 135, // Set your desired height
// //               padding: EdgeInsets.all(8.0),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   begin: Alignment(0.00, -1.00),
// //                   end: Alignment(0, 1),
// //                   colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
// //                 ),
// //               ),
// //               child: Column(
// //                 children: <Widget>[
// //                   Padding(
// //                     padding: const EdgeInsets.only(top: 28.0),
// //                     child: Container(
// //                       height: 40,
// //                       child: Row(
// //                         children: <Widget>[
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Image.asset(
// //                               'images/Group 29.png',
// //                               width: 150,
// //                               height: 50,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   Container(
// //                     padding: EdgeInsets.all(0),
// //                     child: Row(
// //                       children: <Widget>[
// //                         IconButton(
// //                           icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
// //                           onPressed: () {
// //                             Navigator.pop(context); // Handle back button press
// //                           },
// //                         ),
// //                         SizedBox(width: 10),
// //                         // Text(
// //                         //   '$projectName',
// //                         //   style: TextStyle(
// //                         //     color: Color(0xFF00517C),
// //                         //     fontSize: 22,
// //                         //     fontFamily: 'Source Sans Pro',
// //                         //     fontWeight: FontWeight.w700,
// //                         //     height: 0,
// //                         //   ),
// //                         // ),
// //                         Text(
// //                           '$projectName',
// //                           style: TextStyle(
// //                             color: Color(0xFF00517C),
// //                             fontSize: 20,
// //                             fontFamily: 'Source Sans Pro',
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                           maxLines: 2, // Limit the text to 2 lines
// //                           overflow: TextOverflow.ellipsis, // Apply ellipsis (...) if the text overflows
// //                         ),
// //                         Spacer(),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 20, right: 20),
// //               child: Container(
// //                 width: double.infinity,
// //                 height: 200, // Set your desired height for the selected photo
// //                 child: Image.network(
// //                   '$selectedPhoto',
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 0.0, right: 0),
// //               child: Container(
// //                 width: 600,
// //                 height: 150,
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   children: imageMapping.map((imageData) {
// //                     String imageUrl = 'https://api.tridhyatech.com/${imageData.portfolioImage}';
// //                     return Padding(
// //                       padding: const EdgeInsets.all(0.0),
// //                       child: GestureDetector(
// //                         onTap: () {
// //                           print('Image tapped!');
// //                           setState(() {
// //                             selectedPhoto = imageUrl;
// //                           });
// //                         },
// //                         child: Image.network(
// //                           imageUrl,
// //                           width: 140,
// //                           height: 150,
// //                           fit: BoxFit.contain,
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'Used Technology',
// //                     style: TextStyle(
// //                       color: Color(0xFF00517C),
// //                       fontSize: 24,
// //                       fontFamily: 'Source Sans Pro',
// //                       fontWeight: FontWeight.w600,
// //                       height: 0,
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.only(right: 15.0),
// //                     child: Text(
// //                       '$techName',
// //                       style: TextStyle(
// //                         color: Color(0xFF7E7E7E),
// //                         fontSize: 16,
// //                         fontFamily: 'Source Sans Pro',
// //                         fontWeight: FontWeight.w400,
// //                         height: 0,
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 40),
// //                   Padding(
// //                     padding: const EdgeInsets.only(right: 76.0),
// //                     child: Text(
// //                       'Overview',
// //                       style: TextStyle(
// //                         color: Color(0xFF00517C),
// //                         fontSize: 24,
// //                         fontFamily: 'Source Sans Pro',
// //                         fontWeight: FontWeight.w600,
// //                         height: 0,
// //                       ),
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.only(right: 15.0),
// //                     child: Text(
// //                       '$domainName',
// //                       style: TextStyle(
// //                         color: Color(0xFF7E7E7E),
// //                         fontSize: 16,
// //                         fontFamily: 'Source Sans Pro',
// //                         fontWeight: FontWeight.w400,
// //                         height: 0,
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 40),
// //                   Padding(
// //                     padding: const EdgeInsets.only(right: 76.0),
// //                     child: Text(
// //                       'Description',
// //                       style: TextStyle(
// //                         color: Color(0xFF00517C),
// //                         fontSize: 24,
// //                         fontFamily: 'Source Sans Pro',
// //                         fontWeight: FontWeight.w600,
// //                         height: 0,
// //                       ),
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.only(right: 15.0),
// //                     child: Text(
// //                       '$descriptionText',
// //                       style: TextStyle(
// //                         color: Color(0xFF7E7E7E),
// //                         fontSize: 16,
// //                         fontFamily: 'Source Sans Pro',
// //                         fontWeight: FontWeight.w400,
// //                         height: 0,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }