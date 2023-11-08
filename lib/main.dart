// import 'package:aioaapbardemo/presentation/screen/filter_screen.dart';

import 'package:aioaapbardemo/presentation/screen/filter_screen.dart';
import 'package:aioaapbardemo/presentation/screen/portfoliodeatil.dart';
import 'package:aioaapbardemo/presentation/screen/portfoliolisting.dart';
import 'package:aioaapbardemo/presentation/screen/splash.dart';
import 'package:aioaapbardemo/presentation/screen/syn.dart';
import 'package:flutter/material.dart';

import 'Data/database.dart';
import 'model/model.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initializeDatabaseAndLoadData();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) => SplashScreen(),
        // '/syn':(context) => SynchronizationScreen(),
        '/home': (context) => HomeScreen(), // Task screen route
        // '/details': (context) => DetailsPage(apiData: [], data: Data(),),
        '/details': (context) => DetailsPage(apiData: [], initialPageIndex: 0),
        '/tasks':(context) => FilterPage()// Home screen route
      },
    );
  }
}
