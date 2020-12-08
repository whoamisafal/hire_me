

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/home/home.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        theme: ThemeData(
        indicatorColor: Colors.red,
      
         
       
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin{
  FirebaseAuth auth=FirebaseAuth.instance;
  AnimationController controller;
  double pos=0;
  double nextPos=0;
@override
  void initState() {
   Future.delayed(Duration(seconds: 1),(){
        controller=new AnimationController(
        vsync: this,
        duration: const Duration(seconds:3 )
      )..addListener(() {
        
        
            setState(() {
            if(pos<MediaQuery.of(context).size.width*0.5)
                pos+=controller.value.toDouble()*100;
                else
          if(nextPos<MediaQuery.of(context).size.width*0.5)
                nextPos+=controller.value.toDouble()*30;
          
            });
         
      });
       controller.forward();
   });
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => Home(),));


   });
    super.initState();
  }

@override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
        child: Scaffold(
          body: Container(
            child: Stack(
              children: [
               
                 

            ],),
          ),
        ),
        

 
      
    );
  }
}