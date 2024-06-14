import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/ui/posts/level_screen.dart';
import 'package:asaf/ui/posts/level5/quiz_data.dart';
import 'package:asaf/ui/posts/level5/quiz_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const MaterialApp(
    home: QuizzesScreen(),
  ));
}

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({Key? key}) : super(key: key);

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  double completionPercentage = 0.0;
  bool isFirstQuizCompleted = false;
  bool renderedIncompleteQuiz = false;
  late Future<void> quizzesFuture;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SpinKitChasingDots(
              color: Colors.blue,
              size: 50.0,
            ),
          );
        },
      );
    });

    quizzesFuture = fetchUserScores();

    quizzesFuture.then((_) {
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  Future<void> fetchUserScores() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<QuizInfo> updatedQuizzes = [];

        for (var quiz in quizzes) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(quiz.level)
              .doc(quiz.quizId)
              .get();

          int? userScore = userDoc.get('score') as int?;
          bool? quizCompleted = userDoc.get('isCompleted') as bool?;

          if (userScore != null && quizCompleted != null) {
            quiz.score = userScore;
            quiz.isCompleted = quizCompleted;
            updatedQuizzes.add(quiz);
          } else {
            break;
          }
        }

        // Update the `quizzes` list and set `renderedIncompleteQuiz` if needed
        setState(() {
          quizzes = updatedQuizzes;
          renderedIncompleteQuiz = !quizzes.every((quiz) => quiz.isCompleted);
        });
      }
    } catch (e) {
      print('Error fetching user scores: $e');
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: quizzesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return MaterialApp(
              home: Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(70),
                    child: AppBar(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(
                              150), // Adjust the radius as needed
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 105, 160, 205),
                      elevation: 8,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LevelScreen()),
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
                        'Level 2',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontFamily: 'Open_Sans',
                            fontSize: 22),
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DashboardScreen()),
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
                      child: RefreshIndicator(
                          onRefresh: () => fetchUserScores(),
                          child: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return const QuizzesScreen();
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOutExpo;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration:
                                          const Duration(milliseconds: 600),
                                    ),
                                  );
                                  fetchUserScores();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 39, vertical: 27),
                                  child: Text(
                                    'Islamic Quiz\nLevel 5',
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
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [],
                              ),
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: (() {
                                  List<Widget> widgets = [];

                                  for (var quiz in quizzes) {
                                    if (quiz.isCompleted) {
                                      widgets.add(_buildQuizContainer(quiz));
                                    }
                                    if (!quiz.isCompleted) {
                                      widgets.add(_buildQuizContainer(quiz));
                                      break; // Add only the first incomplete quiz
                                    }
                                  }

                                  return widgets;
                                })(),
                              ),
                              const SizedBox(
                                height: 500,
                              )
                            ],
                          ))))));
        }
      },
    );
  }

  Widget _buildQuizContainer(QuizInfo quiz) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(quiz: quiz),
          ),
        ).then((value) {
          if (value == true) {
            // Refresh the data when returning from QuizScreen
            fetchUserScores();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        width: 148,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 106, 190, 235),
              Color.fromARGB(255, 72, 114, 149)
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
              Row(
                children: [
                  const Icon(Icons.quiz, size: 30, color: Colors.white54),
                  const SizedBox(width: 10),
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 8.0,
                barRadius: const Radius.circular(20),
                percent: quiz.score / 10.0,
                progressColor: getProgressColor(quiz.score / 10.0),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(quiz.score / 10.0 * 100).toInt()}% Scored',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  // Only show play button if there's a score
                  if (quiz.score >= 50)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizScreen(quiz: quiz), // Pass the quiz info
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                  if (quiz.score == 0)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizScreen(quiz: quiz), // Pass the quiz info
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Level5Value {
  int completedQuizCount = quizzes.where((quiz) => quiz.isCompleted).length;
}
