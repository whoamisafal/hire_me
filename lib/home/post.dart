import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hire_me/chat/chatModel.dart';
import 'package:hire_me/dashboard/visited.dart';
import 'package:hire_me/home/homepage.dart';
import 'package:hire_me/views/views.dart';

class PostView extends StatefulWidget {
 final Posts posts;
  PostView({this.posts,key}):super(key:key);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  var db=FirebaseFirestore.instance.collection("post");
var user=FirebaseAuth.instance.currentUser;
  void addLike(){
    if(user==null){
      return;
    }
try {
      if(widget.posts.likes.contains(user.uid)){
      widget.posts.likes.remove(user.uid);
    }else{
      widget.posts.likes.add(user.uid);
    }
    db.doc(widget.posts.docId).update({"like":widget.posts.likes});
} catch (e) {
}

  }


  @override
  Widget build(BuildContext context) {
    return Container(
  
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: InkWell(
        onTap: (){
       
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => View(posts: widget.posts),
          ));
        },
        onDoubleTap: (){
          if(FirebaseAuth.instance.currentUser==null){
            return;
          }
          //Likes 
          addLike();
        },


        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.all(7),
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Text(readTimestamp(widget.posts.timestamp),style: TextStyle(fontWeight: FontWeight.bold),))
                ,Expanded(child: Text(widget.posts.views.length.toString()+" views",style: TextStyle(fontWeight: FontWeight.bold),))


              ],
            ),
            ),
       Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
             Center(child: SizedBox(
            height: 90,
            width: 90,
            
            child: Image.network(widget.posts.url, fit: BoxFit.cover,),
          )),
  Column(
    children: [
        if(user==null)
       IconButton(icon:Icon(Icons.favorite, color: Colors.red,),onPressed: (){},),
      if(user!=null)
      IconButton(icon:widget.posts.likes.contains(user.uid)? Icon(Icons.favorite, color: Colors.red,): Icon(Icons.favorite_border, color: Colors.red,),
              onPressed: (){addLike();}),
            Text("${widget.posts.likes.length}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:16),),
         ],
  )
  
         ],
       )
  ,
         
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
           
         
           Expanded(child: RaisedButton(onPressed: (){
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => Visit(uid: widget.posts.uid,),
            ));


           },
           color: Colors.blue[900],
           
           child: Text("Hire me",style: TextStyle(color:Colors.white,fontSize:15),),))

             
           ],
         )  ,
        
     
      ],),
      
      )
    );
  }
}