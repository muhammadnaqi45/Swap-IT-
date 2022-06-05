import 'package:flutter/material.dart';
import 'package:project/Screens/product_list.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:provider/provider.dart';


class ProductByCategory extends StatelessWidget {
  static const String id = 'product-by-category';
  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedSubCat == null ? '' :
          '${_catProvider.selectedCategory} > ${_catProvider.selectedSubCat}',
        style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(child: ProductList(true)),
    );
  }
}
