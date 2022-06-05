import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/chat/chat_convesation_display.dart';
import 'package:project/model/popup_menu_model.dart';
import 'package:project/services/Firebase_service.dart';
import 'package:intl/intl.dart';
class ChatCard extends StatefulWidget {
final Map<String, dynamic> chatData;
ChatCard(this.chatData);
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {

  FirebaseService _service = FirebaseService();
  CustomPopupMenuController _controller = CustomPopupMenuController();
  DocumentSnapshot doc;
  String _lastChatDate = '';

  @override
  void initState() {
    getProductDetails();
    getChatTime();
    super.initState();
  }
  getProductDetails(){
    _service.getProductDetails(widget.chatData['product']['productId']).then((value){
      setState(() {
        doc = value;
      });
    });
  }
  getChatTime(){
    var _date = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    var _today = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
    if(_date==_today){
      setState(() {
_lastChatDate='Today';
      });
    }else{
      _lastChatDate = _date.toString();
    }

  }
  List<PopupMenuModel> menuItems = [
  PopupMenuModel('Delete Chat', Icons.delete),
  PopupMenuModel('Mark as Sold', Icons.done),
  ];
  @override
  Widget build(BuildContext context) {
    return doc==null ? Container():Container(
      child: Stack(
        children: [
          SizedBox(height: 10,),
          ListTile(
            onTap: (){
              _service.messages.doc(widget.chatData['chatRoomId']).update({
                'read' : 'true',
              });
              Navigator.push (context, MaterialPageRoute (builder: (BuildContext context) => ChatConversation(
                chatRoomId: widget.chatData['chatRoomId'],
              ),),);
            },
            leading: Container(
              width: 60,
                height: 60,
                child: Image.network(doc['images'][0])),
            title: Text(doc['title'],style: TextStyle(fontWeight: widget.chatData['read']==false ? FontWeight.bold:FontWeight.normal),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc['description'],maxLines: 1,),
                if(widget.chatData['lastChat']!=null)
                  Text(widget.chatData['lastChat'],maxLines: 1,style: TextStyle(fontSize: 10),),
              ],
            ),
            trailing: CustomPopupMenu(
              child: Container(
                child: Icon(Icons.more_vert_sharp, color: Colors.black),
                padding: EdgeInsets.all(20),
              ),
              menuBuilder: () => ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: const Color(0xFF4C4C4C),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: menuItems
                          .map(
                            (item) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                           if(item.title=='Delete Chat'){
                             _service.deleteChat(widget.chatData['chatRoomId']);
                             _controller.hideMenu();
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                   content: Text('Chat Deleted'),
                               ),
                             );
                           }
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  item.icon,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding:
                                    EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
              ),
              pressType: PressType.singleClick,
              verticalMargin: -10,
              controller: _controller,
            ),
          ),
          Positioned(
            right: 10.0,
              top : 10.0,
              child: Text(_lastChatDate),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
