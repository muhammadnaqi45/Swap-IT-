import 'package:flutter/material.dart';
import 'package:project/AccountScreen_Components/main_body.dart';


class ProfileScreen extends StatelessWidget {
  static const String id = 'profile-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account",style:TextStyle(color: Colors.black) ,),
        backgroundColor: Colors.white,
      ),
      body: Body(),
    );
  }
}