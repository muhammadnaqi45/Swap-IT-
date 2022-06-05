import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/authentication/reset_password.dart';
import 'package:project/services/EmailAuth_Service.dart';

class EmailAuthDisplay extends StatefulWidget {
  static const String id = 'EmailAuth-screen';

  @override
  State<EmailAuthDisplay> createState() => _EmailAuthDisplayState();
}

class _EmailAuthDisplayState extends State<EmailAuthDisplay> {
  final _formKey = GlobalKey<FormState>();
  bool _validate=false;
  bool _login = false;
  bool _loading = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  EmailAuthentication _services = EmailAuthentication();
  _validateEmail(){
    if(_formKey.currentState.validate()){
setState(() {
  _validate=false;
  _loading=true;
});
_services.getAdminCredential(
  context: context,
  isLog:_login,
  password: _passwordController.text,
  email: _emailController.text
).then((value){
  setState(() {
    _loading=false;
  });
});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
         iconTheme: IconThemeData(color: Colors.black,
         ),
        backgroundColor: Colors.white,
        title: (
        Text(
          'Welcome To SWAP-IT',style: TextStyle(
          color: Colors.grey[800],
        ),
        )
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.cyan[200],
                  child: Image.asset('assets/images/Login.png',),
                ),
              ),
              SizedBox(height: 12,),
              Text(
                'Enter to ${_login ? 'Login' : 'Register'}',
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                'Enter Email and Password to ${_login ? 'Login' : 'Register'}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
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
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4),),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon:_validate ?IconButton(
                    icon:Icon(Icons.clear),
                    onPressed: (){
                      _passwordController.clear();
                      setState(() {
                        _validate=false;
                      });
                    },
                  ) : null,
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4),),
                ),
                onChanged: (value){
                  if(_emailController.text.isNotEmpty){
                    if(value.length>3){
                      setState(() {
                        _validate = true;
                      });
                    }else
                      {
                        setState(() {
                          _validate = false;
                        });
                      }
                  }
                },
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(child:Text('Forgot Password?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                    onPressed: (){
                    Navigator.pushNamed(context, PasswordReset.id);
                    },
              ),
              ),
              Row(
                children: [
                Text(
                  _login ? 'New Account ? ' : 'Already Have an account?'
                ),
                  TextButton(
                      child:Text( _login ? 'Register' : 'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    onPressed: (){
                        setState(() {
                          _login = !_login;
                        });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child:Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: _validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: _validate
                    ? MaterialStateProperty.all(Colors.grey[700])
                    : MaterialStateProperty.all(Colors.grey),
              ),
              onPressed: (){
                _validateEmail();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _loading ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ):Text(
                  '${_login ? 'Login' : 'Register'}',
                  style: TextStyle(
                    color: Colors.white,fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
