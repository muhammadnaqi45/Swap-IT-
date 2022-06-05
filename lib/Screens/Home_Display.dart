import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Buttons/AppBar.dart';
import 'package:project/Buttons/Widget_banner.dart';
import 'package:project/Buttons/category.dart';
import 'package:project/Screens/product_list.dart';
class HomeDisplay extends StatefulWidget {
  static const String id = 'Home-screen';

  @override
  State<HomeDisplay> createState() => _HomeDisplayState();
}

class _HomeDisplayState extends State<HomeDisplay> {
  String address='Pakistan';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
          child: SafeArea(child: AppBar_Custom())),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12,0,12,8),
                child: Column(
                  children: [
                    BannerWidget(),
                    //Categories
                    WidgetCategory(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            //product list
            ProductList(false),
          ],
        ),
      ),
    );
  }
}
