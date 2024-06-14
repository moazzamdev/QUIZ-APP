import 'package:asaf/ui/auth/login_screen.dart';
import 'package:asaf/ui/posts/sidebar/settingScreens/help_center.dart';
import 'package:asaf/ui/posts/sidebar/settingScreens/privacy_screen.dart';
import 'package:asaf/ui/posts/sidebar/settingScreens/terms_screen.dart';
import 'package:asaf/ui/posts/sidebar/setting_widget.dart';
import 'package:asaf/ui/posts/sidebar/toggle_widget.dart';
import 'package:asaf/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SetttingScreen extends StatefulWidget {
  const SetttingScreen({super.key});

  @override
  State<SetttingScreen> createState() => _SetttingScreenState();
}

class _SetttingScreenState extends State<SetttingScreen> {
  String email = '';
  dynamic signUpDate = '';
  int signUpYear = 0;
  String formattedDate = '';
  bool endIconState = true;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print('Error during sign out: $e');
      return false;
    }
  }

  void fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String emaill = userSnapshot.get('bemail') ?? 'Email';
        DateTime dateTime = userSnapshot.get('signupdate').toDate();
        int year = userSnapshot.get('signupyear');

        final monthAbbreviations = {
          1: 'Jan',
          2: 'Feb',
          3: 'Mar',
          4: 'Apr',
          5: 'May',
          6: 'Jun',
          7: 'Jul',
          8: 'Aug',
          9: 'Sep',
          10: 'Oct',
          11: 'Nov',
          12: 'Dec'
        };

        formattedDate = '${monthAbbreviations[dateTime.month]}-${dateTime.day}';

        setState(() {
          email = emaill;
          signUpDate = formattedDate;
          signUpYear = year;
        });
      }
    } catch (e) {
      print("Error fetching user name: $e");
      // Handle the error here, such as displaying an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(150), // Adjust the radius as needed
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 105, 160, 205),
            elevation: 8,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.arrow_circle_left_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            centerTitle: true,
            title: const Text(
              'Settings',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align children to the left
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20), // Adjust the left padding as needed
                  child: Text(
                    'Account',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                ProfileMenuWidget1(
                  title: 'Email\n$email',
                  icon: Icons.mail,
                  onPress: () {},
                ),
                SizedBox(height: 10),
                ProfileMenuWidget1(
                  title: 'Joined\n$formattedDate,$signUpYear',
                  icon: Icons.join_full,
                  onPress: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20), // Adjust the left padding as needed
                  child: Text(
                    'App',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                ProfileMenuWidget2(
                    title: 'Notifications',
                    icon: Icons.notifications,
                    onPress: () {}),
                SizedBox(height: 10),
                ProfileMenuWidget2(
                    title: 'Save Data', icon: Icons.save, onPress: () {}),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20), // Adjust the left padding as needed
                  child: Text(
                    'About',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                ProfileMenuWidget1(
                  title: 'Help Center',
                  icon: Icons.help_center,
                  onPress: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            HelpCenterScreen(),
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
                  },
                ),
                SizedBox(height: 10),
                ProfileMenuWidget1(
                  title: 'Terms of Use',
                  icon: Icons.note,
                  onPress: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            TermsOfUseScreen(),
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
                  },
                ),
                SizedBox(height: 10),
                ProfileMenuWidget1(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip,
                  onPress: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            PrivacyPolicyScreen(),
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
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20), // Adjust the left padding as needed
                  child: Text(
                    'Manage',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                ProfileMenuWidget1(
                  title: 'Sign out',
                  icon: Icons.logout,
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
                ),
                SizedBox(height: 10),
                ProfileMenuWidget1(
                  title: 'Delete Account',
                  icon: Icons.delete,
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
                    await deleteCurrentUserAndData();
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> deleteCurrentUserAndData() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Step 1: Delete user account
      await currentUser.delete();

      // Step 2: Delete Firestore data
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(currentUser.uid).delete();

      // Step 3: Delete Storage data (optional, only if you're using Firebase Storage)
      final storage = FirebaseStorage.instance;
      await storage.ref().child('images/${currentUser.uid}').delete();

      // Optionally, you can also sign out the user.
      await FirebaseAuth.instance.signOut();

      // The user account, Firestore data, and Storage data (if applicable) have been deleted.
    } else {
      // No user is currently signed in.
    }
  } catch (error) {
    print('Error deleting user and data: $error');
    Utils().toastMessage('Error deleting your account. Login again');
    // Handle errors here
  }
}
