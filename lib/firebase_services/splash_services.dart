import 'dart:async';

import 'package:asaf/ui/auth/login_screen.dart';
import 'package:asaf/ui/posts/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var slideAnimation = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves
                      .easeOutCubic, // You can adjust the curve for desired easing
                ),
              );

              return SlideTransition(
                position: slideAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(
                milliseconds:
                    800), // Adjust the duration for a slower animation
          ),
        ),
      );
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }
}
