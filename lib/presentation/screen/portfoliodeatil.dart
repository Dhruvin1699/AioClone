
import 'package:flutter/material.dart';

import '../../model/model.dart';

class DetailsPage extends StatefulWidget {
  final List<Data>? apiData;
  final int initialPageIndex;

  DetailsPage({required this.apiData, required this.initialPageIndex});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late PageController _pageController;
  late int _currentPageIndex;
  late String selectedPhoto;
  // String selectedPhoto = '';
  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialPageIndex;
    _pageController = PageController(initialPage: widget.initialPageIndex);
    // selectedPhoto = '';
    List<ImageMapping> imageMapping = widget.apiData![_currentPageIndex].imageMapping ?? [];
    if (imageMapping.isNotEmpty) {
      selectedPhoto = 'https://api.tridhyatech.com/${imageMapping[0].portfolioImage}';
    }
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.apiData!.length,
          onPageChanged: (index) {
            setState(() {
              print("Page changed to: $index");
              _currentPageIndex = index;
              List<ImageMapping> imageMapping = widget.apiData![_currentPageIndex].imageMapping ?? [];
              if (imageMapping.isNotEmpty) {
                selectedPhoto = 'https://api.tridhyatech.com/${imageMapping[0].portfolioImage}';
              }
            });
          },
          itemBuilder: (context, index) {
            return _buildDetailsPage(widget.apiData![index]);
          },
        ),
      ),
    );
  }




  Widget _buildDetailsPage(Data data) {
      String techName = data.techMapping?.isNotEmpty ?? false
        ? data.techMapping!.map((techMap) => techMap.techName).join(', ')
        : '';
    String domainName = data.domainName ?? '';
    String descriptionText = data.description ?? '';
    String projectName = data.projectName ?? '';
    List<ImageMapping> imageMapping = data.imageMapping ?? [];
    // String selectedPhoto = ''; // Initialize the selected photo URL

      // Set the initial selected photo if imageMapping is not empty

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Your UI components for the details page
          // ...

          Container(
             // Set your desired height
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
                          '$projectName',
                          style: TextStyle(
                            // overflow: TextOverflow.ellipsis,
                            color: Color(0xFF00517C),
                            fontSize: 22,
                            fontFamily: 'Source Sans Pro',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              height: 200, // Set your desired height for the selected photo
              child: Image.network(
                // imageMapping.isNotEmpty ? 'https://api.tridhyatech.com/${imageMapping[0].portfolioImage}' : '',
                selectedPhoto,
                fit: BoxFit.cover,
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
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: () {
                        print('Image tapped!');
                        setState(() {
                          selectedPhoto = imageUrl; // Update the selectedPhoto variable inside setState
                        });
                      },
                      child: Image.network(
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
