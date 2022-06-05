import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/Buttons/product_card.dart';
import 'package:project/Screens/Main_Display.dart';
import 'package:project/Screens/SwapItem/Swapper_categories_list.dart';
import '../services/Firebase_service.dart';

class MyAdsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,###');
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(
              'My Ads',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelStyle: TextStyle(fontWeight: FontWeight.normal),
              indicatorWeight: 6,
              tabs: [
                Tab(
                  child: Text(
                    'ADS',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'FAVOURITE',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: FutureBuilder<QuerySnapshot>(
                    future: _service.products
                        .where('swapperUid', isEqualTo: _service.user.uid)
                        .orderBy('postedAt')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 140, right: 140),
                          child: Center(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              backgroundColor: Colors.grey[100],
                            ),
                          ),
                        );
                      }
                      if (snapshot.data.docs.length == 0) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('No Ads Swaping yet'),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Swapper_Categorylist_Display.id);
                                },
                                child: Text('Swap Product'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'My Ads',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2 / 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: snapshot.data.size,
                              itemBuilder: (BuildContext context, int i) {
                                var data = snapshot.data.docs[i];
                                var _price = int.parse(data[
                                    'price']); //convert to int bcz in firestore it is string
                                String _formattedPrice =
                                    '\₨ ${_format.format(_price)}';
                                return ProductCard(
                                    data: data,
                                    formattedPrice: _formattedPrice);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _service.products
                        .where('favourites', arrayContains: _service.user.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 140, right: 140),
                          child: Center(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              backgroundColor: Colors.grey[100],
                            ),
                          ),
                        );
                      }
                      if (snapshot.data.docs.length == 0) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('No Ads Favourite yet'),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context,Main_Display.id);
                                },
                                child: Text('Add Favourite'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'My Ads',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2 / 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: snapshot.data.size,
                              itemBuilder: (BuildContext context, int i) {
                                var data = snapshot.data.docs[i];
                                var _price = int.parse(data[
                                'price']); //convert to int bcz in firestore it is string
                                String _formattedPrice =
                                    '\₨ ${_format.format(_price)}';
                                return ProductCard(
                                    data: data,
                                    formattedPrice: _formattedPrice);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
