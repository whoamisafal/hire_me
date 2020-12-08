import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hire_me/chat/message.dart';
import 'package:hire_me/login/auth.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  String currentDropDownSelected="School Students";
 // TextEditingController searchController=TextEditingController();
  //  String searchValue="";
    bool isLoading=true;
var currentUser=FirebaseAuth.instance.currentUser;
List<UserModel> users=[


];
Widget user(UserModel user){
  return Container(
    margin: EdgeInsets.all(1),
    height: 80,
 
    child: InkWell(
      onTap:(){
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => Message(user:user),
          ));



      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[
            Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(tag: user.uid, child:   Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${user.userProfile}", )
                   ,fit: BoxFit.cover)
                ),
              ),),
                Container(
                  child: Center(child:Text("${user.userName}",style:TextStyle(fontWeight: FontWeight.bold))),
                ),
            ],
          ),

        
        
        ]
      ),

    ),

  );
}
@override
  void initState() {
  
    FirebaseFirestore.instance.collection("users").where("uid", isNotEqualTo: currentUser.uid)
    .snapshots().listen((event) {
      users.clear();
      for (var item in event.docs) {
        if(mounted){
          setState(() {
            Map<String,dynamic> d=item.data();
          var model=  new UserModel(
        uid: d["uid"],
         userName: d["userName"],
         userProfile:d["userProfile"] );
         users.add(model);
        isLoading=false;
          });
        }
        
      }

    });
  



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
   
          
        /*  DropdownButton<String>(
            iconEnabledColor: Colors.white,
           onTap: () {
             
           },
        value: currentDropDownSelected,
        items: <String>['School Students', 'All Students', 'All People', 'School Teacher',"All Teacher"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(), onChanged: (value) {
            if(mounted){
              setState(() {
                currentDropDownSelected=value.toString();
              });
            }
          },)*/
  


      body:isLoading?Center(child:CircularProgressIndicator()):users.length==0?Center(child:Text("People empty")): ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),

        children: [
          //Search
       /*   Container(
            margin: EdgeInsets.fromLTRB(15,10,15,0),
              height: 50,
            child: Card(
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(width: MediaQuery.of(context).size.width*0.6,
                child:   TextField(
                  onChanged: (value) {
                    if(mounted){
                      setState(() {
                      searchValue=value;
                    });
                    }
                  },
                  controller: searchController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                  
                    hintText: "Search...",
                    
                  border: InputBorder.none),

                ),
                
                ),
                if(searchValue.isEmpty)
               IconButton(icon: Icon(Icons.search), onPressed: (){}),
                   if(searchValue.isNotEmpty)
               IconButton(icon: Icon(Icons.clear), onPressed: (){
                 if(mounted){
                   setState(() {
                     searchValue="";
                     searchController.clear();
                   });
                 }
               })
              ],                  
 
              ),)
        
            )*/
        
        Container(

          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
            return user(users[index]);
          },),
        )
        
        ],
      )
      ),
      
    );
  }
}