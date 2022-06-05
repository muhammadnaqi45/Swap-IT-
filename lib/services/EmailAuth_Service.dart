


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home_Display.dart';
import 'package:project/Screens/Location_Display.dart';
import 'package:project/Screens/authentication/Email_verify_Display.dart';

class EmailAuthentication{
  CollectionReference users=FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot<Object>>getAdminCredential(
  {email,password,isLog,context})async{
    DocumentSnapshot<Object> _result = await users.doc(email).get();
    if(isLog){
      //direct Login
      emailLogin(email,password,context);
    }else{
      //if register
      if(_result.exists){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'An Acount Already exist with this account',
          ),),
        );
      }else{
        //register as new user
        emailRegister(email,password,context);
      }
    }
    return _result;
  }
  emailLogin(email,password,context)async{
//Login with Already register Account
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user?.uid!=null){
        Navigator.pushReplacementNamed(context, LocationDisplay.id);//if location issue resolve change it to locationid
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'No user found for that email.',
          ),),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Wrong password provided for that user.',
          ),),
        );
      }
    }
  }
  emailRegister(email,password,context)async{
    //Register a new user
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user.uid!=null){
        return users.doc(userCredential.user.uid).set({//this small part change
          'uid' : userCredential.user.uid,
          'email' : userCredential.user.email,
          'name' : null,
          'mobile' : null,
          'address' : null,
        }).then((value)async{
            await userCredential.user.sendEmailVerification().then((value){
              Navigator.pushReplacementNamed(context, EmailVerificationDisplay.id);
            });

        }).catchError((onError){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
              'Failed to add user',
            ),
            ),
          );
          });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'The password provided is too weak.',
          ),),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'The account already exists for that email.',
          ),),
        );

      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'Error Occured',
        ),),
      );
    }
  }
}