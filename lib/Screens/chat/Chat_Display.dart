import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Main_Display.dart';
import 'package:project/Screens/SwapItem/Swapper_categories_list.dart';
import 'package:project/Screens/chat/chatCard.dart';
import 'package:project/services/Firebase_service.dart';

class ChatDisplay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    FirebaseService _service = FirebaseService();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text('Chat',style: TextStyle(color: Colors.black),),
          bottom: TabBar(
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            labelColor: Colors.grey[800],
            indicatorWeight: 6,
            indicatorColor: Colors.grey,
            tabs: [
              Tab(text: 'All',),
              Tab(text: 'Swap',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages.where('users',arrayContains: _service.user.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),

                    ),);
                  }

                  if(snapshot.data.docs.length==0){
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No Chat Started yet'),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.pushNamed(context, Main_Display.id);
                            },
                            child: Text('Contact Swapper'),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data();
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages.where('users',arrayContains: _service.user.uid).where('product.swap',isNotEqualTo:_service.user.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),

                    ),);
                  }

                  if(snapshot.data.docs.length==0){
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No Ads Swaping yet'),
                          SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pushNamed(context, Swapper_Categorylist_Display.id);

                              },
                              child: Text('Swap Product'),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data();
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
