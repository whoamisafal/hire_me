import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Skills extends StatefulWidget {
  final List<dynamic> myskills;
 final VoidCallback onSelectedSkills;
 final Function (dynamic) onselected;

Skills({@required this.myskills,this.onSelectedSkills,@required this.onselected});

  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  List<dynamic> skills=[];

var db=FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid);

  @override
  void initState() {
  FirebaseFirestore.instance.collection("skills").doc("designer")
  .snapshots().listen((event) {
    skills.clear();
    if(mounted){
      setState(() {
        for (var item in event["skills"]) {
          skills.add(item);          
        }
      });
    }
   });
    super.initState();
 
  
  
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      elevation: 5,
      backgroundColor: Colors.white12,
      title: Text("Choose your skills", style: TextStyle(color:Colors.white),),
      content: Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
          itemCount: skills.length,
          gridDelegate: 
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:2,
        childAspectRatio:2.5,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5
        ),
         itemBuilder: (context, index) {
           return Container(
             
             decoration: BoxDecoration(
               
               color: widget.myskills.contains(skills[index])?Colors.grey:Colors.white12,
             border: Border.all(width: 2),borderRadius:BorderRadius.circular(25)),
             child: InkWell(
                onTap: (){
                  if(mounted){
                    setState(() {
                     if(widget.myskills.contains(skills[index])){
                          widget.myskills.remove(skills[index]);
                 
                     }else{
                        widget.myskills.add(skills[index]);
                   
                     }
                      
                    });
                  }
                },
              child: Center(child:Text("${skills[index]}",style: TextStyle(
                fontWeight:FontWeight.bold,
                color: widget.myskills.contains(skills[index])?Colors.white:Colors.black,
              ), textAlign: TextAlign.center,)), 
             ),
           );
         },),
      ),
      
      actions: [
     
         RaisedButton(
          onPressed: (){
             widget.onselected(widget.myskills);
             db.update({"skills":widget.myskills});
              Navigator.of(context).pop(true);
          },
          color: Colors.blue,
          child: Text("Done"),
        ),
        
      ],
    
    );
  }
}