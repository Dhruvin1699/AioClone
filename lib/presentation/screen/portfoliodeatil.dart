import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
final Map<String, dynamic> apiData;

DetailsPage({required this.apiData});
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  String selectedPhoto = '';

  @override

  void initState() {
    super.initState();
    // Set the initial selected photo to the first photo in the ImageMapping list if available
    if (widget.apiData['ImageMapping'] != null && widget.apiData['ImageMapping'].isNotEmpty) {
      selectedPhoto = 'https://api.tridhyatech.com/${widget.apiData['ImageMapping'][0]['PortfolioImage']}';
    }
  }
  @override
  Widget build(BuildContext context) {
    // String projectName = widget.apiData['ProjectName'];
    // String techName = widget.apiData['TechMapping'][0]['TechName'];
    // String domainName = widget.apiData['DomainName'];
    // String descriptionText = widget.apiData['Description'];
    // List<dynamic> imageMapping = widget.apiData['ImageMapping'];

    String projectName = widget.apiData['ProjectName'];
    String techName = '';
    String domainName = '';
    String descriptionText = '';
    List<dynamic> imageMapping = [];

    if (widget.apiData['TechMapping'] != null &&
        widget.apiData['TechMapping'].isNotEmpty) {
      techName = widget.apiData['TechMapping']
          .map((techMap) => techMap['TechName'].toString())
          .join(', ');
      domainName = widget.apiData['DomainName'];
      descriptionText = widget.apiData['Description'];
      imageMapping = widget.apiData['ImageMapping'];
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150, // Set your desired height
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
                            // Handle back button press
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                         '$projectName',
                          style: TextStyle(
                            color: Color(0xFF00517C),
                            fontSize: 22,
                            fontFamily: 'Source Sans Pro',
                            fontWeight: FontWeight.w700,
                            height: 0,
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
                  '$selectedPhoto'
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
                    String imageUrl =
                        'https://api.tridhyatech.com/${imageData['PortfolioImage']}';
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPhoto = imageUrl;
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
      ),
    );
  }
}