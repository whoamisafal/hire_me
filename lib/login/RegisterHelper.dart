



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/home/home.dart';
import 'package:hire_me/login/auth.dart';

class RegisterHelper extends StatefulWidget {
  @override
  _RegisterHelperState createState() => _RegisterHelperState();
}

class _RegisterHelperState extends State<RegisterHelper> {
 
 

  @override
  void initState() {


    super.initState();
  }

@override
  void dispose() {
 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Login"),
        content:
          Container(

            child: RaisedButton(onPressed: ()async{
              await signInWithGoogle().then((result) {
                      if (result != null) {
                        Fluttertoast.showToast(
                            msg: "Login Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context)
                            .pushReplacement(new MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                      }
                    });
              
            },
            color: Colors.blue[800]
            ,child: Text("Login with google account",style:TextStyle(color:Colors.white,fontSize:16)),),
          ),





  
     
    );
  }
}