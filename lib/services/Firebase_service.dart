
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:project/Screens/Home_Display.dart';

class FirebaseService {
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  Future<void> updateUser(Map<String,dynamic>data, context) {
    return users
        .doc(user.uid)
        .update(data)
        .then((value) {
      Navigator.pushNamed(context, HomeDisplay.id);
    },)
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Location'),
        ),
      );
    });
  }

  Future<String>getAddress(lat,long)async{
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
return first.addressLine;
  }

  Future<DocumentSnapshot>getUserData() async{
    DocumentSnapshot doc = await users.doc(user.uid).get();
    return doc;
  }
  Future<DocumentSnapshot>getSwapperData(id) async{
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }
  Future<DocumentSnapshot>getProductDetails(id) async{
    DocumentSnapshot doc = await products.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}){
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e){
      print(e.toString());
    });
  }
  createChat(String chatRoomId,message) {
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e) {
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'read' : false

    });
  }
  getChat(chatRoomId)async{
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }
  deleteChat(chatRoomId)async{
    return messages.doc(chatRoomId).delete();
  }
  updateFavourite(_isLiked,productId,context){
    if(_isLiked){
       products.doc(productId).update({
        'favourites' : FieldValue.arrayUnion([user.uid])
      });
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
             content: Text('Added to my Favourite'),
         ),
       );
    }else{
      return products.doc(productId).update({
      'favourites' : FieldValue.arrayRemove([user.uid])
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Remove From  Favourite'),
      ),
    );
  }

}