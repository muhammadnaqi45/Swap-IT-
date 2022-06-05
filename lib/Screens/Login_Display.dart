
import 'package:flutter/material.dart';
import 'package:project/Buttons/sociallinks.dart';
class LoginDisplay extends StatelessWidget {
  static const String id = 'login-screen';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Column(
        children: [
          Expanded(
            child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 50,),
                Image.asset('assets/images/Splash Display.jpeg',
                    ),
                SizedBox(height: 10,),
                Text("SWAP-IT",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.grey[600],
                ),)
              ],
            ),
          ),),
          Expanded(child: Container(
            child: social_links(),
          ),
          ),
          Padding(
            padding:EdgeInsets.all(2.0),
            child: Text(
              "If you continue, you are accepting\nTerms and conditions and Privacy Policy",
              textAlign: TextAlign.center,style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            ),
          )
        ],
      ),
    );
  }
}
