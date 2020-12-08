import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MoreDetails extends StatefulWidget {
 final  String details;
  MoreDetails({this.details});
  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
TextEditingController controller=new TextEditingController();

     var db=FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid);
@override
  void initState() {
     controller.text=widget.details;
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     
    
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Details"),
      content: Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.4,
        child: Container(
          decoration: BoxDecoration(
            border:Border.all(),
            borderRadius: BorderRadius.circular(15)
          ),
          child: TextField(
            controller: controller,
          
            keyboardType: TextInputType.multiline,
            minLines: 10,
            maxLines: 15,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: InputBorder.none
              

              ,hintText: "Your details",
              
            ),
          ),
        ),

      ),
      actions: [
        RaisedButton(onPressed: (){
        
          db.update({"moredetails":controller.text});
          controller.clear();
          Navigator.of(context).pop(true);

        },
        color: Colors.blue,
        child:Text("Done"))
      ],
      
    );
  }
}