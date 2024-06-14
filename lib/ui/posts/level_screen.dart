import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/ui/posts/level1/quizzes_screen.dart' as level1;
import 'package:asaf/ui/posts/level2/quizzes_screen.dart' as level2;
import 'package:asaf/ui/posts/level3/quizzes_screen.dart' as level3;
import 'package:asaf/ui/posts/level4/quizzes_screen.dart' as level4;
import 'package:asaf/ui/posts/level5/quizzes_screen.dart' as level5;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:asaf/ui/posts/level1/quiz_data.dart' as data1;
import 'package:asaf/ui/posts/level2/quiz_data.dart' as data2;
import 'package:asaf/ui/posts/level3/quiz_data.dart' as data3;
import 'package:asaf/ui/posts/level4/quiz_data.dart' as data4;
import 'package:asaf/ui/posts/level5/quiz_data.dart' as data5;
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int completedQuizzesCount = 0;
  int level2Count = 0;
  int level3Count = 0;
  int level4Count = 0;
  int level5Count = 0;

  get message => '';

  Color getProgressColor(double percentage) {
    if (percentage < 0.45) {
      return Colors.red;
    } else if (percentage < 0.75) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();

    fetchCompletedUserQuizzes().then((count) {
      setState(() {
        completedQuizzesCount = count;
      });
    }).catchError((error) {
      print('Error fetching completed quizzes count: $error');
    });
    level2count().then((count2) {
      setState(() {
        level2Count = count2;
      });
    }).catchError((error) {
      print('Error fetching completed quizzes count: $error');
    });
    level3count().then((count3) {
      setState(() {
        level3Count = count3;
      });
    }).catchError((error) {
      print('Error fetching completed quizzes count: $error');
    });
    level4count().then((count4) {
      setState(() {
        level4Count = count4;
      });
    }).catchError((error) {
      print('Error fetching completed quizzes count: $error');
    });
    level5count().then((count5) {
      setState(() {
        level5Count = count5;
      });
    }).catchError((error) {
      print('Error fetching completed quizzes count: $error');
    });
  }

  // Initialize other level instances here

  Future<int> fetchCompletedUserQuizzes() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        int completedQuizzesCount = 0;

        for (var quiz1 in data1.quizzes) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(quiz1.level)
              .doc(quiz1.quizId)
              .get();

          if (userDoc.exists) {
            bool? quizCompleted = userDoc.get('isCompleted') as bool?;

            if (quizCompleted == true) {
              completedQuizzesCount++;
            }
          } else {
            // Document doesn't exist, terminate the loop
            break;
          }
        }

        return completedQuizzesCount;
      }
      return 0; // Return 0 if user is null
    } catch (e) {
      print('Error fetching completed user quizzes: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<int> level2count() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        int level1Count = 0;

        for (var quiz2 in data2.quizzes) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(quiz2.level)
              .doc(quiz2.quizId)
              .get();

          if (userDoc.exists) {
            bool? quizCompleted = userDoc.get('isCompleted') as bool?;

            if (quizCompleted == true) {
              level1Count++;
            }
          } else {
            // Document doesn't exist, terminate the loop
            break;
          }
        }

        return level1Count;
      }
      return 0; // Return 0 if user is null
    } catch (e) {
      print('Error fetching completed user quizzes: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<int> level3count() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        int level3Count = 0;

        for (var quiz3 in data3.quizzes) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(quiz3.level)
              .doc(quiz3.quizId)
              .get();

          if (userDoc.exists) {
            bool? quizCompleted = userDoc.get('isCompleted') as bool?;

            if (quizCompleted == true) {
              level3Count++;
            }
          } else {
            // Document doesn't exist, terminate the loop
            break;
          }
        }

        return level3Count;
      }
      return 0; // Return 0 if user is null
    } catch (e) {
      print('Error fetching completed user quizzes: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<int> level4count() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        int level4Count = 0;

        for (var quiz4 in data4.quizzes) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(quiz4.level)
              .doc(quiz4.quizId)
              .get();

          if (userDoc.exists) {
            bool? quizCompleted = userDoc.get('isCompleted') as bool?;

            if (quizCompleted == true) {
              level4Count++;
            }
          } else {
            // Document doesn't exist, terminate the loop
            break;
          }
        }

        return level4Count;
      }
      return 0; // Return 0 if user is null
    } catch (e) {
      print('Error fetching completed user quizzes: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<int> level5count() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        int level5Count = 0;

        for (var quiz5 in data5.quizzes) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(quiz5.level)
              .doc(quiz5.quizId)
              .get();

          if (userDoc.exists) {
            bool? quizCompleted = userDoc.get('isCompleted') as bool?;

            if (quizCompleted == true) {
              level5Count++;
            }
          } else {
            // Document doesn't exist, terminate the loop
            break;
          }
        }

        return level5Count;
      }
      return 0; // Return 0 if user is null
    } catch (e) {
      print('Error fetching completed user quizzes: $e');
      return 0; // Return 0 in case of an error
    }
  }

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
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
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
              'Levels',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.home,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 39, vertical: 27),
                  child: Text(
                    'Islamic Quiz',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open_Sans',
                      letterSpacing: 0.8,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            // Wrap Icon and Text in a Row
                            children: [
                              Icon(Icons.stairs_rounded,
                                  size: 40, color: Colors.white54),
                              SizedBox(
                                  width:
                                      10), // Add some spacing between Icon and Text
                              Text(
                                'Level 1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            animation: true, // Enable animation
                            animationDuration:
                                1000, // Animation duration in milliseconds
                            lineHeight: 8.0,
                            barRadius: const Radius.circular(20),

                            percent: completedQuizzesCount /
                                10, // Specify the percentage to show

                            progressColor: getProgressColor(
                              completedQuizzesCount / 10,
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
                                      const level1.QuizzesScreen(),
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
                                      const Duration(milliseconds: 600),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(completedQuizzesCount * (10)).toInt()}% Complete',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            // Wrap Icon and Text in a Row
                            children: [
                              Icon(Icons.stairs_rounded,
                                  size: 40, color: Colors.white54),
                              SizedBox(
                                  width:
                                      10), // Add some spacing between Icon and Text
                              Text(
                                'Level 2',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            animation: true, // Enable animation
                            animationDuration:
                                1000, // Animation duration in milliseconds
                            lineHeight: 8.0,
                            barRadius: const Radius.circular(20),

                            percent: level2Count /
                                10, // Specify the percentage to show

                            progressColor: getProgressColor(level2Count / 10),
                          ),
                          const SizedBox(height: 10),
                          if (completedQuizzesCount == 10)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque:
                                        false, // Set to false to make the new route transparent
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const level2.QuizzesScreen(),
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
                                        const Duration(milliseconds: 600),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(level2Count * 100).toInt()}% Complete',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            // Wrap Icon and Text in a Row
                            children: [
                              Icon(Icons.stairs_rounded,
                                  size: 40, color: Colors.white54),
                              SizedBox(
                                  width:
                                      10), // Add some spacing between Icon and Text
                              Text(
                                'Level 3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            animation: true, // Enable animation
                            animationDuration:
                                1000, // Animation duration in milliseconds
                            lineHeight: 8.0,
                            barRadius: const Radius.circular(20),

                            percent: level3Count /
                                10, // Specify the percentage to show

                            progressColor: getProgressColor(level3Count / 10),
                          ),
                          const SizedBox(height: 10),
                          if (level2Count == 10)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque:
                                        false, // Set to false to make the new route transparent
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const level3.QuizzesScreen(),
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
                                        const Duration(milliseconds: 600),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(level3Count * 10).toInt()}% Complete',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            // Wrap Icon and Text in a Row
                            children: [
                              Icon(Icons.stairs_rounded,
                                  size: 40, color: Colors.white54),
                              SizedBox(
                                  width:
                                      10), // Add some spacing between Icon and Text
                              Text(
                                'Level 4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            animation: true, // Enable animation
                            animationDuration:
                                1000, // Animation duration in milliseconds
                            lineHeight: 8.0,
                            barRadius: const Radius.circular(20),

                            percent: level4Count /
                                10, // Specify the percentage to show

                            progressColor: getProgressColor(level4Count / 10),
                          ),
                          const SizedBox(height: 10),
                          if (level3Count == 10)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque:
                                        false, // Set to false to make the new route transparent
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const level4.QuizzesScreen(),
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
                                        const Duration(milliseconds: 600),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(level4Count * 10).toInt()}% Complete',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            // Wrap Icon and Text in a Row
                            children: [
                              Icon(Icons.stairs_rounded,
                                  size: 40, color: Colors.white54),
                              SizedBox(
                                  width:
                                      10), // Add some spacing between Icon and Text
                              Text(
                                'Level 5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            animation: true, // Enable animation
                            animationDuration:
                                1000, // Animation duration in milliseconds
                            lineHeight: 8.0,
                            barRadius: const Radius.circular(20),

                            percent: level5Count /
                                10, // Specify the percentage to show

                            progressColor: getProgressColor(level5Count / 10),
                          ),
                          const SizedBox(height: 10),
                          if (level5Count == 10)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque:
                                        false, // Set to false to make the new route transparent
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const level5.QuizzesScreen(),
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
                                        const Duration(milliseconds: 600),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(level5Count * 10).toInt()}% Complete',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
