// import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../Data/database.dart';
// import '../../Data/domaindatabse.dart';
// import '../../Data/techdatabse.dart';
// import '../../model/domain.dart';
// import '../../model/tech.dart';
//
// class FilterPage extends StatefulWidget {
//   final List<String> selectedFilterIds;
//
//   const FilterPage({super.key, required this.selectedFilterIds});
//
//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }
//
// class _FilterPageState extends State<FilterPage> {
//   List<FilterItem> items = [];
//
//   // List<FilterItem> selectedItems = [];
//   String selectedFilter = 'Domains/industries';
//   List<String> filters = ['Domains/industries', 'Technology/Tech Stack'];
//   List<FilterItem> domainItems = [];
//   List<FilterItem> techItems = [];
//   List<FilterItem> selectedItems = [];
//   @override
//   void initState() {
//     super.initState();
//     print('id:${widget.selectedFilterIds}');
//     // Fetch data when the screen initializes
//     _loadData();
//
//   }
//
//   static Future<List<DomainData>> fetchDomainItems() async {
//     final response = await http
//         .get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/domain'));
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       Domain domain = Domain.fromJson(data);
//       // await DomainDatabase.insertDomains(domain.data ?? []);
//       print('data:$domain.data');
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
//       // await TechDatabase.insertTechStack(tech.data ?? []);
//       return tech.data ?? [];
//     } else {
//       throw Exception('Failed to load tech stack items');
//     }
//   }
//   List<FilterItem> allItems = [];
//   Future<void> _loadData() async {
//     try {
//       List<FilterItem> loadedItems = [];
//
//       // Check for internet connectivity
//       var connectivityResult = await Connectivity().checkConnectivity();
//       bool isConnected = connectivityResult != ConnectivityResult.none;
//
//       if (isConnected) {
//         // Fetch data from API if there is an internet connection
//         if (selectedFilter == 'Domains/industries') {
//           List<DomainData> domainData = await fetchDomainItems();
//           domainItems = domainData
//               .map((data) =>
//               FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
//               .toList();
//           loadedItems = domainItems;
//         } else {
//           List<TechData> techData = await fetchTechStackItems();
//           techItems = techData
//               .map((data) =>
//               FilterItem(id: data.id ?? '', title: data.techName ?? ''))
//               .toList();
//           loadedItems = techItems;
//         }
//       } else {
//         // Load data from local database if there is no internet connection
//         if (selectedFilter == 'Domains/industries') {
//           List<DomainData> domainData = await DomainDatabase.getDomains();
//           domainItems = domainData
//               .map((data) =>
//               FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
//               .toList();
//           loadedItems = domainItems;
//         } else {
//           List<TechData> techData = await TechDatabase.getTechStack();
//           techItems = techData
//               .map((data) =>
//               FilterItem(id: data.id ?? '', title: data.techName ?? ''))
//               .toList();
//           loadedItems = techItems;
//         }
//       }
//
//
//       setState(() {
//         items = loadedItems.map((item) {
//           // Update isSelected based on selectedFilterIds
//           item.isSelected = widget.selectedFilterIds.contains(item.id);
//           return item;
//         }).toList();
//
//         selectedItems = items.where((item) => item.isSelected).toList();
//
//       });
//
//
//     } catch (error) {
//       print('Error: $error');
//       // Handle error, show a snackbar, or display an error message on UI
//     }
//   }
//
//   Future<bool> checkInternetConnectivity() async {
//     // Implement your logic to check internet connectivity, you can use packages like connectivity
//     // For example:
//     // var connectivityResult = await (Connectivity().checkConnectivity());
//     // return connectivityResult != ConnectivityResult.none;
//     return false; // For the sake of example, assuming there is always internet connectivity
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(0.00, -1.00),
//                 end: Alignment(0, 1),
//                 colors: [
//                   Color(0xFFDEF8FF),
//                   Colors.white.withOpacity(0.9200000166893005),
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
//                           width: 10,
//                           child: Icon(Icons.arrow_back_ios),
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
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
//                       TextButton(
//                         onPressed: () async {
//                           // Clear the selection of items in both lists
//                           setState(() {
//                             selectedItems=[];
//                             // widget.selectedFilterIds=[];
//                             domainItems.forEach((item) {
//                               item.isSelected = false;
//                             });
//
//                             techItems.forEach((item) {
//                               item.isSelected = false;
//                             });
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.transparent,
//                         ),
//                         child: Text('Clear'),
//                       ),
//
//                       ElevatedButton(
//                         onPressed: () async {
//                           // Filter out selected items and extract their IDs
//                           List<String> selectedItemsIds = selectedItems
//                               .where((item) => item.isSelected)
//                               .map((item) => item.id)
//                               .toList();
//
//                           // Close the filter page and pass the selectedItemsIds back
//                           Navigator.pop(context, selectedItemsIds);
//                         },
//                         child: Text('Apply'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Horizontal ListView for Filters
//           Container(
//             height: 40,
//             width: 370,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: filters.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         selectedFilter = filters[index];
//                         // selectedItems = selectedFilter == 'Domains/industries' ? domainItems : techItems;
//                         // Load data based on the selected filter
//                         _loadData();
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: selectedFilter == filters[index]
//                           ? Colors.white
//                           : Color.fromRGBO(169, 169, 169, 0.1),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(
//                           filters[index],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(width: 8), // Add space between the texts
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           Expanded(
//             child: selectedFilter == 'Domains/industries'
//                 ? _buildDomainListView()
//                 : selectedFilter == 'Technology/Tech Stack'
//                 ? _buildTechListView()
//                 : Container(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDomainListView() {
//     return ListView.builder(
//       itemCount: domainItems.length,
//       itemBuilder: (context, index) {
//
//         FilterItem item = domainItems[index];
//         // Check if the item's id is in the selectedItems list
//         bool isSelected = selectedItems.any((selectedItem) => selectedItem.id == item.id);
//
//         // Update isSelected property
//         item.isSelected = isSelected;
//
//         return _buildFilterItemWidget(item, index);
//       },
//     );
//   }
//
//   Widget _buildTechListView() {
//     return ListView.builder(
//       itemCount: techItems.length,
//       itemBuilder: (context, index) {
//         FilterItem item = techItems[index];
//         bool isSelected = selectedItems.any((selectedItem) => selectedItem.id == item.id);
//
//         // Update isSelected property
//         item.isSelected = isSelected;
//         return _buildFilterItemWidget(item, index);
//       },
//     );
//   }
//
//   Widget _buildFilterItemWidget(FilterItem item, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           item.isSelected = !item.isSelected;
//
//           if (item.isSelected) {
//             selectedItems.add(item);
//           } else {
//             selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
//           }
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Color(0xFFECEFF1),
//           border: Border.all(
//             color: Color(0xFFECEFF1),
//           ),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         margin: EdgeInsets.all(8.0),
//         child: ListTile(
//           title: Text(item.title),
//           trailing: Checkbox(
//             value: item.isSelected,
//             onChanged: (value) {
//               setState(() {
//                 item.isSelected = value ?? false;
//
//                 if (item.isSelected) {
//                   selectedItems.add(item);
//                 } else {
//                   selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
//                 }
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }
// class FilterItem {
//   final String id;
//   final String title;
//   bool isSelected;
//
//   FilterItem({required this.id, required this.title, this.isSelected = false});
// }
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Data/database.dart';
import '../../Data/domaindatabse.dart';
import '../../Data/techdatabse.dart';
import '../../model/domain.dart';
import '../../model/tech.dart';

class FilterPage extends StatefulWidget {
  final List<String> selectedFilterIds;

  const FilterPage({super.key, required this.selectedFilterIds});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // List<FilterItem> items = [];

  // List<FilterItem> selectedItems = [];
  String selectedFilter = 'Domains/industries';
  List<String> filters = ['Domains/industries', 'Technology/Tech Stack'];
  List<FilterItem> domainItems = [];
  List<FilterItem> techItems = [];
  List<FilterItem> selectedItems = [];
  @override
  void initState() {
    super.initState();
    print('id:${widget.selectedFilterIds}');
    selectedItems = widget.selectedFilterIds.map((item) => FilterItem(title: "",id: item ,isSelected: true)).toList();
    // Fetch data when the screen initializes
    _loadData();

  }

  static Future<List<DomainData>> fetchDomainItems() async {
    final response = await http
        .get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/domain'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Domain domain = Domain.fromJson(data);
      // await DomainDatabase.insertDomains(domain.data ?? []);
      print('data:$domain.data');
      return domain.data ?? [];
    } else {
      throw Exception('Failed to load domain items');
    }
  }

  static Future<List<TechData>> fetchTechStackItems() async {
    final response = await http
        .get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/tech'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Tech tech = Tech.fromJson(data);
      // await TechDatabase.insertTechStack(tech.data ?? []);
      return tech.data ?? [];
    } else {
      throw Exception('Failed to load tech stack items');
    }
  }

  Future<void> _loadData() async {
    try {
      List<FilterItem> loadedItems = [];

      // Check for internet connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        // Fetch data from API if there is an internet connection
        if (selectedFilter == 'Domains/industries') {
          List<DomainData> domainData = await fetchDomainItems();
          domainItems = domainData
              .map((data) => FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
              .toList();
          loadedItems = domainItems;
        } else {
          List<TechData> techData = await fetchTechStackItems();
          techItems = techData
              .map((data) => FilterItem(id: data.id ?? '', title: data.techName ?? ''))
              .toList();
          loadedItems = techItems;
        }
      } else {
        // Load data from local database if there is no internet connection
        if (selectedFilter == 'Domains/industries') {
          List<DomainData> domainData = await DomainDatabase.getDomains();
          domainItems = domainData
              .map((data) => FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
              .toList();
          loadedItems = domainItems;
        } else {
          List<TechData> techData = await TechDatabase.getTechStack();
          techItems = techData
              .map((data) => FilterItem(id: data.id ?? '', title: data.techName ?? ''))
              .toList();
          loadedItems = techItems;
        }
      }

      setState(() {
        if (selectedFilter == 'Domains/industries') {
          domainItems = loadedItems;
        } else {
          techItems = loadedItems;
        }

        // Update isSelected based on selectedFilterIds
        domainItems.forEach((item) {
          item.isSelected = selectedItems.any((selectedItem) => selectedItem.id == item.id);
        });



        techItems.forEach((item) {
          item.isSelected = selectedItems.any((selectedItem) => selectedItem.id == item.id);
        });
        print("selectedfhgadgfmajsgefegsajcfysaghfahgsdfgweafs::::::::::::::::::::::::: $selectedItems");

        // selectedItems = widget.selectedFilterIds.where((item) => item.isSelected).toList();
        // selectedItems = selectedFilter == 'Domains/industries' ? domainItems : techItems;
      });
    } catch (error) {
      print('Error: $error');
      // Handle error, show a snackbar, or display an error message on UI
    }
  }

  Future<bool> checkInternetConnectivity() async {
    // Implement your logic to check internet connectivity, you can use packages like connectivity
    // For example:
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // return connectivityResult != ConnectivityResult.none;
    return false; // For the sake of example, assuming there is always internet connectivity
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Container(
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
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Container(
                          width: 10,
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Color(0xFF00517C),
                          fontSize: 22,
                          fontFamily: 'Source Sans Pro',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          // Clear the selection of items in both lists
                          setState(() {
                            selectedItems=[];
                            // widget.selectedFilterIds=[];
                            domainItems.forEach((item) {
                              item.isSelected = false;
                            });

                            techItems.forEach((item) {
                              item.isSelected = false;
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                        ),
                        child: Text('Clear'),
                      ),

                      ElevatedButton(
                        onPressed: () async {

                          for(var i in selectedItems){
                            print("Slected Item inhgfjhgf ${i.isSelected}  ${i.id
                            }");
                          }
                          // Filter out selected items and extract their IDs
                          List<String> selectedItemsIds = selectedItems
                              .where((item) => item.isSelected)
                              .map((item) => item.id)
                              .toList();

                          // Close the filter page and pass the selectedItemsIds back
                          Navigator.pop(context, selectedItemsIds);
                        },
                        child: Text('Apply'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Horizontal ListView for Filters
          Container(
            height: 40,
            width: 370,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFilter = filters[index];
                        // selectedItems = selectedFilter == 'Domains/industries' ? domainItems : techItems;
                        // Load data based on the selected filter
                        _loadData();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: selectedFilter == filters[index]
                          ? Color.fromRGBO(169, 169, 169, 0.1)
                          : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          filters[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8), // Add space between the texts
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: selectedFilter == 'Domains/industries'
                ? _buildDomainListView()
                : selectedFilter == 'Technology/Tech Stack'
                ? _buildTechListView()
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainListView() {
    return ListView.builder(
      itemCount: domainItems.length,
      itemBuilder: (context, index) {

        FilterItem item = domainItems[index];
        // Check if the item's id is in the selectedItems list
        bool isSelected = selectedItems.any((selectedItem) => selectedItem.id == item.id);

        // Update isSelected property
        item.isSelected = isSelected;

        return _buildFilterItemWidget(item, index);
      },
    );
  }

  Widget _buildTechListView() {
    return ListView.builder(
      itemCount: techItems.length,
      itemBuilder: (context, index) {
        FilterItem item = techItems[index];
        bool isSelected = selectedItems.any((selectedItem) => selectedItem.id == item.id);

        // Update isSelected property
        item.isSelected = isSelected;
        return _buildFilterItemWidget(item, index);
      },
    );
  }

  Widget _buildFilterItemWidget(FilterItem item, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          item.isSelected = !item.isSelected;

          if (item.isSelected) {
            selectedItems.add(item);
          } else {
            selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFECEFF1),
          border: Border.all(
            color: Color(0xFFECEFF1),
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(item.title),
          trailing: Checkbox(
            value: item.isSelected,
            onChanged: (value) {
              setState(() {
                print("tech item ${value}  ${item.isSelected}");
                item.isSelected = value ?? false;

                if (item.isSelected) {
                  print("tech item selected array $value  ${item.isSelected}");
                  selectedItems.add(item);
                  print("selected item now  ::::::::::::: $selectedItems");
                  for(var i in selectedItems){
                    print("selected item now  ::::::::::::: ${i.id} ${i.isSelected}");
                  }
                } else {
                  selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
                }
              });
            },
          ),
        ),
      ),
    );
  }


}
class FilterItem {
  final String id;
  final String title;
  bool isSelected;

  FilterItem({required this.id, required this.title, this.isSelected = false});
}
