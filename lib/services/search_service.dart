import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Product_Details_Display.dart';
import 'package:project/Screens/product_list.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';
class Products {
  final String title, description,category,subCat,price;
  final num postedDate;
  final DocumentSnapshot document;
  Products({
    this.title,
    this.description,
    this.category,
    this.subCat,
    this.price,
    this.postedDate,
    this.document,
  });
}

class SearchService{
search({context,productList,address,provider,swapperDetails}){
  showSearch(
    context: context,
    delegate: SearchPage<Products>(
      onQueryUpdate: (s) => print(s),
      items: productList,
      searchLabel: 'Search product',
      suggestion: SingleChildScrollView(child: ProductList(true)),
      failure: Center(
        child: Text('No product found :('),
      ),
      filter: (product) => [
        product.title,
        product.description,
        product.subCat,
        product.category,
      ],
      builder: (product)
      {
        final _format = NumberFormat('##,##,##0');
        var _price = int.parse(product.price);
         String _formattedPrice = '\Rs ${_format.format(_price)}';
        var date = DateTime.fromMicrosecondsSinceEpoch(product.postedDate);
          var _Date = DateFormat.yMMMd().format(date);
        return InkWell(
          onTap: (){
            provider.getProductDetails(product.document);
            provider.getSwapperDetails(swapperDetails);
              Navigator.pushNamed(context, ProductDetailDisplay.id);
          },
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 100,
                      child: Image.network(product.document['images'][0]),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_formattedPrice,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            Text(product.title),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Posted At : $_Date'),
                            Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                              Icon(Icons.location_on,size: 14,color: Colors.black38,),
                              Flexible(
                               child: Container(
                                 width: MediaQuery.of(context).size.width-148,
                                  child: Text(address,overflow: TextOverflow.ellipsis,),
                                  ),
                               )
                              ],
                             ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
}
// final _format = NumberFormat('##,##,##0');
// var _price = int.parse(product.price);
// String _formattedPrice = '\Rs ${_format.format(_price)}';
// var date = DateTime.fromMicrosecondsSinceEpoch(product.postedDate);
// var _Date = DateFormat.yMMMd().format(date);
// return InkWell(
// onTap: (){
// provider.getProductDetails(product.document);
// provider.getSwapperDetails(swapperDetails);
// Navigator.pushNamed(context, ProductDetailDisplay.id);
// },
// child: Container(
// height : 120,
// width : MediaQuery.of(context).size.width,
// child:Card(
// elevation: 4,
// child: Padding(
// padding: const EdgeInsets.all(8),
// child: Row(
// children: [
// Container(
// height: 100,
// width: 120,
// child: Image.network(product.document['images'][0]),
// ),
// SizedBox(width: 10,),
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(_formattedPrice,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
// Text(product.title),
// ],
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('Posted at : $_Date'),
// Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(Icons.location_on,size: 14,color: Colors.black38,),
// Flexible(
// child: Container(
// width: MediaQuery.of(context).size.width-148,
// child: Text(address,overflow: TextOverflow.ellipsis,),
// ),
// )
// ],
// )
// ],
// )
// ],
// )
// ],
// ),
// ),
// )
// ),
// );