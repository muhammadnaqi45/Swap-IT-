import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home_Display.dart';
import 'package:project/Screens/Location_Display.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser(context,uid) async{
    // Call the user's CollectionReference to add a new user
    final QuerySnapshot result=await users.where('uid',isEqualTo:user.uid).get();
    List <DocumentSnapshot> document = result.docs;
    if(document.length>0){
      Navigator.pushReplacementNamed(context, LocationDisplay.id);//if location issue resolve change it to locationid
    }else{
      return users.doc(user.uid)
          .set({
        'uid': user.uid, // user id
        'email': user?.email // user email
      })
          .then((value){
        //after add data in fireabse then go to the next screen
        Navigator.pushReplacementNamed(context,  HomeDisplay.id);
      })
          .catchError((error) => print("Failed to add user: $error"));
    }

  }

}