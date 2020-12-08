import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hire_me/dashboard/visited.dart';
import 'package:hire_me/home/homepage.dart';

class View extends StatefulWidget {
  final Posts posts;
  View({@required this.posts});
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {

var user=FirebaseAuth.instance.currentUser;
@override

void initState(){
  super.initState();

 try {
    if(!widget.posts.views.contains(user.uid)){
    widget.posts.views.add(user.uid);
    FirebaseFirestore.instance.collection("post").doc(widget.posts.docId).update({
      "views":widget.posts.views
    });
  }
 } catch (e) {
 }
}



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
     appBar: AppBar(
       title: Text("${widget.posts.title}", overflow: TextOverflow.ellipsis,),
       
       actions: [],),
        body:SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
             Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: Image.network(widget.posts.url,
              fit: BoxFit.fitHeight,
              ),),

              Center(
                child: RaisedButton(onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => Visit(uid: widget.posts.uid,),
                  ));


                },
                color: Colors.red,
                child: Text("Hire now",style: TextStyle(color: Colors.white),),
              ),
              )
          ],
        )) ,
      ),
      
    );
  }
}