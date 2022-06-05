import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home_Display.dart';
import 'package:project/Screens/Location_Display.dart';
import 'package:project/Screens/Login_Display.dart';
class SplashDisplay extends StatefulWidget {
  static const String id = 'Splash-screen';


  @override
  State<SplashDisplay> createState() => _SplashDisplayState();
}

class _SplashDisplayState extends State<SplashDisplay> {
  @override
  void initState() {
    Timer(
      Duration(
        seconds: 4,
      ), (){
        FirebaseAuth.instance.authStateChanges().listen((User user) {
          if (user==null){
           return Navigator.pushReplacementNamed(context, LoginDisplay.id);
          }else{
          return Navigator.pushReplacementNamed(context, LoginDisplay.id);//location change
          }
        });
    }

    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    const colorizeColors = [
      Colors.grey,
      Colors.grey,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 30.0,
      fontFamily: 'Horizon',
    );
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:<Widget> [
            Image.asset('assets/images/Splashdisplay.jpeg',
            ),
            SizedBox(height: 10,),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'SWAP-IT',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),
          ],
        ),
      ),
    );
  }
}
