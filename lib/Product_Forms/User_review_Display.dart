import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:project/Screens/Location_Display.dart';
import 'package:project/Screens/Main_Display.dart';
import 'package:project/provider/categ_provider.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:provider/provider.dart';



class UserReviewDisplay extends StatefulWidget {
  static const String id = 'user-review-screen';

  @override
  State<UserReviewDisplay> createState() => _UserReviewDisplayState();
}

class _UserReviewDisplayState extends State<UserReviewDisplay> {

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  FirebaseService _service = FirebaseService();
  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+92');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();
  // @override   remove
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   var _provider = Provider.of<CategoryProvider>(context);
  //   _provider.getUserDetails();
  //   setState(() {
  //     _nameController.text = _provider.userDetails['name'];//first time we dont have a field of name
  //     _phoneController.text = _provider.userDetails['mobile'];
  //     _emailController.text = _provider.userDetails['email'];
  //     _addressController.text = _provider.userDetails['address'];
  //   });
  //   super.didChangeDependencies();
  // }
  Future<void> updateUser(provider,Map<String,dynamic>data, context) {
    return _service.users
        .doc(_service.user.uid)
        .update(data)
        .then((value) {
          saveProductToDb(provider,context);
    },).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Location'),
        ),
      );
    });
  }
  Future<void> saveProductToDb(CategoryProvider provider,context) {
    return _service.products
        .add(
      provider.dataToFirestore
    )
        .then((value) {
          provider.clearData();//need to clear all the save data from mobile
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('We have received your product and will be notify you once get approved'),
            ),
          );
          Navigator.pushReplacementNamed(context,Main_Display.id);
    },)
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showConfirmDialog(){
      return showDialog(
          context: context,
          builder: (BuildContext context){
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('confirm',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    SizedBox(height: 10,),
                    Text('Are you sure , you want to save below product'),
                    SizedBox(height: 10,),
                    ListTile(
                      leading: Image.network(_provider.dataToFirestore['images'][0]),
                      title: Text(_provider.dataToFirestore['title'],maxLines: 1,),
                      subtitle: Text(_provider.dataToFirestore['price']),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeumorphicButton(
                          onPressed: (){
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          style: NeumorphicStyle(
                            border: NeumorphicBorder(color: Theme.of(context).primaryColor),
                            color: Colors.transparent,
                          ),
                          child: Text('Cancel'),
                        ),
                    SizedBox(width: 10,),
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        color: Theme.of(context).primaryColor
                      ),
                      child: Text('Confirm',style: TextStyle(color: Colors.white),),
                      onPressed: (){

                        updateUser(_provider,{
                          'contactDetaild':{
                            'contactMobile' : _phoneController.text,
                            'contactEmail':_emailController.text,
                            //address will update from address screen
                          },
                          'name' :_nameController.text,

                        }, context).then((value){
                          setState(() {
                            _loading = false;
                          });

                        });
                      },
                    ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    if(_loading)
                    Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text('Review your detail',style: TextStyle(color: Colors.black),),
        shape: Border(bottom: BorderSide(color: Colors.grey[300])),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.getUserData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ));
            }
            _nameController.text = snapshot.data['name'];
            _phoneController.text = snapshot.data['mobile'];
            _emailController.text = snapshot.data['email'];
            _addressController.text = snapshot.data['address'];
            return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Your name',
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Enter your name';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30,),
                        Text(
                          'Contact Detail',
                          style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                              controller: _countryCodeController,
                              enabled: false,
                              decoration: InputDecoration(labelText: 'country'),
                            ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 3,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Mobile number',
                                    helperText: 'Enter contact mobile number',
                                  ),
                                  maxLength: 10,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Enter mobile number';
                                    }
                                    return null;
                                  },
                            ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            helperText: 'Enter contact email',
                          ),
                          validator: (value){
                            final bool isValid = EmailValidator.validate(_emailController.text);
                            if(value==null || value.isEmpty){
                              return 'Enter email';
                            }
                            if(value.isNotEmpty && isValid==false)
                            {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        //if you want to change address before confirming
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                controller: _addressController,
                                minLines: 1,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  helperText: 'Contact Address',
                                ),
                              ),
                            ),
                            IconButton(
                              icon:Icon(Icons.arrow_forward_ios,),
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder:(BuildContext context) => LocationDisplay(),),);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
          },
        ),

      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child:Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text('confirm',textAlign: TextAlign.center,
                style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
                ),
                onPressed: (){
                  if(_formKey.currentState.validate()){

                   return showConfirmDialog();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter Required field'),
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
