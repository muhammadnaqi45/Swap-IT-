// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'package:intl/intl.dart';
// import 'package:like_button/like_button.dart';
// import 'package:project/Screens/Product_Details_Display.dart';
// import 'package:project/provider/Product_provider.dart';
// import 'package:project/services/Firebase_service.dart';
// import 'package:provider/provider.dart';
// class ProductCard extends StatefulWidget {
//   const ProductCard({
//     Key key,
//     @required this.data,
//     @required String formattedPrice,
//   }) : _formattedPrice = formattedPrice, super(key: key);
//
//   final QueryDocumentSnapshot<Object> data;
//   final String _formattedPrice;
//
//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   FirebaseService _service = FirebaseService();
//
//   final _format = NumberFormat('##,##,##0');
//
//   String address='';
//
//   String _kmFormatted(km){
//     var _km = int.parse(km);
//     var _formattedKm = _format.format(_km);
//     return _formattedKm;
//   }
//
//   @override
//   void initState() {
//     _service.getSwapperData(widget.data['swapperUid']).then((value){
//       if(mounted){
//         setState(() {
//           address = value['address'];
//         });
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<ProductProvider>(context);
//     return InkWell(
//       onTap: (){
//         _provider.getProductDetails(widget.data);
//          Navigator.pushNamed(context, ProductDetailDisplay.id);
//       },
//       child: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 100,
//                     child: Center(
//                       child: Image.network(widget.data['images'][0]),
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Text(widget._formattedPrice,style: TextStyle(fontWeight: FontWeight.bold),),
//                   Text(widget.data['title'],maxLines: 1,overflow: TextOverflow.ellipsis,),
//                   widget.data['category']=='Vehicles' ?
//                   Text('${widget.data['Year']}') : Text(''),
//                   SizedBox(height: 10,),
//                   Row(
//                     children: [
//                       Icon(Icons.location_pin,size:14,color: Colors.black,),
//                       Flexible(child: Text(address,maxLines: 1,overflow: TextOverflow.ellipsis,),),
//                     ],
//                   ),
//                 ],
//               ),
//               Positioned(
//                   right: 0.0,
//                 child : CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Center(
//                     child: LikeButton(
//                       circleColor:
//                       CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
//                       bubblesColor: BubblesColor(
//                         dotPrimaryColor: Color(0xff33b5e5),
//                         dotSecondaryColor: Color(0xff0099cc),
//                       ),
//                       likeBuilder: (bool isLiked) {
//                         return Icon(
//                           Icons.favorite,
//                           color: isLiked ? Colors.red : Colors.grey,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         decoration: BoxDecoration(
//             border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.8),
//             ),
//             borderRadius: BorderRadius.circular(4)
//         ),
//       ),
//     );
//   }
// }
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/Screens/Product_Details_Display.dart';
import 'package:project/provider/Product_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class ProductCard extends StatefulWidget {
  const ProductCard({
    Key key,
    @required this.data,
    @required String formattedPrice,
  }) : _formattedPrice = formattedPrice, super(key: key);

  final QueryDocumentSnapshot<Object> data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double _ratingValue;
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,###');
  String address ='';
  DocumentSnapshot swapperDetails;
  List fav = [];
  bool _isLiked = false;


  String _kmFormatted(Km){
    var _km = int.parse(Km);
    var _formattedkm = _format.format(_km);
    return _formattedkm;
  }
  @override
  void initState(){
    getSwapperData();
    getFavourites();
    super.initState();
  }
  getSwapperData(){
    _service.getSwapperData(widget.data['swapperUid']).then((value){
      if(mounted){
        setState(() {
          address = value['address'];
          swapperDetails = value;
        });
      }
    });
  }
  getFavourites(){
    _service.products.doc(widget.data.id).get().then((value){
      if(mounted){
        setState(() {
          fav = value['favourites'];
        });
      }
      if(fav.contains(_service.user.uid))
      {
        if(mounted){
          setState(() {
            _isLiked=true;
          });
        }
      }else{
       if(mounted){
         setState(() {
           _isLiked=false;
         });
       }
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return InkWell(
      onTap: (){
        _provider.getProductDetails(widget.data);
        _provider.getSwapperDetails(swapperDetails);
        Navigator.pushNamed(context, ProductDetailDisplay.id);

      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Center(child: Image.network(widget.data['images'][0]),),
                  ),
                  SizedBox(height: 10,),
                  //price
                  Text(widget._formattedPrice,style: TextStyle(fontWeight: FontWeight.bold),),
                Text(widget.data['title'],maxLines: 1,overflow: TextOverflow.ellipsis,),
                widget.data['category']=='Vehicles' ?
                Text('${widget.data['Year']}') : Text(''),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.location_pin, size:14,color: Colors.black,),
                      Flexible(child: Text(address,maxLines: 1,overflow: TextOverflow.ellipsis,),),
                    ],
                  ),
                  Row(
                    children: [
                      RatingBar(
                          initialRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 28,
                          ratingWidget: RatingWidget(
                              full: const Icon(Icons.star, color: Colors.lightBlue,),
                              half: const Icon(
                                Icons.star_half,
                                color: Colors.lightBlue,
                              ),
                              empty: const Icon(
                                Icons.star_outline,
                                color: Colors.orange,

                              ),

                          ),
                          onRatingUpdate: (value) {
                            setState(() {
                              _ratingValue = value;
                            });
                          })
                    ],
                  )
                ],
              ),
              //Will work this in an another video
              Positioned(
                  right: 0.0,
                child : IconButton(
                  icon: Icon(_isLiked?Icons.favorite : Icons.favorite_border),
                   color: _isLiked ?Colors.red : Colors.black,
                  onPressed: (){
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                    _service.updateFavourite(_isLiked, widget.data.id, context);
                  },
                ),
                  ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(4),
        ),

      ),
    );
  }
}