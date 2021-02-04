import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsup/Databasemethod/database_Method.dart';
import 'package:whatsup/Functions/sharedPreferenceStoreUserDetails.dart';
import 'package:whatsup/Screens/Home/home.dart';

class AuthMethods {
  Future<bool> login(String email, String passWord) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passWord);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User userDetails = result.user;

    SharedPreferenceStoreUserDetails obj = SharedPreferenceStoreUserDetails();

    if (result != null) {
      obj.saveUserEmail(userDetails.email);
      obj.saveUserId(userDetails.uid);
      obj.saveUserName(userDetails.email.replaceAll('@gmail.com', ''));
      obj.saveDisplayName(userDetails.displayName);
      obj.saveUserProfileUrl(userDetails.photoURL);

      Map<String, dynamic> userInfoMap = {
        'email': userDetails.email,
        'username': userDetails.email.replaceAll('@gmail.com', ''),
        'name': userDetails.displayName,
        'imageUrl': userDetails.photoURL
      };

      DatabaseMethods().addUserInfoToDB(userDetails.uid, userInfoMap).then(
          (value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home())));
    }
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
