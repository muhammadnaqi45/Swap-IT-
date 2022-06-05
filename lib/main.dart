import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Product_Forms/Forms_Display.dart';
import 'package:project/Product_Forms/User_review_Display.dart';
import 'package:project/Screens/Account_Display.dart';
import 'package:project/Screens/Bargening_Display.dart';
import 'package:project/Screens/Home_Display.dart';
import 'package:project/Screens/Location_Display.dart';
import 'package:project/Screens/Login_Display.dart';
import 'package:project/Screens/Main_Display.dart';
import 'package:project/Screens/Product_Details_Display.dart';
import 'package:project/Screens/Splash_Display.dart';
import 'package:project/Screens/SwapItem/Swapper_Subcategory_Display.dart';
import 'package:project/Screens/SwapItem/Swapper_categories_list.dart';
import 'package:project/Screens/product_by_category_display.dart';
import 'package:project/Screens/authentication/Email_auth.dart';
import 'package:project/Screens/authentication/Email_verify_Display.dart';
import 'package:project/Screens/authentication/reset_password.dart';
import 'package:project/Screens/categories_widget/Subcategory_Display.dart';
import 'package:project/Screens/categories_widget/categories_list.dart';
import 'package:project/provider/Product_provider.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType=null;
  runApp(MultiProvider(
    providers: [
      Provider (create: (_) => CategoryProvider()),
      Provider (create: (_) => ProductProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var _locationData;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.cyan[800],
        ),
        initialRoute: SplashDisplay.id,
        routes: {
          SplashDisplay.id:(context)=>SplashDisplay(),
        LoginDisplay.id:(context)=>LoginDisplay(),
          LocationDisplay.id:(context)=>LocationDisplay(),
          HomeDisplay.id:(context)=>HomeDisplay(),
          EmailAuthDisplay.id:(context)=>EmailAuthDisplay(),
          EmailVerificationDisplay.id:(context)=>EmailVerificationDisplay(),
          PasswordReset.id:(context)=>PasswordReset(),
          Categorylist_Display.id:(context)=>Categorylist_Display(),
          SubCatList_Display.id:(context)=>SubCatList_Display(),
          Main_Display.id:(context)=>Main_Display(),
          Swapper_Categorylist_Display.id:(context)=>Swapper_Categorylist_Display(),
          Swapper_SubCatList_Display.id:(context)=>Swapper_SubCatList_Display(),
          FormsDisplay.id:(context)=>FormsDisplay(),
          UserReviewDisplay.id:(context)=>UserReviewDisplay(),
          ProductDetailDisplay.id:(context)=>ProductDetailDisplay(),
          ProductByCategory.id:(context)=>ProductByCategory(),
          ProfileScreen.id:(context)=>ProfileScreen(),
          BargainingScreen.id:(context)=>BargainingScreen(),
        },
    );
  }
}

