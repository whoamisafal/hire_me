import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/home/post.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db=FirebaseFirestore.instance.collection("post");
  bool isLoading=true;
  List<Posts> posts=[];
  @override
  void initState() {
   try {
     fetchDesigns();
   } catch (e) {
   }finally{
     if(mounted){
       setState(() {
         isLoading=false;
       });
     }
   }
    super.initState();
  }
  void fetchDesigns(){

    db.snapshots().listen((event) {
      posts.clear();
        if(mounted){
          setState(() {
            for (var item in event.docs) {


              Map<String,dynamic> data=item.data();
              var d=new Posts(likes: data["like"], views: data["views"],
               uid: data["uid"], rating: data["rating"],
               timestamp: data["timestamp"],
               docId: item.id,
                url:data["url"], path: data["filepath"], title: data["title"]);
                posts.add(d);
                isLoading=false;

              
            }
          });
        }


     });




  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(
      child: CircularProgressIndicator(),
    ):posts.length==0?Center(child: Text("No posts"),): GridView.builder(
      physics: ClampingScrollPhysics(),
     itemCount: posts.length,
     shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
    

        crossAxisCount:2
      ),
      itemBuilder: (context, index) {
        return PostView(posts: posts[index],);
      },
      
    );
  }
}

class Posts{

  List<dynamic> likes;
  List<dynamic> views;
  String uid;
  dynamic rating;
  String url;
  String path;
  String title;
  int timestamp;
  String docId;

  Posts({@required this.likes,@required this.views,
  @required this.uid,
  @required this.timestamp,
  @required this.docId,
  @required this.rating,@required this.url,@required this.path,@required this.title});




}