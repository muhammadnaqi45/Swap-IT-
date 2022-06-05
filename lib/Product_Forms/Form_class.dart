import 'package:flutter/material.dart';
import 'package:project/provider/categ_provider.dart';

class FormClass{

  List accessories = [
    'Mobile',
    'Tablets'
  ];
  List tabType = [
    'Ipads',
    'Samsung',
    'Other Tablets'
  ];
  List bikesType = [
    'Standard',
    'Sport-Bike',
    'Cruiser',
    'Off-road',
  ];
  List Brand_BS = [
    'Honda',
    'Yamaha',
    'Road-Prince',
    'United',
    'Keeway',
  ];
  List Brand_Cars = [
    'Honda',
    'Toyota',
    'BMW',
    'Mercedes',
    'MG',
    'Kia',
    'Suzuki',
  ];
  List Brand_Bicycle = [
    'Gaint',
    'Trinx',
    'Fareast',
  ];
  List Fuel_Cars = [
    'Petrol',
    'Diesel',
    'Electric',
    'LPG',
  ];
  List Transmission = [
    'automatic',
    'Manually',
  ];
  List NoofOwner = [
    '1',
    '2',
    '3',
    '4+',
  ];
  List Vehicle_Parts = [
    'Bikes',
    'Cars',
    'Bicycle',
    'Scooter',
  ];
  List Other_Vehicles = [
    'Tractor',
    'Bus',
    'Rickshaw',
  ];

  Widget appbar(CategoryProvider _provider){
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(bottom: BorderSide(color: Colors.grey[300]),),
      title: Text(
        _provider.selectedSubCat,
        style: TextStyle(color: Colors.black),
      ),
    );

}
}