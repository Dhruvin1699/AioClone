

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../model/model.dart';

class DetailsPage extends StatefulWidget {
  final List<Data>? apiData;
  final int initialPageIndex;

  DetailsPage({required this.apiData, required this.initialPageIndex,});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late PageController _pageController;
  late int _currentPageIndex;
  String selectedPhoto = '';
  List<TechMapping> techMappingList = [];

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialPageIndex;
    _pageController = PageController(initialPage: widget.initialPageIndex);
    _updatePageContent(widget.initialPageIndex);
  }


  void _updatePageContent(int index) {
    setState(() {
      _currentPageIndex = index;
      List<ImageMapping> imageMapping = widget.apiData![index].imageMapping ?? [];
      if (imageMapping.isNotEmpty) {
        selectedPhoto = 'https://api.tridhyatech.com/${imageMapping[0].portfolioImage}';
      }
      techMappingList = widget.apiData![index].techMapping ?? [];
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
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
                        icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
                        onPressed: () {
                          Navigator.pop(context); // Handle back button press
                        },
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${widget.apiData![_currentPageIndex].projectName}',
                          style: TextStyle(
                            color: Color(0xFF00517C),
                            fontSize: 22,
                            fontFamily: 'Source Sans Pro',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          maxLines: 2, // Set the maximum number of lines to 2
                          overflow: TextOverflow.visible, // Add this to show ellipsis (...) if the text overflows
                        ),
                      ),


                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.apiData!.length,
                onPageChanged: (index) {
                  _updatePageContent(index);
                },
                itemBuilder: (context, index) {
                  return _buildDetailsPage(widget.apiData![index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsPage(Data data) {
    String techName = techMappingList.isNotEmpty
        ? techMappingList.map((techMap) => techMap.techName).join(', ')
        : '';
    print('techname:$techName');
    String domainName = data.domainName ?? '';
    String descriptionText = data.description ?? '';
    String projectName = data.projectName ?? '';
    List<ImageMapping> imageMapping = data.imageMapping ?? [];
    // ... rest of your code for the details page
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Your UI components for the details page
          // ...


          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              height: 200, // Set your desired height for the selected photo
              child: GestureDetector(
                onTap: () {
                  print('Selected photo tapped!');
                  // Handle the tap event if needed
                },
                child: selectedPhoto.isNotEmpty && File(selectedPhoto).existsSync()
                    ? Image.file(
                  File(selectedPhoto),
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  selectedPhoto,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      // Use a placeholder or loading indicator if needed
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    // If there's an error loading from the network, show the first image in the list if available
                    if (imageMapping.isNotEmpty) {
                      String firstImageUrl = 'https://api.tridhyatech.com/${imageMapping[0].portfolioImage}';
                      String localImagePath = "/data/user/0/com.example.aioaapbardemo/app_flutter/${imageMapping[0].portfolioImage}";

                      return localImagePath.isNotEmpty && File(localImagePath).existsSync()
                          ? Image.file(
                        File(localImagePath),
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        firstImageUrl,
                        fit: BoxFit.cover,
                      );
                    } else {
                      // Use a placeholder or default image if no images are available
                      return Center(
                        child: Icon(Icons.error),
                      );
                    }
                  },
                ),
              ),
            ),
          ),


          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0),
            child: Container(
              width: 600,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: imageMapping.map((imageData) {
                  String imageUrl = 'https://api.tridhyatech.com/${imageData.portfolioImage}';
                  String localImagePath = "/data/user/0/com.example.aioaapbardemo/app_flutter/${imageData.portfolioImage}"; // Use the local path if available

                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: () {
                        print('Image tapped!');
                        setState(() {
                          selectedPhoto = localImagePath.isNotEmpty && File(localImagePath).existsSync()
                              ? localImagePath
                              : imageUrl; // Update the selectedPhoto variable inside setState
                        });
                      },
                      child: localImagePath.isNotEmpty && File(localImagePath).existsSync()
                          ? Image.file(
                        File(localImagePath),
                        width: 140,
                        height: 150,
                        fit: BoxFit.contain,
                      )
                          : Image.network(
                        imageUrl,
                        width: 140,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Used Technology',
                  style: TextStyle(
                    color: Color(0xFF00517C),
                    fontSize: 24,
                    fontFamily: 'Source Sans Pro',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    '$techName',
                    style: TextStyle(
                      color: Color(0xFF7E7E7E),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),

                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(right: 76.0),
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      color: Color(0xFF00517C),
                      fontSize: 24,
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    '$domainName',
                    style: TextStyle(
                      color: Color(0xFF7E7E7E),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.only(right: 76.0),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xFF00517C),
                      fontSize: 24,
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    '$descriptionText',
                    style: TextStyle(
                      color: Color(0xFF7E7E7E),
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
