

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/services/Firebase_service.dart';

class CategoryProvider with  ChangeNotifier{
  FirebaseService _service = FirebaseService();

  DocumentSnapshot doc;
  DocumentSnapshot userDetails;
  String selectedCategory;
  String selectedSubCat;
  List<String> urlList = [];//will add all urls to this list
  Map<String,dynamic> dataToFirestore = {}; //this is the data we are going to upload on firestore

  getCategory(selectedCat){
    this.selectedCategory = selectedCat;
    notifyListeners();
  }
  getSubCategory(selectedsubCat){
    this.selectedSubCat = selectedsubCat;
    notifyListeners();
  }

  getCatSnapshot(snapshot){
    this.doc = snapshot;
    notifyListeners();
  }
  getImages(url){
    this.urlList.add(url);
    notifyListeners();
  }
  getData(data){
    this.dataToFirestore = data;
    notifyListeners();
  }
  getUserDetails(){
    _service.getUserData().then((value){
      this.userDetails = value;
      notifyListeners();
    });
  }
  clearData(){
    this.urlList = [];
    dataToFirestore = {};
    notifyListeners();
  }
}