import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/Service.dart';
import 'package:hire_me/chat/chatModel.dart';

import 'package:hire_me/login/auth.dart';

class Message extends StatefulWidget {

  final UserModel user;
  Message({key,@required this.user}):super(key:key);
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
TextEditingController _message=new TextEditingController();
var currentUser=FirebaseAuth.instance.currentUser;
String docId="";
String menu="";
bool isLoading=true;
var messages=<ChatModel>[];

var db=FirebaseFirestore.instance.collection("chats");
@override
void initState(){
  if(widget.user.uid.compareTo(currentUser.uid)==1){
      if(mounted){
        setState(() {
          docId=widget.user.uid+""+currentUser.uid;
        });
      }
  }else{
if(mounted){
        setState(() {
           docId=currentUser.uid+""+widget.user.uid;
        });
      }
  }
try {
  db.doc(docId).collection("chat")
  .orderBy("timestamp",  descending: true).snapshots().listen((val) {
    messages.clear();
    for (var item in val.docs) {
      if(mounted){
        setState(() {
          Map<String,dynamic> data=item.data();
          var d=ChatModel(isReplay: data["isReplay"], message: data["message"],
          reciverDel: data["reciverDel"], reciverId: data["reciverId"],
          docId: item.id,
          timestamp: data["timestamp"], 
          type: data["type"],
          replay: data["replay"] , senderDel: data["senderDel"], senderId: data["senderId"]
          
          
          );
          isLoading=false;
          messages.add(d);
        });
      }
    }

   });
} catch (e) {
}finally{
  if(mounted){
    setState(() {
      isLoading=false;
    });
  }
}


  super.initState();
}
@override
void dispose(){
  _message.dispose();
  super.dispose();

}
Widget _messageList(){
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    decoration: BoxDecoration(
   color: Colors.white12,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25)
    ),
   
    ),
    height: MediaQuery.of(context).size.height,
    child: ListView.builder(
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (context, index){
        if(currentUser.uid==messages[index].senderId){
          return  _messageW(messages[index], true);
        }return  _messageW(messages[index], false);
      },
    )
    
  );
}
Widget _messageW(ChatModel model,bool isMe){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if(!isMe)
    Row(
      children:[

        
          Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${widget.user.userProfile}", )
                   ,fit: BoxFit.cover)
                ),
              )
      ,Text("${widget.user.userName}",style: TextStyle(fontWeight: FontWeight.bold ),)
     
      ]
    ),
    
        Padding(padding: isMe?EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.75, 5, 0, 0)
        :EdgeInsets.fromLTRB(50, 5, 0, 0)
        ,child:  Text(readTimestamp(model.timestamp),style: TextStyle(
          fontWeight:FontWeight.bold
        ),),
        ),
 Container(
    margin: isMe?EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.5, 5, 25, 5):EdgeInsets.fromLTRB(25, 5, MediaQuery.of(context).size.width*0.3, 10),
    padding: isMe?EdgeInsets.fromLTRB(10, 15, 10, 15):EdgeInsets.fromLTRB(10, 15,10, 15),
    decoration: BoxDecoration(
    
      borderRadius: BorderRadius.only(
        bottomLeft:isMe? Radius.circular(0):Radius.circular(25),
        bottomRight:isMe? Radius.circular(25):Radius.circular(0),
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25)

      )

    ),
    child: Row(
      children: [
      Expanded(
        child:   Container(
          padding: EdgeInsets.all(15),
          child: Center(child: Text("${model.message}",style: TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:Colors.white)),),
          decoration: BoxDecoration(
      color: isMe?Colors.green[800]:Colors.lightBlue[800],
      borderRadius: BorderRadius.only(
        bottomLeft:isMe? Radius.circular(0):Radius.circular(25),
        bottomRight:isMe? Radius.circular(25):Radius.circular(0),
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25)
        

      ),
      ),))
       , 
      /* if(!isMe)
       IconButton(icon: Icon(Icons.more_horiz), onPressed: (){
         showDialog(context: context,
         builder: (context) => MenuOptions(
           onchanged: (String val){
              if(mounted){
                setState(() {
                  print(val);
                if(val=="remove"){
                    db.doc(docId).collection("chat").doc(model.docId).update({"reciverDel":true});
                }
                });
              }
           },
           menu: menu,
         ),);
       })*/
      ],
    )
  )
  
    ],
  )
    ;
}

Widget _sendMessage(){
  return Container(
    color: Colors.white12,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(icon: Icon(Icons.add), onPressed: (){
          showDialog(context: context,
          builder: (context) => Transform.translate(offset: new Offset(0,MediaQuery.of(context).size.height*0.4),
          child:OtherChatOptions()
          ),);
        })
  , Expanded(
     flex: 1,
     child:    TextField(textAlign: TextAlign.justify,
     controller: _message,
      onChanged: (String value){},
    
        scrollPadding: EdgeInsets.all(5),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Send message...",
        
      ),),),
    
    
    
    IconButton(icon: Icon(Icons.send), onPressed: ()async{
    if(_message.text.isEmpty){
      return;
    }
    var chat=ChatModel(message: _message.text, senderId: currentUser.uid,
    reciverId: widget.user.uid);
    db.doc(docId).collection("chat").doc().set(chat.toMap());
   sendNotificationMessage(widget.user.token, _message.text, currentUser.displayName+" message").then((value) {
      print("notification sent");
    });
_message.clear();

    })
    ],)
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Chat")),
      body: Container(
      child: Column(
      
        children: [
          if(isLoading)
          Center( child: CircularProgressIndicator(),),
          if(!isLoading && messages.length==0)
            Expanded(child: Center( child: Text("Let's start converstation"),))
          else
         Expanded(child:  _messageList(),),
          _sendMessage(),


        ],
      ),

    ),
    );
  }
}


class OtherChatOptions extends StatefulWidget {
  @override
  _OtherChatOptionsState createState() => _OtherChatOptionsState();
}

class _OtherChatOptionsState extends State<OtherChatOptions> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      content: Container(
        
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            IconButton(icon: Icon(Icons.favorite), onPressed: (){}),
              IconButton(icon: Icon(Icons.favorite_border), onPressed: (){}),
                IconButton(icon: Icon(Icons.favorite), onPressed: (){}),
                  IconButton(icon: Icon(Icons.favorite), onPressed: (){}),
                    IconButton(icon: Icon(Icons.favorite), onPressed: (){})
          ],
        ),
      ),
    );
  }
}

/*
class MenuOptions extends StatefulWidget {
  final String menu;
 final VoidCallback onClickedMenu;
 final Function( String) onchanged;
  MenuOptions({@required this.menu,this.onClickedMenu,@required this.onchanged});
  
  @override
  _MenuOptionsState createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      content: Container(
        
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           
             RaisedButton(
               color: Colors.blue[900],
               onPressed: (){
                 widget.onchanged("replay");
                 Navigator.of(context).pop(true);  
               },child: Text("replay",
             
              style: TextStyle(fontSize:14,color:Colors.white)),),
            
          ],
        ),
      ),
    );
  }
}

*/