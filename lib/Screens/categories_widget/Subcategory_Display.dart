import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/product_by_category_display.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:provider/provider.dart';

import '../../services/Firebase_service.dart';


class SubCatList_Display extends StatelessWidget {

  static const String id ='subcatlist';


  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    DocumentSnapshot args = ModalRoute.of(context).settings.arguments ;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(args['catName'],style: TextStyle(color: Colors.black,fontSize: 18),),
      ),
      body: Container(
        child:  FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            var data= snapshot.data['subCat'];
            return Container(

              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: ListTile(
                      onTap: (){
                        //subCategory
                        _catProvider.getSubCategory(data[index]);
                        Navigator.pushNamed(context, ProductByCategory.id);
                      },
                      title: Text(data[index],style: TextStyle(fontSize: 15),),
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
