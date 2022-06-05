import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:project/Screens/Home_Display.dart';
import 'package:project/Screens/Location_Display.dart';

class EmailVerificationDisplay extends StatelessWidget {
  static const String id='Email-veri';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verify Email',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.grey[700],
                ),
                ),

                Text('Check Your email to verify your registered Email',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey),
                        ),
                          child:Text('Verfy Email',style: TextStyle(fontSize:18,color: Colors.grey[700]),),
                        onPressed: ()async {
                          var result = await OpenMailApp.openMailApp();

                          // If no mail apps found, show error
                          if (!result.didOpen && !result.canOpen) {
                            showNoMailAppsDialog(context);

                            // iOS: if multiple mail apps found, show dialog to select.
                            // There is no native intent/default app system in iOS so
                            // you have to do it yourself.
                          } else if (!result.didOpen && result.canOpen) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return MailAppPickerDialog(
                                  mailApps: result.options,
                                );
                              },
                            );
                          }
                          Navigator.pushReplacementNamed(context, LocationDisplay.id);//if location issue resolve change it to locationid
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }
  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
