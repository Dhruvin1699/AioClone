import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/domain.dart';
import '../../model/tech.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<FilterItem> items = [];
  String selectedFilter = 'Domains/industries';
  List<String> item = ['Domains/industries', 'Technology/Tech Stack'];

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    _loadData();
  }

  static Future<List<DomainData>> fetchDomainItems() async {
    final response = await http
        .get(Uri.parse('https://api.tridhyatech.com/api/v1/lookup/domain'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Domain domain = Domain.fromJson(data);
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
      return tech.data ?? [];
    } else {
      throw Exception('Failed to load tech stack items');
    }
  }

  Future<void> _loadData() async {
    try {
      List<FilterItem> loadedItems = [];
      if (selectedFilter == 'Domains/industries') {
        List<DomainData> domainData = await fetchDomainItems();
        loadedItems = domainData
            .map((data) =>
            FilterItem(id: data.id ?? '', title: data.domainName ?? ''))
            .toList();
      } else {
        List<TechData> techData = await fetchTechStackItems();
        loadedItems = techData
            .map((data) =>
            FilterItem(id: data.id ?? '', title: data.techName ?? ''))
            .toList();
      }

      setState(() {
        items = loadedItems;
      });
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Column(children: <Widget>[
          // Your filter options UI
          // ...
          Container(
            height: 135,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [
                  Color(0xFFDEF8FF),
                  Colors.white.withOpacity(0.9200000166893005)
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
                            width: 10, child: Icon(Icons.arrow_back_ios)),
                        onPressed: () {
                          // Handle back button press
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
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Filter out selected items
                      //     List<String> selectedItemsList = items
                      //         .where((item) => item.isSelected)
                      //         .map((item) => item.title) // Extract titles as strings
                      //         .toList();
                      //
                      //     // Close the filter page and pass the selectedItemsList back to the home screen
                      //     Navigator.pop(context, selectedItemsList);
                      //   },
                      //   child: Text('Apply'),
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          // Filter out selected items and extract their IDs
                          List<String> selectedItemsIds = items
                              .where((item) => item.isSelected)
                              .map((item) => item.id) // Extract IDs as strings
                              .toList();

                          // Close the filter page and pass the selectedItemsIds back to the home screen
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: <Widget>[
                  // Left Sidebar
                  Container(
                    width: 200,
                    height: double.infinity,
                    child: ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(item[index]),
                          onTap: () {
                            setState(() {
                              selectedFilter = item[index];
                              // Load data based on the selected filter
                              _loadData();
                            });
                          },
                          selected: selectedFilter == item[index],
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        FilterItem item = items[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFECEFF1),
                            border: Border.all(color: Color(0xFFECEFF1),), // Add border as needed
                            borderRadius: BorderRadius.circular(8.0), // Add border radius as needed
                          ),
                          margin: EdgeInsets.all(8.0), // Add margin as needed
                          child: ListTile(
                            title: Text(item.title),
                            trailing: Checkbox(
                              value: item.isSelected,
                              onChanged: (value) {
                                setState(() {
                                  item.isSelected = value ?? false;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )

                  // Apply button
                ],
              ),
            ),
          )
        ]));
  }
}

class FilterItem {
  final String id;
  final String title;
  bool isSelected;

  FilterItem({required this.id, required this.title, this.isSelected = false});
}
