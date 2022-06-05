import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Bargening_Display.dart';
import 'package:project/Screens/chat/chat_stream.dart';
import 'package:project/services/Firebase_service.dart';

class ChatConversation extends StatefulWidget {
  final String chatRoomId;
  ChatConversation({this.chatRoomId});

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  FirebaseService _service = FirebaseService();
  var chatMessageController = TextEditingController();
  bool _send = false;
  DocumentSnapshot chatDoc;
  sendMessage(){
    if(chatMessageController.text.isNotEmpty){
      FocusScope.of(context).unfocus();//it will close the keyboad automatically
      Map<String,dynamic> message = {
         'message' : chatMessageController.text,
        'sentBy':_service.user.uid,
        'time':DateTime.now().microsecondsSinceEpoch,
      };
      _service.createChat(widget.chatRoomId,message);
      chatMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton( icon: Icon(Icons.call),onPressed: (){}),
          IconButton( icon: Icon(Icons.more_vert_sharp),onPressed: (){}),
        ],
        shape: Border(bottom: BorderSide(color: Colors.grey),),
      ),
      body: Container(
        child: Stack(
          children: [
          ChatStream(widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:Border(
                    top: BorderSide(color: Colors.grey[800]),

                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatMessageController,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            hintText: 'Type Message',
                            hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            if(value.isNotEmpty){
                              setState(() {
                                _send=true;
                              });
                            }else{
                              setState(() {
                                _send=false;
                              });
                            }
                          },
                          onSubmitted: (value){
                            if(value.length>0){
                              sendMessage();
                            }
                          },
                        ),

                      ),

                      Visibility(
                        visible: _send,
                        child: IconButton(
                            onPressed:sendMessage,
                            icon: Icon(Icons.send,color: Theme.of(context).primaryColor,),
                        ),
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            child: Text('Negotiate'),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                            onPressed: () async {
                              dynamic price, chatId;

                              await _service.messages
                                  .doc(widget.chatRoomId)
                                  .get()
                                  .then((value) {
                                setState(() {
                                  chatDoc = value;
                                  price = chatDoc['product']['price'];
                                  chatId = widget.chatRoomId;
                                  print('price...' + price.toString());
                                });
                              });
                              Navigator.pushNamed(context, BargainingScreen.id,
                                  arguments: [
                                    price,
                                    chatId,
                                  ]);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),

              ),
            ),

          ],
        ),

      ),

    );
  }
}
