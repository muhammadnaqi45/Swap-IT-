import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:project/Screens/authentication/Email_auth.dart';
import 'package:project/Screens/authentication/Email_verify_Display.dart';
import 'package:project/services/auth_services.dart';

import '../Screens/authentication/google_auth.dart';

class social_links extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SignInButton(
            Buttons.Google,
            text:("Continue with google"),
            onPressed: () async{
              User user = await GoogleAuthentication.signInWithGoogle(context: context);
              if(user!=null){
                AuthServices _authentication = AuthServices();
                _authentication.addUser(context,user.uid);
              }
            },
          ),
          SignInButton(
            Buttons.FacebookNew,
            text:("Continue with facebook"),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("OR",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, EmailAuthDisplay.id);
              //before add new user , lets design verification screen
              // Navigator.pushNamed(context, EmailVerificationDisplay.id);
            },
            child: Container(
              child: Text(
                'Login with Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(bottom:BorderSide(color: Colors.white)
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
