import 'package:asaf/ui/posts/level_screen.dart';
import 'package:asaf/ui/posts/sidebar/admin.dart';
import 'package:asaf/ui/posts/sidebar/drawer_list.dart';
import 'package:asaf/ui/posts/sidebar/my_header.dart';
import 'package:asaf/ui/posts/sidebar/notification_services.dart';
import 'package:asaf/ui/posts/sidebar/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double scaleFactor = 1;
  bool isVisible = true;
  double completionPercentage = 0.0;
  String greeting = '';
  String message = '';
  String gender = '';

  String dateOfBirth = '';
  String email = '';
  String phoneno = '';
  String imageurl = '';

  @override
  void initState() {
    super.initState();
    initializeGreeting();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.foregroundMessage();
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print('Device Token');
      print(value);
    });

    // Initialize the greeting
  }

  void initializeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        greeting = 'Good Morning';
      });
    } else if (hour < 17) {
      setState(() {
        greeting = 'Good Afternoon';
      });
    } else {
      setState(() {
        greeting = 'Good Evening';
      });
    }

    // Fetch user name from Firebase
    fetchUserName();
  }

  void fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String userName = userSnapshot.get('aname');
        String emaill = userSnapshot.get('bemail') ?? 'Email';
        String phoneNo = userSnapshot.get('cphoneno') ?? 'Phone No';
        String genderr = userSnapshot.get('dgender') ?? 'Gender';

        String dateOfBirthh =
            userSnapshot.get('fdateofbirth') ?? 'Date of Birth';

        String url = userSnapshot.get('gprofileImageUrl');

        setState(() {
          message = userName;
          gender = genderr;
          email = emaill;
          phoneno = phoneNo;

          dateOfBirth = dateOfBirthh;
          imageurl = url;
        });
      }
    } catch (e) {
      print("Error fetching user name: $e");
      // Handle the error here, such as displaying an error message to the user.
    }
  }

  Color getProgressColor(double percentage) {
    if (percentage < 0.45) {
      return Colors.red;
    } else if (percentage < 0.75) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 105, 160, 205), // You can replace this with your desired color
    ));
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
            leading: Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: const Text(
              'Home',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          UserProfile(
                        message: message,
                        gender: gender,
                        phoneno: phoneno,
                        email: email,
                        dateOfBirth: dateOfBirth,
                        imageurl: imageurl,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var scaleAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutExpo,
                          ),
                        );

                        var fadeAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(animation);

                        // Adjust the alignment for the desired center point
                        var alignment = Alignment.center;

                        return FadeTransition(
                          opacity: fadeAnimation,
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            alignment: alignment,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: buildAvatar(imageurl),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                myHeaderDrawer(message, imageurl),
                if (email == 'moazzamr157@gmail.com' ||
                    email == 'adeel.siddiqui38@gmail.com')
                  adminDrawerList(context, message, gender, email, dateOfBirth, phoneno,
                      imageurl),
                if (email != 'moazzamr157@gmail.com' &&
                    email != 'adeel.siddiqui38@gmail.com')
                  myDrawerList(context, message, gender, email, phoneno,
                      dateOfBirth, imageurl),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context)
                  .size
                  .height, // Set the container's height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    child: Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open_Sans',
                        letterSpacing: 0.9,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 39, vertical: 0),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open_Sans',
                        letterSpacing: 0.8,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Center(
                    child: Transform.scale(
                      scale: scaleFactor,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 50),
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 106, 190, 235),
                              Color.fromARGB(255, 78, 118, 151)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: const Offset(1, 5),
                            ),
                          ],
                        ),
                        child: Visibility(
                          visible: isVisible,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.mosque,
                                    size: 70, color: Colors.white54),
                                const SizedBox(height: 16),
                                const Text(
                                  'Islamic Quiz',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Complete the quiz to learn more',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: completionPercentage,
                                  backgroundColor:
                                      const Color.fromARGB(255, 219, 202, 202)
                                          .withOpacity(0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    getProgressColor(
                                        completionPercentage), // Apply color based on percentage
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque:
                                            false, // Set to false to make the new route transparent
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const LevelScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var scaleAnimation = Tween<double>(
                                            begin: 0.0,
                                            end: 1.0,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOutExpo,
                                            ),
                                          );

                                          var fadeAnimation = Tween<double>(
                                            begin: 0.0,
                                            end: 1.0,
                                          ).animate(animation);

                                          // Adjust the alignment for the desired center point
                                          var alignment = Alignment.center;

                                          return FadeTransition(
                                            opacity: fadeAnimation,
                                            child: ScaleTransition(
                                              scale: scaleAnimation,
                                              alignment: alignment,
                                              child: child,
                                            ),
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 1000),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Hero(
                      tag: 'wid1Hero',
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 10),
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 106, 190, 235),
                              Color.fromARGB(255, 78, 118, 151),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: const Offset(1, 5),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.more_horiz,
                                  size: 70, color: Colors.white54),
                              SizedBox(height: 16),
                              Text(
                                'More to Come',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Stay connected',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildAvatar(String imageurl) {
  if (imageurl != 'null') {
    // Show CircleAvatar with background image using caching
    return CircleAvatar(
      key: UniqueKey(),
      radius: 20,
      backgroundImage: CachedNetworkImageProvider(imageurl),
      //placeholder: (context, url) => CircularProgressIndicator(), // Placeholder widget while loading
      //errorWidget: (context, url, error) => Icon(Icons.error), // Widget displayed on error
    );
  } else {
    // Show CircleAvatar with default icon
    return const CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('assets/usericon.jpg'),
    );
  } 
}
