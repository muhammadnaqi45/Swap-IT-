// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:like_button/like_button.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/Product_provider.dart';


//
// class ProductDetailDisplay extends StatefulWidget {
//   static const String id = 'product-detail-display';
//   const ProductDetailDisplay({Key key}) : super(key: key);
//
//   @override
//   State<ProductDetailDisplay> createState() => _ProductDetailDisplayState();
// }
//
// class _ProductDetailDisplayState extends State<ProductDetailDisplay> {
//
//   bool _loading = true;
//   @override
//   void initState() {
//    Timer(Duration(seconds: 3),(){
//      setState(() {
//        _loading=false;
//      });
//    });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _productProvider = Provider.of<ProductProvider>(context);
//     var data = _productProvider.productdata;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         iconTheme: IconThemeData(color: Colors.black),
//         actions: [
//           IconButton(icon: Icon(Icons.share_outlined,color: Colors.black,),
//             onPressed: (){},
//           ),
//           LikeButton(
//             circleColor:
//             CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
//             bubblesColor: BubblesColor(
//               dotPrimaryColor: Color(0xff33b5e5),
//               dotSecondaryColor: Color(0xff0099cc),
//             ),
//             likeBuilder: (bool isLiked) {
//               return Icon(
//                 Icons.favorite,
//                 color: isLiked ? Colors.red : Colors.grey,
//               );
//             },
//           )
//         ],
//       ),
//       body: SafeArea(
//         child:Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 300,
//               color: Colors.grey[300],
//               child: _loading ? Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//                     ),
//                     SizedBox(height: 10,),
//                     Text('Loading your Ads'),
//                   ],
//                 ),) :  Stack(
//                   children: [
//                     Center(
//                       child: PhotoView(
//                         backgroundDecoration: BoxDecoration(color: Colors.grey),
//                       imageProvider: NetworkImage(data['images'][0]),
//               ),
//                     ),
//                     Positioned(
//                       bottom: 0.0,
//                       child: Container(
//                         height: 50,
//                         width: MediaQuery.of(context).size.width,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 14,right: 14),
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                               itemCount: data['images'].length,
//
//                               itemBuilder: (BuildContext context , int i){
//                                 return Container(
//                                 height: 60,width: 60,
//                                 child: Image.network(data['images'][i]),
//
//                                 );
//                               },),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//             ),
//             Container(
//
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }
//
//



import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:map_launcher/map_launcher.dart' as launcher ;
import 'package:photo_view/photo_view.dart';
import 'package:project/Screens/chat/chat_convesation_display.dart';
import 'package:project/provider/Product_provider.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailDisplay extends StatefulWidget {
  static const String id = 'product-deatil-display';

  @override
  State<ProductDetailDisplay> createState() => _ProductDetailDisplayState();
}

class _ProductDetailDisplayState extends State<ProductDetailDisplay> {
  GoogleMapController _controller;
  FirebaseService _service = FirebaseService();
  bool _loading = true;
  int _index = 0;
  var _format = NumberFormat('##,##,##0');
  List fav = [];
  bool _isLiked = false;
  @override
  void initState() {
    Timer(Duration(seconds: 2),(){
      setState(() {
        _loading=false;
      });
    });
    super.initState();
  }
  _mapLauncher(location) async{
    final availableMaps = await launcher.MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: "Swapper Location is here",
    );
  }
  _callSwapper(number){
    launch(number);
  }
  createChatRoom(ProductProvider _provider){
//we need some data to store in firestore
  Map <String , dynamic> product = {
    'productId' : _provider.productdata.id,
    'productImage' : _provider.productdata['images'][0],
    'price' : _provider.productdata['price'],
    'title' : _provider.productdata['title'],
    'swap' : _provider.productdata['swapperUid'],
  };
    List<String> users = [
      _provider.swapperDetails['uid'],
    _service.user.uid
    ];
    String chatRoomId = '${_provider.swapperDetails['uid']}.${_service.user.uid}.${_provider.productdata.id}';
    //now lets create a data to save in firestore
    Map <String , dynamic> chatData = {
      'users':users,
      'chatRoomId':chatRoomId,
      'read':false,
      'product':product,
      'lastChat' : null,
      'lastChatTime':DateTime.now().microsecondsSinceEpoch,
    };

    //now we have all details to save
  _service.createChatRoom(
    chatData: chatData,
  );
  //after create chatroom it should open created chatroom to chat
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatConversation(
      chatRoomId: chatRoomId,
    ),),);
  }
  @override
  void didChangeDependencies() {
    var _productProvider = Provider.of<ProductProvider>(context);
    getFavourites(_productProvider);
    super.didChangeDependencies();
  }

  getFavourites(ProductProvider _productProvider){
    _service.products.doc(_productProvider.productdata.id).get().then((value){
      setState(() {
        fav = value['favourites'];
      });
      if(fav.contains(_service.user.uid))
      {
        setState(() {
          _isLiked=true;
        });
      }else{
        setState(() {
          _isLiked=false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var _productProvider = Provider.of<ProductProvider>(context);
    var data = _productProvider.productdata;
    var _price = int.parse(data['price']);
    String price = _format.format(_price);

    var date = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);
    var _Date = DateFormat.yMMMd().format(date);
    GeoPoint _location = _productProvider.swapperDetails['location'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: Icon(Icons.share_outlined,color: Colors.black,),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(_isLiked?Icons.favorite : Icons.favorite_border),
            color: _isLiked ?Colors.red : Colors.black,
            onPressed: (){
              setState(() {
                _isLiked = !_isLiked;
              });
              _service.updateFavourite(_isLiked, data.id, context);
            },
          ),
        ],
      ),
      body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.only(left: 12,right: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color: Colors.grey[300],
                    child: _loading ?
                    Center(
                       child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),

                        ),
                        SizedBox(height: 10,),
                        Text('Loading your Ad'),
                      ],
                    ),):
                    Stack(
                      children: [
                        Center(
                          child: PhotoView(
                            backgroundDecoration: BoxDecoration(color: Colors.grey[300]),
                            imageProvider: NetworkImage(data['images'][_index]),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                                itemCount: data['images'].length,
                                itemBuilder:(BuildContext context,int i){
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        _index = i;
                                      });
                                    },
                                    child: Container(
                                      height: 60,width: 60,
                                        child: Image.network(data['images'][i]),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:Border.all(color: Theme.of(context).primaryColor
                                        ),
                                      ),
                                    ),
                                  );
                                },),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _loading ? Container() : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data['title'].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                            if(data['category']=='Vehicles')
                              Text('(${(data['Year'])}'),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Text('\Rs $price',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        SizedBox(height: 10,),
                        if(data['subCat']=='Cars')//change kia tha
                          Container(
                            color: Colors.grey[300],
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.filter_alt_outlined,size: 12,),
                                          SizedBox(width: 10,),
                                          Text(data['Fuel'],style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.av_timer_outlined,size: 12,),
                                          SizedBox(width: 10,),
                                          Text(_format.format(int.parse(data['Km'])),style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.account_tree_outlined,size: 12,),
                                          SizedBox(width: 10,),
                                          Text(data['transmissions'],style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceAround ,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(CupertinoIcons.person,size: 12,),
                                            SizedBox(width: 10,),
                                            Text(data['owner'],style: TextStyle(fontSize: 12),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        // Expanded(
                                        //   child: Container(
                                        //     child: AbsorbPointer(
                                        //       absorbing: true ,
                                        //       child: TextButton.icon(onPressed: (){},
                                        //         style: ButtonStyle(alignment: Alignment.center),
                                        //       icon: Icon(Icons.location_on_outlined ),
                                        //         label:Flexible(
                                        //           child: Text(_productProvider.swapperDetails==null? '':_productProvider.swapperDetails['address'],
                                        //           maxLines: 1,
                                        //             style: TextStyle(color: Colors.black),
                                        //           ),
                                        //         ),
                                        //
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('POSTED DATE',style: TextStyle(fontSize: 12),),
                                              Text(_Date,style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],

                              ),
                            ),
                          ),
                        SizedBox(height: 10,),
                        Text('Description', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Row (
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['description']),
                                      SizedBox(height: 10,),
                                      if(data['subCat'] == null || data['subCat']=='SmartPhone')
                                        Text('Brand: ${data['brand']}'),
                                      if(data['subCat'] == 'Accessories'
                                          ||data['subCat']  == 'Tablets')
                                        Text('Type: ${data['type']}')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey,),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 40,
                              child: CircleAvatar(
                                  backgroundColor: Colors.blue[50],
                                  radius: 38,
                                  child:Icon(CupertinoIcons.person_alt,
                                    color:Colors.red[300],
                                    size: 60,
                                  )
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                    _productProvider.swapperDetails['name'] == null? '' :
                                  _productProvider.swapperDetails['name'].toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                subtitle: Text('SEE PROFILE',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                  ),
                                  onPressed: (){},
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(color: Colors.grey,),
                        Text('Ad posted At',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Stack(
                            children: [
                              Center(
                                child:GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(_location.latitude,_location.longitude),
                                    zoom: 15,
                                  ),
                                  mapType: MapType.normal,
                                  onMapCreated: (GoogleMapController controller){
                                    setState(() {
                                      _controller = controller;
                                    });
                                  },
                                ),
                              ),
                              Center(child: Icon(Icons.location_on,size: 35,),),
                              Center(child: CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 60,
                              ),),
                              Positioned(
                                  right: 4.0,
                                  top: 4.0,
                                  child: Material(
                                    elevation: 4,
                                    shape: Border.all(color:Colors.grey.shade300),
                                    child: IconButton(
                                icon:Icon(Icons.alt_route_outlined),
                                onPressed: (){
                                  //launch location in google map app
                                  _mapLauncher(_location);
                                },
                              ),
                                  ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: Text('AD ID,${data['postedAt']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                            ),
                            ),
                            TextButton(
                              onPressed: (){},
                              child: Text('REPORT THIS AD',style: TextStyle(color: Colors.blue),),),
                          ],
                        ),
                        SizedBox(height: 80,)
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
      ),
      bottomSheet: BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _productProvider.productdata['swapperUid']==_service.user.uid ?Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                onPressed: (){

                },
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit,size: 16,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Edit Product',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ) :Row(
          children: [
           Expanded(
              child: NeumorphicButton(
              onPressed: (){
                //now if user want to chat with the swap user
                //he can click on chat button and
                //it will create a chat room in firestore
                createChatRoom(_productProvider);
              },
              style: NeumorphicStyle(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chat_bubble,size: 16,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Chat',style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: NeumorphicButton(
              onPressed: (){
                //call swapper
                _callSwapper('tel:${_productProvider.swapperDetails['mobile']}');
              },
              style: NeumorphicStyle(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.phone,size: 16,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Call',style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
