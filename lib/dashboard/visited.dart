import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Visit extends StatefulWidget {
  final String uid;

  Visit({@required this.uid});
  @override
  _VisitState createState() => _VisitState();
}

class _VisitState extends State<Visit> {

var user=FirebaseAuth.instance.currentUser;
static List<dynamic> skills=[];
 String userName="";
 String url="";
String moreDetails="";
bool isClickedMoreDetails=false;
@override
  void initState() {
    var db=FirebaseFirestore.instance.collection("users").doc(widget.uid);
    db.snapshots().listen((event) { 
      skills.clear();
      if(mounted){
        setState(() {
  
          Map<String,dynamic> data=event.data();
                  userName=data["userName"];
                  url=data["userProfile"];
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
    return Scaffold(
      appBar: AppBar(
        title: Text("$userName"),
        actions: [],),

      body:SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      clipBehavior: Clip.antiAlias,

      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
       children: [

            if(url.isNotEmpty)
             Center(child: Hero(tag: user.uid, child:   Container(
                margin: EdgeInsets.fromLTRB(10, 25, 15, 0),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("$url", )
                   ,fit: BoxFit.cover)
                ),
              ),),
            
            ),
              SizedBox(height: 5,),
              
              
                Container(
                  child: Center(child:Text("$userName",style:TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.blue[900]))),
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
          
             Expanded(child:Container(
              margin: EdgeInsets.all(10),
              child:Text(skills.length ==0?"None":skills.toList().toString()
            
            , textAlign: TextAlign.start
            , style: style,)))
        
        
          ],
        ),
          if(moreDetails.isNotEmpty)
          Container(
           margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
           child:  Text("More Details", style: TextStyle(fontSize:18,
           fontWeight:FontWeight.bold),),)
          // More Details
          ,Row(
            children: [
             
              
          
           Expanded(child: Container(
             margin: EdgeInsets.all(15),
             child:Text(moreDetails,style: style,)
             ))
           
            ],
          )

        // Post 

       




      
      
      
       ], 
      ),
      
    )
  
  
    );
  
  }
}