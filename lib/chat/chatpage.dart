import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/Peoples/Users.dart';
import 'package:hire_me/login/RegisterHelper.dart';



class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser==null?Container(
              child: Center(child:InkWell(
                onTap: (){
                 showDialog(context: context,
                 builder: (context) {
                   return RegisterHelper();
                 });
                },
                child:Text("Login your account", style:TextStyle(fontSize:18)
              ))),
          ): DefaultTabController(
        length: tabs.length, 
      child: Scaffold(
       
      body: TabBarView(children: tabs.map((e){
       

        if(e.tabName=="People"){
          return Users();
        }

        return Container(
          margin: EdgeInsets.all(5),
          child: Card(
            elevation: 5,
            child: Center(child:Icon(e.icon,size: 80,),
        ),),
        );
      }).toList())
      ,),
      
      );
      
      
  }
}


class TabData{
  String tabName;
  IconData icon;
  TabData({this.icon,this.tabName});
}

List<TabData> tabs=[

TabData(icon: Icons.directions_boat,tabName: "People"),


];