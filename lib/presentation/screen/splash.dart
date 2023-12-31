import 'package:aioaapbardemo/presentation/screen/portfoliolisting.dart';
import 'package:aioaapbardemo/presentation/screen/syn.dart';
import 'package:flutter/material.dart';




class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Duration splashDuration = Duration(seconds: 3);

    Future.delayed(splashDuration, () {
      // After the delay, navigate to the next screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          // Replace 'NextScreen' with the screen you want to navigate to.
          return SynchronizationScreen();
        }),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Set the background to transparent
      body: Stack(
        children: [

          Container(
            color:Colors.white38,
            child: Center(
              child: Image.asset(
                'images/Group 29.png', // Replace with the path to your image asset
                width: 300, // Set the image width
                height: 200, // Set the image height
              ),
            ),
          ),


        ],
      ),
    );
  }
}
