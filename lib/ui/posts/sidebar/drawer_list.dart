import 'package:asaf/ui/auth/login_screen.dart';
import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/ui/posts/sidebar/chatbot.dart';
import 'package:asaf/ui/posts/sidebar/menu_widget.dart';
import 'package:asaf/ui/posts/sidebar/notification_screen.dart';
import 'package:asaf/ui/posts/sidebar/reset_password.dart';
import 'package:asaf/ui/posts/sidebar/settings.dart';
import 'package:asaf/ui/posts/sidebar/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';

Future signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } catch (e) {
    print('Error during sign out: $e');
    return false;
  }
}

Widget myDrawerList(BuildContext context, String userName, String gender,
    String email, String dateOfBirth, String phoneno, String imageurl) {
  return Container(
    padding: const EdgeInsets.only(
      top: 15,
    ),
    child: Column(
      // shows the list of menu drawer
      children: [
        ProfileMenuWidget(
            title: "Home",
            icon: Ionicons.home,
            onPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            }),
        const SizedBox(
          height: 5,
        ),
        ProfileMenuWidget(
            title: "Settings",
            icon: Ionicons.settings,
            onPress: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SetttingScreen(),
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
              );
            }),
        const SizedBox(
          height: 5,
        ),
        ProfileMenuWidget(
            title: "Profile",
            icon: Ionicons.person,
            onPress: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UserProfile(
                    message: userName,
                    gender: gender,
                    email: email,
                    phoneno: phoneno,
                    dateOfBirth: dateOfBirth,
                    imageurl: imageurl,
                  ),
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
              );
            }),
        const SizedBox(
          height: 5,
        ),
        ProfileMenuWidget(
            title: "Chatbot",
            icon: Ionicons.chatbubble,
            onPress: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Chatbot(),
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
              );
            }),
        const SizedBox(
          height: 5,
        ),
        ProfileMenuWidget(
            title: "Notifications",
            icon: Ionicons.notifications,
            onPress: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      NotificationScreen(),
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
              );
            }),
        const SizedBox(
          height: 5,
        ),
        ProfileMenuWidget(
            title: "Password Reset",
            icon: Ionicons.lock_closed,
            onPress: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ResetPassword(),
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
              );
            }),
        const Divider(
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        ProfileMenuWidget(
          title: "Logout",
          icon: Ionicons.log_out,
          onPress: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: const Center(
                    child: SpinKitChasingDots(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  ),
                );
              },
            );

            bool loggedOut = await signOut();

            // Delay the closure of the dialog for 2 seconds
            await Future.delayed(const Duration(seconds: 2));

            Navigator.pop(context); // Close the spinner dialog

            if (loggedOut) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },
        )
      ],
    ),
  );
}
