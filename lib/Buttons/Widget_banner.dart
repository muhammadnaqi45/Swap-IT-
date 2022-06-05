import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';


class BannerWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Neumorphic(

      child: Container(

        width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*.25,
          color: Colors.cyan,
          child: Padding(

            padding: const EdgeInsets.all(10.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(

                  padding: const EdgeInsets.all(10),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text('Products',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 18,
                          ),
                          ),
                          SizedBox(height: 20,),
                  SizedBox(
                    height: 45.0,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          FadeAnimatedText('Reach 10 Lakh+\nInterested Trader',
                          duration: Duration(seconds: 4),
                          ),
                          FadeAnimatedText('New Way to\nSwap Products',
                            duration: Duration(seconds: 4),
                          ),
                          FadeAnimatedText('Over 1 Lakh\nProducts to Swap',
                            duration: Duration(seconds: 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                        ],
                      ),
                      Neumorphic(

                        style: NeumorphicStyle(
                          color: Colors.white,
                          oppositeShadowLightSource: true,
                        ),
                        child: Image.network('https://firebasestorage.googleapis.com/v0/b/project-2bd59.appspot.com/o/banner%2Ficons8-product-100.png?alt=media&token=3d4e4e91-d555-469e-8b92-8e03d98c64aa'),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                   children: [
                     Expanded(child: NeumorphicButton(
                       onPressed: (){},
                       style: NeumorphicStyle(color: Colors.white),
                       child: Text('Swap Products',textAlign: TextAlign.center,),
                     ),),
                   ],
                ),
              ],
            ),
          ),
      ),
    );
  }
}
