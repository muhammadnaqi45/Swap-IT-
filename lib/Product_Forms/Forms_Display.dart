import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:project/Buttons/imagePicker.dart';
import 'package:project/Product_Forms/Form_class.dart';
import 'package:project/Product_Forms/User_review_Display.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:provider/provider.dart';

class FormsDisplay extends StatefulWidget {
  static const String id = 'form-display';

  @override
  State<FormsDisplay> createState() => _FormsDisplayState();
}

class _FormsDisplayState extends State<FormsDisplay> {

  FormClass _formClass = FormClass();
  final _formKey=GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();

  var _brandText = TextEditingController();
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _typeText = TextEditingController();
  var _BrandBS = TextEditingController();
  var _BrandBicycle = TextEditingController();
  var _BrandCar = TextEditingController();
  var _Fuels = TextEditingController();
  var _transmissions = TextEditingController();
  var _owner = TextEditingController();
  var _YearController = TextEditingController();
  var _KmController = TextEditingController();
  var _addressController = TextEditingController();

  validate(CategoryProvider provider){
    if(_formKey.currentState.validate()){
      //is all field is fill and if
      if(provider.urlList.isNotEmpty){
        //should have image
        provider.dataToFirestore.addAll({
          'category':provider.selectedCategory,
          'subCat' : provider.selectedSubCat,
          'brand' : _brandText.text,
          'type' : _typeText.text,
          'BrandBS' : _BrandBS.text,
          'BrandCar' : _BrandCar.text,
          'BrandBicycle' : _BrandBicycle.text,
          'Year' : _YearController.text,
          'Fuel' : _Fuels.text,
          'transmissions' : _transmissions.text,
          'owner' : _owner.text,
          'price' : _priceController.text,
          'address' : _addressController.text,
          'Km' : _KmController.text,
          'title': _titleController.text,
          'description':_descController.text,
          'swapperUid': _service.user.uid,
          'images' : provider.urlList,
          'postedAt' : DateTime.now().microsecondsSinceEpoch,
          'favourites' : []
        });
        print(provider.dataToFirestore);
        // once saved all data to provider , we need to check user contact detail again
        //to confirm all detail are there, so we need to go to profile screen
        Navigator.pushNamed(context, UserReviewDisplay.id);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('image not uploaded'),
          ),
        );
      }
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete required field'),
          ),
        );
    }
  }


  @override
  Widget build(BuildContext context) {

    var _provider =Provider.of<CategoryProvider>(context);
    showBrandDialog(list,_textController){
      return showDialog(
          context:context,
          builder : (BuildContext context){
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appbar(_provider),
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context,int i ){
                          return ListTile(
                            onTap: (){
                              setState(() {
                                _textController.text = list[i];
                              });
                              Navigator.pop(context);
                            },
                            title: Text(list[i]),);
                        }),
                  ),
                ],
              ),
            );
          });
    }
    showFormDialog(list,_textController){
      return showDialog(
          context:context,
          builder : (BuildContext context){
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _formClass.appbar(_provider),
              ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                  itemBuilder: (BuildContext context,int i ){
                return ListTile(
                  onTap: (){
                    setState(() {
                      _textController.text = list[i];
                    });
                    Navigator.pop(context);
                  },
                  title: Text(list[i]),);
              }),
            ],
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text('Add Some Detail',style: TextStyle(color: Colors.black),),
        shape: Border(bottom: BorderSide(color: Colors.grey[300])),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_provider.selectedCategory} > ${_provider.selectedSubCat}'),
                //this brand should show only for mobile
                if(_provider.selectedSubCat == 'SmartPhone')
                InkWell(
                  onTap: (){
                    //we need to save some brand to show
                    showBrandDialog(_provider.doc['brands'],_brandText);
                  },
                  child: TextFormField(
                    controller: _brandText,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Brands',
                    ),
                  ),
                ),
                if(_provider.selectedSubCat == 'Accessories'
                ||_provider.selectedSubCat == 'Tablets')
                InkWell(
                  onTap: (){
                    //we need to save some brand to show
                    if(_provider.selectedSubCat == 'Tablets'){
                      return showFormDialog(_formClass.tabType, _typeText);
                    }
                    showFormDialog(_formClass.accessories,_typeText);
                  },
                  child: TextFormField(
                    controller: _typeText,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'types',
                    ),
                  ),
                ),
                //Vehicles Part
                if(_provider.selectedSubCat == 'Bikes'||_provider.selectedSubCat == 'Scooters')
                Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          showBrandDialog(_formClass.Brand_BS,_BrandBS);
                        },
                        child: TextFormField(
                          controller: _BrandBS,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Brand',
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _YearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Year',
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'please complete required field';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Address',
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'please complete required field';
                          }
                          return null;
                        },
                      ),


                    ],

                  ),
                ),
                if(_provider.selectedSubCat == 'Cars')
                  Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            showBrandDialog(_formClass.Brand_Cars,_BrandCar);
                          },
                          child: TextFormField(
                            controller: _BrandCar,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Brand*',
                            ),
                          ),
                        ),

                        TextFormField(
                          controller: _YearController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Year*',
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'please complete required field';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _KmController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Km Drive*',
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'please complete required field';
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: (){
                            showFormDialog(_formClass.Fuel_Cars,_Fuels);
                          },
                          child: TextFormField(
                            controller: _Fuels,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Fuel*',
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'please complete required field';
                              }
                              return null;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            showFormDialog(_formClass.Transmission,_transmissions);
                          },
                          child: TextFormField(
                            controller: _transmissions,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Transmission*',
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'please complete required field';
                              }
                              return null;
                            },

                          ),
                        ),
                        InkWell(
                          onTap: (){
                            showFormDialog(_formClass.NoofOwner,_owner);
                          },
                          child: TextFormField(
                            controller: _owner,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'NoOfOwner*',
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'please complete required field';
                              }
                              return null;
                            },
                          ),
                        ),
                        TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Address*',
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'please complete required field';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                  ),
                if(_provider.selectedSubCat == 'Bicycle')
                  Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            showBrandDialog(_formClass.Brand_Bicycle,_BrandBicycle);
                          },
                          child: TextFormField(
                            controller: _BrandBicycle,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Brand',
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _YearController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Year*',
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'please complete required field';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Address*',
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'please complete required field';
                            }
                            return null;
                          },
                        ),


                      ],

                    ),
                  ),
                if(_provider.selectedSubCat == 'Vehicles parts'
                    ||_provider.selectedSubCat == 'Other Vehicles')
                  InkWell(
                    onTap: (){
                      //we need to save some brand to show
                      if(_provider.selectedSubCat == 'Other Vehicles'){
                        return showFormDialog(_formClass.Other_Vehicles, _typeText);
                      }
                      showFormDialog(_formClass.Vehicle_Parts,_typeText);
                    },
                    child: TextFormField(
                      controller: _typeText,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'types',
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Price',
                    prefixText: 'Rs'
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'please complete required field';
                    }
                    if(value.length<5){
                      return 'Required minimum price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                      labelText: 'Add title*',
                      helperText: 'Mention the key features (e.g brand, model)',
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'please complete required field';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descController,
                  keyboardType: TextInputType.text,
                  maxLength: 4000,
                  minLines: 1,
                  maxLines: 30,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    helperText: 'Include Condition , features , reason for swapping',
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'please complete required field';
                    }
                    if(value.length<30){
                      return 'Need at least 30 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                Divider(color: Colors.grey,),
                //show this only if image available
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _provider.urlList.length==0 ? Padding(
                      padding: const EdgeInsets.all(10),
                  child: Text('No image Selected',textAlign: TextAlign.center,),
                  ):GalleryImage(
                    imageUrls: _provider.urlList,
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    //upload image from here
                    showDialog(context: context, builder: (BuildContext context){
                      return ImagePick();
                    });
                  },
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Theme.of(context).primaryColor,
                      )
                    ),
                    child: Container(
                      height: 40,
                      child: Center(child: Text(_provider.urlList.length>0 ? 'upload more Images':'Upload image'),),
                    ),
                  ),

                ),
                SizedBox(height: 80,),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: NeumorphicButton(
                  style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'NEXT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                    onPressed:(){
                    validate(_provider);
                    },
                ),
              )
          ),
        ],
      ),
    );
  }
}
