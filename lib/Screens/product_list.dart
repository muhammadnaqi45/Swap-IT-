import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Buttons/product_card.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class ProductList extends StatelessWidget {
  final bool proScreen;
  ProductList(this.proScreen);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    final _format = NumberFormat('##,##,##0');

    String _kmFormatted(km){
      var _km = int.parse(km);
      var _formattedKm = _format.format(_km);
      return _formattedKm;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12,8,12,8),
        child: FutureBuilder<QuerySnapshot>(
          future: _service.products.orderBy('postedAt').where('subCat',isEqualTo:_catProvider.selectedSubCat).get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140,right: 140),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey[100],
                ),
              );
            }
            if(snapshot.data.docs.length==0){
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                child: Text('No Product added\nunder this category',textAlign: TextAlign.center,),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(proScreen==false)
                Container(
                  height: 56,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Fresh Recommendations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2/3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.size,
                    itemBuilder: (BuildContext context , int i){
                      var data = snapshot.data.docs[i];
                      var _price = int.parse(data['price']);
                      String _formattedPrice = '\Rs ${_format.format(_price)}';
                      return ProductCard(data: data, formattedPrice: _formattedPrice);
                    },
                ),
              ],
            );
          },
        ),
      ),

    );
  }
}





// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:project/Buttons/product_card.dart';
// import 'package:project/services/Firebase_service.dart';
// class ProductList extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     FirebaseService _service = FirebaseService();
//     final _format = NumberFormat('##,##,###');
//
//     String _kmFormatted(Km){
//       var _km = int.parse(Km);
//       var _formattedkm = _format.format(_km);
//       return _formattedkm;
//     }
//
//
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       color:Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(12,8,12,8),
//         child: FutureBuilder<QuerySnapshot>(
//           future: _service.products.orderBy('postedAt').get(),
//           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Padding(
//                   padding: const EdgeInsets.only(left: 140,right: 140),
//                   child: LinearProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//                     backgroundColor: Colors.grey[100],
//                   ),
//                 );
//               }
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     height: 56,
//                     child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Fresh Recommendations',style: TextStyle(fontWeight: FontWeight.bold),),
//                 ),),
//                  GridView.builder(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 200,
//                     childAspectRatio: 2/2.6,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 10
//                   ),
//                   itemCount: snapshot.data.size,
//                   itemBuilder:(BuildContext context , int i){
//                     var data = snapshot.data.docs[i];
//                     var _price = int.parse(data['price']);
//                     String _formattedPrice = '\₨ ${_format.format(_price)}';
//                     return ProductCard(data: data, formattedPrice: _formattedPrice);
//                   },
//                  ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
