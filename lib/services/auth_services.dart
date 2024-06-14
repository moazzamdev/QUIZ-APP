import 'package:asaf/ui/posts/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser != null) {
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        // Show loading spinner
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SpinKitChasingDots(
              color: Colors.blue, // Customize color if needed
              size: 50.0, // Customize size if needed
            );
          },
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          // Save user information to Firestore
          DateTime signUpDate = DateTime.now();
          int signUpYear = signUpDate.year;
          await _firestore.collection('users').doc(user.uid).set({
            'aname': user.displayName,
            'bemail': user.email,
            'cphoneno': 'Phone No',
            'dgender': 'Gender',
            'ereligion': 'Religion',
            'fdateofbirth': 'YY-MM-DD',
            'gprofileImageUrl': user.photoURL,
            'signupdate': signUpDate.toLocal(),
            'signupyear': signUpYear,
          });

          // Delay navigation for 2 seconds
          await Future.delayed(Duration(seconds: 2));

          // Close the loading spinner dialog
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: 'Signed in as ${user.displayName}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }
}
