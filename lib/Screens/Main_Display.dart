import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Account_Display.dart';
import 'package:project/Screens/chat/Chat_Display.dart';
import 'package:project/Screens/Home_Display.dart';
import 'package:project/Screens/MyAds_Display.dart';
import 'package:project/Screens/SwapItem/Swapper_categories_list.dart';


class Main_Display extends StatefulWidget {
  static const String id='main-display';

  @override
  State<Main_Display> createState() => _Main_DisplayState();
}

class _Main_DisplayState extends State<Main_Display> {

  Widget _currentScreen = HomeDisplay();//this is first screen when app open
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {

    Color colors = Theme.of(context).primaryColor;

    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //this button is to make add products for swapper
          //so it will open first category display is select the screen where item belong to
          Navigator.pushNamed(context, Swapper_Categorylist_Display.id);
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          height: 60,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //leftside of floating button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        _index=0;
                        _currentScreen=HomeDisplay();
                      });
                    },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(_index==0 ? Icons.home : Icons.home_outlined),
                      Text('HOME',
                        style: TextStyle(
                            color: _index==0 ? colors: Colors.black,
                          fontWeight: _index == 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),

                      ),
                    ],
                  ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        _index=1;
                        _currentScreen=ChatDisplay();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(_index==1 ? CupertinoIcons.chat_bubble_fill : CupertinoIcons.chat_bubble),
                        Text('CHATS',
                          style: TextStyle(
                              color: _index==1 ? colors: Colors.black,
                              fontWeight: _index == 1 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //right side of floating button
              Row(
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        _index=2;
                        _currentScreen=MyAdsDisplay();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(_index==2 ? CupertinoIcons.heart_fill : CupertinoIcons.heart),
                        Text('My Ads',
                          style: TextStyle(
                            color: _index==2 ? colors: Colors.black,
                            fontWeight: _index == 2 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),

                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        _index=3;
                        _currentScreen=ProfileScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(_index==3 ? CupertinoIcons.person_fill : CupertinoIcons.person),
                        Text('Account',
                          style: TextStyle(
                            color: _index==3 ? colors: Colors.black,
                            fontWeight: _index == 3 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
