import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/dashboard/moreDetails.dart';
import 'package:hire_me/dashboard/skills.dart';


class Dashoard extends StatefulWidget {
  @override
  _DashoardState createState() => _DashoardState();
}

class _DashoardState extends State<Dashoard> {

var user=FirebaseAuth.instance.currentUser;
static List<dynamic> skills=[];
var db=FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid);
String moreDetails="";
bool isClickedMoreDetails=false;
@override
  void initState() {
    db.snapshots().listen((event) { 
      skills.clear();
      if(mounted){
        setState(() {
          Map<String,dynamic> data=event.data();
          if(data.containsKey("skills")){
        for (var item in data["skills"]) {
          skills.add(item);
          }
          
         }
           if(data.containsKey("moredetails")){
       
          moreDetails=data["moredetails"];
        
         }
        });
      }

    });
    super.initState();
  }
  var style=TextStyle(fontSize: 16,fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      clipBehavior: Clip.antiAlias,

      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
       children: [

             Center(child: Hero(tag: user.uid, child:   Container(
                margin: EdgeInsets.fromLTRB(10, 25, 15, 0),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${user.photoURL}", )
                   ,fit: BoxFit.cover)
                ),
              ),),
            
            ),
              SizedBox(height: 5,),
              
              
                Container(
                  child: Center(child:Text("${user.displayName}",style:TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.blue[900]))),
                ),

         Container(
           margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
           child:  Text("Skills", style: TextStyle(fontSize:18,
           fontWeight:FontWeight.bold),),),
            //Add Skills
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(icon: Icon(Icons.add), 
            onPressed: (){
              print(skills);
              showDialog(
                barrierDismissible: false,
                context: context,
              builder: (context) => Skills(
                myskills:skills,
                onselected: (dynamic skill) {
                  if(mounted){
                    setState(() {
                      
                    });
                  }
                } ,
              ),);
            })
            , Expanded(child:Container(
              margin: EdgeInsets.all(10),
              child:Text(skills.length ==0?"None":skills.toList().toString()
            
            , textAlign: TextAlign.start
            , style: style,)))
        
        
          ],
        ),
          
          Container(
           margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
           child:  Text("More Details", style: TextStyle(fontSize:18,
           fontWeight:FontWeight.bold),),)
          // More Details
          ,Row(
            children: [
              IconButton(icon: Icon(Icons.add),
               onPressed: (){
                 showDialog(context: context,
                 builder: (context) => MoreDetails(details: moreDetails,),);
               }),
              
          
           Expanded(child: Container(
             margin: EdgeInsets.all(15),
             child:Text(moreDetails,style: style,)
             ))
           
            ],
          )

        // Post 

       




      
      
      
       ], 
      ),
      
    );
  }
}