import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Location_Display.dart';
import 'package:project/provider/Product_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:project/services/search_service.dart';
import 'package:provider/provider.dart';

class AppBar_Custom extends StatefulWidget {


  @override
  State<AppBar_Custom> createState() => _AppBar_CustomState();
}

class _AppBar_CustomState extends State<AppBar_Custom> {
  FirebaseService _service = FirebaseService();
  SearchService _search = SearchService();
  String address ='';
  DocumentSnapshot swapperDetails;
  static List<Products> products = [];

  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((doc) {
        setState(() {
          products.add(
            Products(
              document: doc,
              title:  doc['title'],
              category: doc['category'],
              description: doc['description'],
              subCat: doc['subCat'],
              postedDate: doc['postedAt'],
              price: doc['price'],
            ),
          );
          getSwapperAddress(doc['swapperUid']);
        });
      });
    });
    super.initState();
  }
  getSwapperAddress(swapperid)
  {
    _service.getSwapperData(swapperid).then((value){
      setState(() {
        address = value['address'];
        swapperDetails = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);


    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Address Not Selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          if(data['address']==null){
            GeoPoint latLong = data['location'];
            _service.getAddress(latLong.latitude,latLong.longitude).then((adress){
              return appbar(adress, context,_provider,swapperDetails);
            });

          }else{
            return appbar(data['address'], context,_provider,swapperDetails);
          }

        }

        return appbar('Fetching Location', context,_provider,swapperDetails);
      },
    );
  }

  Widget appbar(address,context,_provider,swapperDetails){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: (){
          Navigator.pushNamed(context,LocationDisplay.id);
        },
        child: Container(
          width:MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8,bottom: 8),
            child: Row(
              children: [
                Icon(CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,),


                Flexible(
                  child: Text(address,style:TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 18,
                ),

              ],
            ),
          ),
        ),
      ),
      bottom:PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: InkWell(
          onTap: (){

          },
          child: Container(
            color:Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12,0,12,8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onTap: (){
                          _search.search(context: context , productList: products,address: address,provider:_provider,swapperDetails:swapperDetails );
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,),
                          labelText: 'Find Mobiles, Cars and many more',
                          labelStyle: TextStyle(fontSize: 12),
                          contentPadding: EdgeInsets.only(left: 10,right: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.notifications_none),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
