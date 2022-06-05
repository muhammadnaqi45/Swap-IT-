// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:project/services/Firebase_service.dart';
// import 'package:intl/intl.dart';
//
// class BargainingScreen extends StatefulWidget {
//   static const String id = 'bargining-screen';
//   @override
//   State<BargainingScreen> createState() => _BargainingScreenState();
// }
//
// class _BargainingScreenState extends State<BargainingScreen> {
//   FirebaseService _service = FirebaseService();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Negiate the price'),
//       ),
//     //   body: StreamBuilder(
//     // stream: FirebaseFirestore.instance.collection('products').snapshots(),
//     // builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     //              if (!snapshot.hasData) {
//     //                  return Center(
//     //                 child: CircularProgressIndicator(),
//     //              );
//     // }
//     //              return ListView(
//     // children: snapshot.data.docs.map((document) {
//     //   return new Column(
//     //     children: <Widget>[
//     //
//     //       Card(child: ListTile(
//     //
//     //
//     //         title: Text(document['price']??"-",),
//     //
//     //
//     //       )),
//     //     ],);
//     // }).toList(),
//     //    );
//     // },
//     //   ),
//      body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Current Fare",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 30,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SizedBox(
//                       height: 50,
//                       width: 80,
//                       child: OutlinedButton(
//                         child: Center(
//                           child: Text(
//                             '-500',
//                             style: TextStyle(
//                                 fontSize: 18.0, fontWeight: FontWeight.w400),
//                           ),
//                         ),
//
//                         onPressed: () {},
//                       ),
//                     ),
//                     Text(
//                       "20000",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                       width: 80,
//                       child: OutlinedButton(
//                         child: Center(
//                           child: Text(
//                             '+500',
//                             style: TextStyle(
//                                 fontSize: 18.0, fontWeight: FontWeight.w400),
//                           ),
//                         ),
//
//                         onPressed: () {},
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30,),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Colors.grey,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//                     textColor: Colors.white,
//                     child: Text(
//                       "Done",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                     ),),),
//               ]
//           )
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/services/Firebase_service.dart';

class BargainingScreen extends StatefulWidget {
  static const String id = 'bargining-screen';
  @override
  State<BargainingScreen> createState() => _BargainingScreenState();
}

class _BargainingScreenState extends State<BargainingScreen> {
  int negoiatePrice;
  String chatId;
  List<dynamic> args;
  FirebaseService _service = FirebaseService();
  DocumentSnapshot chatDoc;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      args = ModalRoute.of(context).settings.arguments;
      print(args);
      negoiatePrice = int.parse(args[0]);
      chatId = args[1];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(negoiatePrice.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Negiate the price'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Current Fare",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  width: 80,
                  child: OutlinedButton(
                    child: Center(
                      child: Text(
                        '-500',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (negoiatePrice > 500) {
                          negoiatePrice = negoiatePrice - 500;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Price must be greater than or equal to 500',
                              ),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ),
                Text(
                  negoiatePrice.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 80,
                  child: OutlinedButton(
                    child: Center(
                      child: Text(
                        '+500',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (negoiatePrice > 0) {
                          negoiatePrice = negoiatePrice + 500;
                        }
                        //negoiatePrice = 35000;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  Map<String, dynamic> message = {
                    'message': 'negotiated price ' + negoiatePrice.toString(),
                    'sentBy': _service.user.uid,
                    'time': DateTime.now().microsecondsSinceEpoch,
                  };
                  _service.createChat(chatId, message);
                  Navigator.of(context).pop();
                },
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                textColor: Colors.white,
                child: Text(
                  "Done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
