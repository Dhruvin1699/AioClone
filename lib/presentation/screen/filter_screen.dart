// import 'package:flutter/material.dart';
//
// class FilterPage extends StatefulWidget {
//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }
//
// class _FilterPageState extends State<FilterPage> {
//   List<bool> horizontalCheckboxValues = [false, false];
//   List<bool> verticalCheckboxValues = [false, false, false, false, false, false];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             height: 135,
//             padding: EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(0.00, -1.00),
//                 end: Alignment(0, 1),
//                 colors: [Color(0xFFDEF8FF), Colors.white.withOpacity(0.9200000166893005)],
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
//                         icon: Container(width: 10, child: Icon(Icons.arrow_back_ios)),
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
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text('Text 1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                         Text('Text 2', style: TextStyle(fontSize: 14, color: Colors.grey)),
//                       ],
//                     ),
//                     Spacer(),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Checkbox(
//                                 value: horizontalCheckboxValues[0],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     horizontalCheckboxValues[0] = value ?? false;
//                                   });
//                                 },
//                               ),
//                               Checkbox(
//                                 value: horizontalCheckboxValues[1],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     horizontalCheckboxValues[1] = value ?? false;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Column(
//                             children: <Widget>[
//                               for (int i = 0; i < 6; i++)
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: <Widget>[
//                                     Text('Filter Text ${i + 1}'),
//                                     Checkbox(
//                                       value: verticalCheckboxValues[i],
//                                       onChanged: (value) {
//                                         setState(() {
//                                           verticalCheckboxValues[i] = value ?? false;
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<bool> horizontalCheckboxValues = [false, false];
  List<bool> verticalCheckboxValues = [false, false, false, false, false, false, false, false, false, false];
  List<String> checkboxTexts = [
    'Filter Text 1',
    'Filter Text 2',
    'Filter Text 3',
    'Filter Text 4',
    'Filter Text 5',
    'Filter Text 6',
    'Filter Text 7',
    'Filter Text 8',
    'Filter Text 9',
    'Filter Text 10',
  ];

  List<bool> checkboxValues = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 135,
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
                        'Filter',
                        style: TextStyle(
                          color: Color(0xFF00517C),
                          fontSize: 22,
                          fontFamily: 'Source Sans Pro',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      // Spacer(),
                    ],
                  ),
                ),
    ]),),
                SizedBox(height: 20,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      children: <Widget>[
                        // Left Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Domains/industries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 40,),
                            Text('Technology/Tech Stack', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                          ],
                        ),

                        // Spacer between left and right content
SizedBox(width: 40,),

                        // Right Content
                        Expanded(
                          child: Column(
                            children: List.generate(
                              10,
                                  (index) => Container(
                                    width: 410,
                                height: 50,
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.only(left: 0,right:0,top: 5,bottom: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey), // Add border to container
                                  borderRadius: BorderRadius.circular(5), // Optional: for rounded corners
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width:30,
                                      child: Checkbox(
                                        value: checkboxValues[index],
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValues[index] = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 115.0),
                                      child: Container(
                                        width: 60,
                                         margin: EdgeInsets.all(1),
                                        child: Text(checkboxTexts[index]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                    ],
                  ),
                );






  }
}
