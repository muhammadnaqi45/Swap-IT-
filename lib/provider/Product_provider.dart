

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier{
  DocumentSnapshot productdata;
  DocumentSnapshot swapperDetails;
  getProductDetails(details){
    this.productdata = details;
    notifyListeners();
  }

  getSwapperDetails(details){
    this.swapperDetails= details;
    notifyListeners();

  }
}