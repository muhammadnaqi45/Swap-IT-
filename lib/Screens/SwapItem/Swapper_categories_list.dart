import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/SwapItem/Swapper_Subcategory_Display.dart';
import 'package:project/Screens/categories_widget/Subcategory_Display.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:provider/provider.dart';

class Swapper_Categorylist_Display extends StatelessWidget {

  static const String id = 'swapper-CatList-display';


  @override
  Widget build(BuildContext context) {

    FirebaseService _service = FirebaseService();

    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Choose Categories',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.orderBy('catName',descending: false).get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }

            return Container(

              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index){
                  var doc=snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: (){
                        //subCategory
                        _catProvider.getCategory(doc['catName']);
                        _catProvider.getCatSnapshot(doc);
                        if(doc['subCat']==null){
                          return print('No sub category');
                        }
                        Navigator.pushNamed(context,Swapper_SubCatList_Display.id,arguments: doc);

                      },
                      leading: Image.network(doc['image'],width: 40,),
                      title: Text(doc['catName'],style: TextStyle(fontSize: 15),),
                      trailing: Icon(doc['subCat']==null ? null :Icons.arrow_forward_ios,size: 12,),

                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
