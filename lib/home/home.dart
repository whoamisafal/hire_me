import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/chat/chatpage.dart';
import 'package:hire_me/dashboard/dashboard.dart';
import 'package:hire_me/home/drawer.dart';
import 'package:hire_me/home/homepage.dart';
import 'package:hire_me/login/RegisterHelper.dart';
import 'package:hire_me/login/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 int currentIndex=0;
  static const  style=TextStyle(fontSize: 18,fontWeight: FontWeight.bold);
  void _selectedIndex(int val){
  
      setState(() {
        currentIndex=val;
      });
   
  }

var user=
             FirebaseAuth.instance.currentUser;
List<NavMenu> btnMenu=[
  new NavMenu(icon: Icons.home, name: "Home"),
  new NavMenu(icon: Icons.chat, name: "Chat"),
  new NavMenu(icon: Icons.dashboard, name: "Dashboard")
];
@override
  void initState() {

if(user==null){

  btnMenu.removeAt(2);
}
   fcm.configure(
     
     onLaunch: (message) async{
       print("OnLaunch");
     },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      
      });

    super.initState();
  }

@override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: DrawerMenu(onselectedChanged: (val) {
           if(mounted){
             setState(() {
                if(true){
             try {
                btnMenu.removeAt(2);
                currentIndex=0;
                
             } catch (e) {
             }
            }
             });
           }
            
          }, ),
        ),
        
      
    bottomNavigationBar: BottomNavigationBar(
        items: btnMenu.map((e){
          return BottomNavigationBarItem(icon: Icon(e.icon),
          title: Text("${e.name}", style: style,));
        }).toList(),
      selectedItemColor: Colors.red,
       backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (value) {_selectedIndex(value);},
      ),

      appBar: AppBar(
        actions: [
       
        ],
        title:Text(currentIndex==0?"Home":currentIndex==1?"Chat":"Dashboard", style: TextStyle(
        color: Colors.black
        
      ),
    
      ), backgroundColor: Colors.blue[800],),
    
    body: currentIndex==0?HomePage():currentIndex==1?ChatPage():currentIndex==2?Dashoard():RegisterHelper(),
    ),

    
    );
  }
}

class NavMenu{
  String name;
  IconData icon;
  NavMenu({this.icon,this.name});
}