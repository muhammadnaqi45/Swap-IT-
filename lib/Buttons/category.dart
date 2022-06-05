import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/categories_widget/Subcategory_Display.dart';
import 'package:project/Screens/categories_widget/categories_list.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:provider/provider.dart';

class WidgetCategory extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.orderBy('catName',descending: false).get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 150,
              child: Column(
                children: [
                  Row(

                    children: [
                      Expanded(child: Text('Categories')),
                      TextButton(onPressed: (){
                        //show complete list of categories
                        Navigator.pushNamed(context, Categorylist_Display.id);
                      },
                        child: Row(
                          children: [
                            Text(
                              'See all',
                              style: TextStyle(
                                  color: Colors.black),
                            ),
                            Icon(Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(

                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index){
                        var doc=snapshot.data.docs[index];
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: InkWell(
                           onTap: (){
                             //subCategory
                             _catProvider.getCategory(doc['catName']);
                             _catProvider.getCatSnapshot(doc);
                             if(doc['subCat']==null){
                               return print('No sub category');
                             }
                             Navigator.pushNamed(context,SubCatList_Display.id,arguments: doc);
                           },
                           child: Container(
                             width: 60,
                             height: 50,
                             child: Column(
                               children: [
                                 Image.network(doc['image']),
                                 Flexible(
                                   child: Text(doc['catName'].toUpperCase(),
                                   maxLines: 2,
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                   fontSize: 12
                                   ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       );
                    },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
