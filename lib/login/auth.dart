import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseMessaging fcm = FirebaseMessaging();
String token;
Future<String> signInWithGoogle() async {
  // Trigger the authentication flow
  await fcm.getToken().then((value) {
    token = value;
  });
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount == null) return null;
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  if (googleSignInAccount == null) return null;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  if (credential == null) {
    return null;
  }
  final UserCredential authResult = await auth.signInWithCredential(credential);

  final User user = authResult.user;
  if (user != null) {
    //assert(!user.isAnonymous);
    // assert(await user.getIdToken() != null);
    final User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((value) {
      if (value.exists) {
         FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({"userName":currentUser.displayName,
         "userProfile":currentUser.photoURL, "token":token}
      );

      } else {
     
          UserModel model=new UserModel(
          uid: user.uid,
          userName: currentUser.displayName,
          userProfile: currentUser.photoURL,
          token: token,);

        FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set(model.toMap()
      );
      }
    });

    return '$user';
  }

  // Once signed in, return the UserCredential
  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print('User signed out');
}
class UserModel{
  String uid;
  String userName;
  String userProfile;
  String token;
  UserModel({this.uid,this.userName,this.userProfile,this.token});
  Map<String,dynamic> toMap()=>{
    "uid":uid,
    "userName":userName,
    "userProfile":userProfile,
    "token":token
  };
}