
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';
import 'package:project/Screens/Main_Display.dart';
import 'package:project/services/Firebase_service.dart';


class LocationDisplay extends StatefulWidget {
  static const String id = 'location-screen';

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {

  FirebaseService _service = FirebaseService();

  bool _loading =false;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  String _address ;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String Manualaddress;



  Future<LocationData>getLocation()async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    final coordinates = new Coordinates(_locationData.latitude,_locationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      _address=first.addressLine;
      countryValue=first.countryName;
    });

    return _locationData;
  }

  @override
  Widget build(BuildContext context) {

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.grey[500],
      textColor: Colors.white,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Colors.grey[700],
    );
    showBottomScreen(context){
      getLocation().then((location){
        if(location!=null){
          progressDialog.dismiss();
          showModalBottomSheet(
              isScrollControlled:true,
              enableDrag: true,
              context: context,
              builder: (context){
                return Column(
                  children: [
                    SizedBox(height: 26,),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          },
                            icon: Icon(Icons.clear),
                          ),
                          SizedBox(width: 10,),
                          Text('Location',style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search City,area or neighbour',
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        progressDialog.show();
                        getLocation().then((value){
                          if(value!=null){
                            _service.updateUser({
                              'location':GeoPoint(value.latitude,value.longitude),
                              'address':_address
                            }, context).then((value){
                              progressDialog.dismiss();
                              Navigator.pushNamed(context, Main_Display.id);
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0.0,
                      leading: Icon(Icons.my_location,color: Colors.blue,),
                      title: Text(
                        'Use Current Location',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        location == null ? 'Fetching location,' : _address,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,bottom: 4,top: 4),
                        child: Text(
                          'CHOOSE CITY',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,0),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        flagState: CountryFlag.DISABLE,
                        dropdownDecoration: BoxDecoration(shape: BoxShape.rectangle),
                        defaultCountry: DefaultCountry.Pakistan,
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged:(value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged:(value) {
                            setState(() {
                              cityValue = value;
                              Manualaddress='$cityValue,$stateValue,$countryValue';
                            });
                            if(value!=null){
                              _service.updateUser({
                                'address':Manualaddress,
                                'state':stateValue,
                                'city':cityValue,
                                'country':countryValue
                              }, context);

                            }

                        },
                      ),
                    ),
                  ],
                );
              });
        }else{
          progressDialog.dismiss();
        }
      });
  }



    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Image.asset('assets/images/Location.jpg',
          ),
          SizedBox(height: 20,),
          Text('Where do want\nto swap products',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
              color: Colors.grey[700]
          ),
          ),
          SizedBox(height: 10,),
          Text('To Enjoy all that we have to offer you\nwe need to know where to look for them',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12,),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child:_loading ?  Center(
                    child:CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    )): ElevatedButton.icon(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),

                        icon:Icon(CupertinoIcons.location_fill,color: Colors.grey[700],),
                        label: Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 15),
                          child: Text('Around me',style: TextStyle(color: Colors.grey[700],fontSize: 18),
                          ),
                        ),
                      onPressed: (){
                        progressDialog.show();

                        getLocation().then((value){
                          print(_locationData.latitude);
                          if(value!=null){
                            _service.updateUser({
                              'address' : _address,
                              'location' : GeoPoint(value.latitude,value.longitude),
                            }, context).then((value){
                              progressDialog.dismiss();
                              Navigator.pushNamed(context, Main_Display.id);
                            });
                          }
                        });
                      },
                    ),
                  ),

              ],
            ),
          ),
          InkWell(
            onTap: (){
              progressDialog.show();
              showBottomScreen(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border:Border(bottom: BorderSide(width: 2))
                ),
                child: Text(
                  'Set location Manually',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey[700]
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
