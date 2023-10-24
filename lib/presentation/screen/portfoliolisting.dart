// // import 'package:flutter/material.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// // //
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   final List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
// //   final List<Map<String, dynamic>> gridData = [
// //     {'imagePath': 'images/image1.jpg', 'itemName': 'Item 5'},
// //     {'imagePath': 'images/image2.jpg', 'itemName': 'Item 2'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
// //     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 5'},
// //     // Add more items as needed
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     String selectedDropdownItem = dropdownItems.first;
// //     return Scaffold(
// //       body: ListView.builder(
// //         itemCount: 1,
// //         itemBuilder: (BuildContext context, int index) {
// //           return Column(
// //             children: <Widget>[
// //               //
// //               Container(
// //                 height: 105, // Set your desired height
// //                 padding: EdgeInsets.all(8.0),
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     begin: Alignment(0.00, -1.00),
// //                     end: Alignment(0,1),
// //                     colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
// //                   ),
// //                 ),
// //                 child: Column(
// //                   children: <Widget>[
// //                     Container(
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
// //                     Container(
// //                       padding: EdgeInsets.all(0),
// //                       child: Row(
// //                         children: <Widget>[
// //                           IconButton(
// //                             icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
// //                             onPressed: () {
// //                               // Handle back button press
// //                             },
// //                           ),
// //                           SizedBox(width: 10),
// //                           Text(
// //                             'Work/Portfolio',
// //                             style: TextStyle(
// //                               color: Color(0xFF00517C),
// //                               fontSize: 22,
// //                               fontFamily: 'Source Sans Pro',
// //                               fontWeight: FontWeight.w700,
// //                               height: 0,
// //                             ),
// //                           ),
// //                           Spacer(),
// //                           CustomDropdown(
// //                             selectedItem: selectedDropdownItem,
// //                             items: dropdownItems,
// //                             onItemSelected: (String newItem) {
// //                               selectedDropdownItem = newItem;
// //                               print('Selected Item: $newItem');
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                   ],
// //                 ),
// //               ),
// //
// //               SingleChildScrollView(
// //                 child: GridView.builder(
// //                   shrinkWrap: true,
// //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                     childAspectRatio: 1,
// //                   ),
// //                   itemCount: gridData.length,
// //                   itemBuilder: (BuildContext context, int index) {
// //                     return GridItem(
// //                       imagePath: gridData[index]['imagePath'],
// //                       itemName: gridData[index]['itemName'],
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// // class CustomDropdown extends StatelessWidget {
// //   final String selectedItem;
// //   final List<String> items;
// //   final Function(String) onItemSelected;
// //
// //   CustomDropdown({
// //     required this.selectedItem,
// //     required this.items,
// //     required this.onItemSelected,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return PopupMenuButton<String>(
// //       onSelected: (String value) {
// //         onItemSelected(value);
// //       },
// //       itemBuilder: (BuildContext context) {
// //         return items.map((String item) {
// //           return PopupMenuItem<String>(
// //             value: item,
// //             child: Container(
// //
// //               padding: EdgeInsets.all(8.0), // Optional: Add padding to the container
// //               child: Text(item),
// //             ),
// //           );
// //         }).toList();
// //       },
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             border: Border.all(color: Color(0xFF00517C)),
// //           ),
// //           child: Row(
// //             children: [
// //               Text(
// //                 selectedItem,
// //                 style: TextStyle(color: Colors.blueGrey),
// //               ),
// //               SizedBox(width: 5),
// //               Icon(
// //                 Icons.arrow_drop_down,
// //                 color: Colors.blueGrey,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // class GridItem extends StatelessWidget {
// //   final String imagePath;
// //   final String itemName;
// //
// //   GridItem({required this.imagePath, required this.itemName});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.all(8.0),
// //       child: Column(
// //         children: <Widget>[
// //           Container(
// //             width: 195, // Set your desired width
// //             height: 195, // Set your desired height
// //             decoration: BoxDecoration(
// //               color: Colors.grey[200], // You can set your desired background color
// //               borderRadius: BorderRadius.circular(10),
// //               image: DecorationImage(
// //                 image: AssetImage(imagePath),
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //             child: Align(
// //               alignment: Alignment.bottomCenter,
// //               child: Padding(
// //                 padding: const EdgeInsets.only(bottom: 8.0),
// //                 child: Text(
// //                   itemName,
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
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
// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
//   final List<Map<String, dynamic>> gridData = [
//     {'imagePath': 'images/image1.jpg', 'itemName': 'Item 5'},
//     {'imagePath': 'images/image2.jpg', 'itemName': 'Item 2'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 5'},
//     // Add more items as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     String selectedDropdownItem = dropdownItems.first;
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top:40),
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 105, // Set your desired height
//               padding: EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment(0.00, -1.00),
//                   end: Alignment(0,1),
//                   colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
//                 ),
//               ),
//               child: Column(
//                 children: <Widget>[
//                   Container(
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
//                   Container(
//                     padding: EdgeInsets.all(0),
//                     child: Row(
//                       children: <Widget>[
//                         IconButton(
//                           icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
//                           onPressed: () {
//                             // Handle back button press
//                           },
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Work/Portfolio',
//                           style: TextStyle(
//                             color: Color(0xFF00517C),
//                             fontSize: 22,
//                             fontFamily: 'Source Sans Pro',
//                             fontWeight: FontWeight.w700,
//                             height: 0,
//                           ),
//                         ),
//                         Spacer(),
//                         CustomDropdown(
//                           selectedItem: selectedDropdownItem,
//                           items: dropdownItems,
//                           onItemSelected: (String newItem) {
//                             selectedDropdownItem = newItem;
//                             print('Selected Item: $newItem');
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 1,
//                 ),
//                 itemCount: gridData.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GridItem(
//                     imagePath: gridData[index]['imagePath'],
//                     itemName: gridData[index]['itemName'],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomDropdown extends StatelessWidget {
//   final String selectedItem;
//   final List<String> items;
//   final Function(String) onItemSelected;
//
//   CustomDropdown({
//     required this.selectedItem,
//     required this.items,
//     required this.onItemSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       onSelected: (String value) {
//         onItemSelected(value);
//       },
//       itemBuilder: (BuildContext context) {
//         return items.map((String item) {
//           return PopupMenuItem<String>(
//             value: item,
//             child: Container(
//               padding: EdgeInsets.all(8.0), // Optional: Add padding to the container
//               child: Text(item),
//             ),
//           );
//         }).toList();
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xFF00517C)),
//           ),
//           child: Row(
//             children: [
//               Text(
//                 selectedItem,
//                 style: TextStyle(color: Colors.blueGrey),
//               ),
//               SizedBox(width: 5),
//               Icon(
//                 Icons.arrow_drop_down,
//                 color: Colors.blueGrey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class GridItem extends StatelessWidget {
//   final String imagePath;
//   final String itemName;
//
//   GridItem({required this.imagePath, required this.itemName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(8.0),
//       child: Column(
//         children: <Widget>[
//           Container(
//             width: 195, // Set your desired width
//             height: 195, // Set your desired height
//             decoration: BoxDecoration(
//               color: Colors.grey[200], // You can set your desired background color
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 image: AssetImage(imagePath),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Text(
//                   itemName,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
// //
//
// class _HomeScreenState extends State<HomeScreen> {
//   final List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
//   final List<Map<String, dynamic>> gridData = [
//     {'imagePath': 'images/image1.jpg', 'itemName': 'Item 5'},
//     {'imagePath': 'images/image2.jpg', 'itemName': 'Item 2'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 3'},
//     {'imagePath': 'images/image3.jpg', 'itemName': 'Item 5'},
//     // Add more items as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     String selectedDropdownItem = dropdownItems.first;
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: 1,
//         itemBuilder: (BuildContext context, int index) {
//           return Column(
//             children: <Widget>[
//               //
//               Container(
//                 height: 105, // Set your desired height
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment(0.00, -1.00),
//                     end: Alignment(0,1),
//                     colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
//                   ),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       height: 40,
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.asset(
//                               'images/Group 29.png',
//                               width: 150,
//                               height: 50,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(0),
//                       child: Row(
//                         children: <Widget>[
//                           IconButton(
//                             icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
//                             onPressed: () {
//                               // Handle back button press
//                             },
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             'Work/Portfolio',
//                             style: TextStyle(
//                               color: Color(0xFF00517C),
//                               fontSize: 22,
//                               fontFamily: 'Source Sans Pro',
//                               fontWeight: FontWeight.w700,
//                               height: 0,
//                             ),
//                           ),
//                           Spacer(),
//                           CustomDropdown(
//                             selectedItem: selectedDropdownItem,
//                             items: dropdownItems,
//                             onItemSelected: (String newItem) {
//                               selectedDropdownItem = newItem;
//                               print('Selected Item: $newItem');
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//
//               SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 1,
//                   ),
//                   itemCount: gridData.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return GridItem(
//                       imagePath: gridData[index]['imagePath'],
//                       itemName: gridData[index]['itemName'],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class CustomDropdown extends StatelessWidget {
//   final String selectedItem;
//   final List<String> items;
//   final Function(String) onItemSelected;
//
//   CustomDropdown({
//     required this.selectedItem,
//     required this.items,
//     required this.onItemSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       onSelected: (String value) {
//         onItemSelected(value);
//       },
//       itemBuilder: (BuildContext context) {
//         return items.map((String item) {
//           return PopupMenuItem<String>(
//             value: item,
//             child: Container(
//
//               padding: EdgeInsets.all(8.0), // Optional: Add padding to the container
//               child: Text(item),
//             ),
//           );
//         }).toList();
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xFF00517C)),
//           ),
//           child: Row(
//             children: [
//               Text(
//                 selectedItem,
//                 style: TextStyle(color: Colors.blueGrey),
//               ),
//               SizedBox(width: 5),
//               Icon(
//                 Icons.arrow_drop_down,
//                 color: Colors.blueGrey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class GridItem extends StatelessWidget {
//   final String imagePath;
//   final String itemName;
//
//   GridItem({required this.imagePath, required this.itemName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(8.0),
//       child: Column(
//         children: <Widget>[
//           Container(
//             width: 195, // Set your desired width
//             height: 195, // Set your desired height
//             decoration: BoxDecoration(
//               color: Colors.grey[200], // You can set your desired background color
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 image: AssetImage(imagePath),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Text(
//                   itemName,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:aioaapbardemo/presentation/screen/portfoliodeatil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];


  List<Map<String, dynamic>> gridData = [];

  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  // Future<void> fetchDataFromApi() async {
  //   final response = await http.get(Uri.parse('https://api.tridhyatech.com/api/v1/portfolio/list'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> responseData = json.decode(response.body)['data'];
  //
  //     setState(() {
  //       gridData = responseData.map((item) {
  //         var imagePath = item['ImageMapping'] != null && item['ImageMapping'].isNotEmpty
  //             ? 'https://api.tridhyatech.com/${item['ImageMapping'][0]['PortfolioImage']}'
  //             : ''; // Set a default empty string if ImageMapping is empty
  //         return {
  //           'imagePath': imagePath,
  //           'itemName': item['ProjectName'],
  //         };
  //       }).toList();
  //
  //     }
  //
  //     );
  //   } else {
  //     throw Exception('Failed to load data from API');
  //   }
  // }

  Future<void> fetchDataFromApi() async {
    final response = await http.get(Uri.parse('https://api.tridhyatech.com/api/v1/portfolio/list'));
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body)['data'];

      setState(() {
        gridData = responseData.map((item) {
          var imagePath = item['ImageMapping'] != null && item['ImageMapping'].isNotEmpty
              ? 'https://api.tridhyatech.com/${item['ImageMapping'][0]['PortfolioImage']}'
              : ''; // Set a default empty string if ImageMapping is empty
          return {
            'imagePath': imagePath,
            'itemName': item['ProjectName'],
            'apiData': item, // Include the entire item data for the DetailsPage
          };
        }).toList();
      });

      // After setting gridData, navigate to DetailsPage with the first item's data
      // if (gridData.isNotEmpty) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DetailsPage(apiData: gridData[0]['apiData']),
      //     ),
      //   );
      // }
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDropdownItem = dropdownItems.first;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:40),
        child: Column(
          children: <Widget>[
            Container(
              height: 105, // Set your desired height
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0,1),
                  colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
                ),
              ),
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
                          icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
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
                          items: dropdownItems,
                          onItemSelected: (String newItem) {
                            selectedDropdownItem = newItem;
                            print('Selected Item: $newItem');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // child: GridView.builder(
              //   shrinkWrap: true,
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     childAspectRatio: 1,
              //   ),
              //   itemCount: gridData.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return GridItem(
              //       imagePath: gridData[index]['imagePath'],
              //       itemName: gridData[index]['itemName'], apiData: {},
              //     );
              //   },
              // ),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: gridData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var currentItem = gridData[index];
                    if (currentItem['apiData'] != null) {
                      return GridItem(
                        imagePath: currentItem['imagePath'],
                        itemName: currentItem['itemName'],
                        apiData: currentItem['apiData'],
                      );
                    } else {
                      // Handle the case where apiData is null or invalid.
                      return Container(); // or return an appropriate error widget
                    }
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String selectedItem;
  final List<String> items;
  final Function(String) onItemSelected;

  CustomDropdown({
    required this.selectedItem,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        onItemSelected(value);
      },
      itemBuilder: (BuildContext context) {
        return items.map((String item) {
          return PopupMenuItem<String>(
            value: item,
            child: Container(
              padding: EdgeInsets.all(8.0), // Optional: Add padding to the container
              child: Text(item),
            ),
          );
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF00517C)),
          ),
          child: Row(
            children: [
              Text(
                selectedItem,
                style: TextStyle(color: Colors.blueGrey),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class GridItem extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final Map<String, dynamic> apiData;

  GridItem({required this.imagePath, required this.itemName, required this.apiData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(apiData: apiData),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: imagePath,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 185,
              height: 175,
              fit: BoxFit.fitWidth,
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
}