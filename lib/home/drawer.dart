import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/login/RegisterHelper.dart';
import 'package:hire_me/login/auth.dart';

class DrawerMenu extends StatefulWidget {
  final VoidCallback onselected;
  final Function(bool) onselectedChanged;
  DrawerMenu({this.onselected,@required this.onselectedChanged});



  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  var user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(child: Image.asset("assets/bird2.png", fit: BoxFit.cover,), ),
        if(user!=null)
        ListTile(
          onTap: (){
              Navigator.of(context).pop(true);
            showDialog(context: context,
            barrierDismissible: false,
            builder: (context) => NewPost(),);
          
          },
          title: Text("New post"),
        ),
        if(user!=null)
        ListTile(
          title: Text("Log out"),
          onTap: (){
              if(mounted){
                setState(() {
                  widget.onselectedChanged(true);
                  user=null;
                  signOutGoogle();
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(true);
                  
                });
              }
          },

        )


 ,if(user==null)
        ListTile(
          title: Text("Register"),
          onTap: (){
            Navigator.of(context).pop(true);
             showDialog(context: context, 
             builder: (context) => RegisterHelper(),
             );
          },

        )
      ],
      
    );
  }
}

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
bool isReady=false;
  TextEditingController subject=TextEditingController();
    File selectedFile;
   StorageReference ref;  
    String url="";
    bool isProgress=false;
    double taskComplete=0;
    String fileName="";
    String title="";


    void pickFile() async {
    print("PickFile");
    File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['png']);

    if (mounted) {
      if (file != null) {
        setState(() {
          selectedFile=file;
          uploadFile();
         
        });
      }
    }
  }
  void uploadFile()async{
  if(mounted){
    setState(() {
      fileName=DateTime.now().millisecondsSinceEpoch.toString()+".png";
    });
  }
  Fluttertoast.showToast(msg: "Upload start");
  ref =FirebaseStorage.instance.ref().
  child("design").
  child("$fileName");
  StorageUploadTask task= ref.putFile(selectedFile);
  task.events.listen((event) { 
    if(mounted){
      setState(() {
        isProgress=true;
           taskComplete = _bytesTransferred(event.snapshot);
      });
    }

  });


 await task.onComplete.then((snap) {
   if(mounted){
     setState(() {
       isReady=true;
     });
    snap.ref.getDownloadURL().then((url) {
      if(mounted){
        setState(() {
          this.url=url;
        });
      }
    });
   }
 });
}
  double _bytesTransferred(StorageTaskSnapshot task) {
    return (task.bytesTransferred * 100) / task.totalByteCount;
  }

  void post(){
    List<dynamic> likes=[];
    FirebaseFirestore.instance.collection("post").doc().set({
      "uid":FirebaseAuth.instance.currentUser.uid,
      "filepath":fileName,
      "like":likes,
      "title":title,
      "timestamp":DateTime.now().millisecondsSinceEpoch,
      "rating":0,
      "views":likes,
      "url":url
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: new Offset(0,0),
      child: AlertDialog(
        title: Text("New post"),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.5,
          child: Column(
         
            children: [
              //Title
              Container(
               padding: EdgeInsets.only(left:25),
                decoration: BoxDecoration(border:Border.all()),
                 
                child: TextField(
                  onChanged: (val){
                      if(mounted){
                        setState(() {
                          title=val;
                        });
                      }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none
                    , hintText: "title"
                  ),
                ),
              )
           
              //Drop image
                ,if(url.isEmpty)
              Expanded(
                
                child: Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    top: 60,
                    child: Container(
                      height: 50,
                      width: 250,
                    
                    child:InkWell(
                      onTap: (){
                        
                        pickFile();
                      },
                      child:Center(child: Text("Drop files here")
                      ),
                    
                    ),
                    
                    )
)
                ],
              ))
               , 
                 if(url.isNotEmpty)
               Expanded(child: Stack(

                 children: [
                 
                   Image.file(selectedFile)

                   , if(url.isNotEmpty)
                   IconButton(icon: Icon(Icons.clear),onPressed: (){
            FirebaseStorage.instance.ref().child("design").child("$fileName").delete().then((value){
         if(mounted){
           setState(() {
              isReady=false;
          isProgress=false;
          url="";
          subject.clear();
           });
         }

              } );
                   },)


                 ],
               ))
           
            //Post

            , 
            if(isReady && title.isNotEmpty)
            RaisedButton(onPressed: (){
              post();
              Navigator.of(context).pop();

            },child: Text("Post",style: TextStyle(color: Colors.white),),color: Colors.blue,)
            
            
            ],
          ),
        ),
    actions: [
      if(url.isEmpty)
      RaisedButton(onPressed: (){Navigator.of(context).pop(true);},color: Colors.blue,child: Text("Close"),)

    ],
    
    ),

    );
  }
}