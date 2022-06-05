import 'package:flutter/material.dart';
import 'package:project/Screens/Login_Display.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),

          ProfileMenu(
            text: "Log Out",
            icon:"assets/icons/Logout.svg",
            press: () {
              Navigator.pushReplacementNamed(context, LoginDisplay.id);
            },
          ),
        ],
      ),
    );
  }
}