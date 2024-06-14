import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/ui/posts/level3/quiz_data.dart' as level3;
import 'package:asaf/ui/posts/level3/quizzes_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final level3.QuizInfo quiz; // Add the parameter

  const QuizScreen({required this.quiz});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  late level3.QuizInfo quiz;
  Timer? _countdownTimer;
  bool isTimerExpired = false;
  int remainingSeconds = 600;
  bool isTimerDialogShown = false;
  bool isTimerStarted = false;
  bool isAnswerCorrect = false;
  int currentQuestionIndex = 0;
  int score = 0;
  bool quizCompleted = false;
  //String explanation = '';
  String? selectedOption;
  String? explanationText;
  int totalQuestions = 10; // Adjust this to the total number of questions

  @override
  void dispose() {
    _countdownTimer?.cancel(); // Cancel the timer if it's still active
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    quiz = widget.quiz;
    fetchRandomQuestions();
  }

  void startTimer() {
    const tenMinutes = Duration(minutes: 10);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds = tenMinutes.inSeconds - timer.tick;
        if (remainingSeconds <= 0) {
          timer.cancel();
          isTimerExpired = true;
          moveToNextQuestion();
        }
      });
    });
    setState(() {
      isTimerStarted = true; // Set the timer started flag
    });
  }

  void fetchRandomQuestions() async {
    questions = [];

    QuerySnapshot questionSnapshot =
        await FirebaseFirestore.instance.collection(quiz.quizId).get();

    List<Question> allQuestions = questionSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Question(
        questionText: data['questionText'].toString(),
        options: List<dynamic>.from(data['options']),
        correctOption: data['correctOption'].toString(),
      );
    }).toList();

    allQuestions.shuffle();

    setState(() {
      questions = allQuestions.sublist(0, 10);
    });
  }

  void answerSelected(String option) {
    if (!quizCompleted) {
      setState(() {
        selectedOption = option;

        isAnswerCorrect =
            selectedOption == questions[currentQuestionIndex].correctOption;

        if (isAnswerCorrect) {
          // Display the 4th option from the question in a dialog
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.info,
            title: 'Explanation!--Knowlege is power',
            desc: questions[currentQuestionIndex].options[4],
            btnOkOnPress: () {
              moveToNextQuestion();
            },
          )..show();
        } else {
          // If the answer is incorrect, wait for 2 seconds and then move to the next question
          Future.delayed(const Duration(seconds: 2), () {
            moveToNextQuestion();
          });
        }
      });

      bool isCorrect =
          selectedOption == questions[currentQuestionIndex].correctOption;

      if (isCorrect) {
        setState(() {
          score++;
        });
      }
    }
  }

  bool isLoadingNextQuestion = false;

  void moveToNextQuestion() {
    setState(() {
      isLoadingNextQuestion = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: SpinKitChasingDots(
            color: Colors.blue,
            size: 50.0,
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () async {
      setState(() {
        if (isTimerExpired) {
          // Show time-up dialog and navigate to quizzes screen
          Navigator.of(context).pop();
          if (score >= 5) {
            showScoreDialog(context, score); // Show score popup
            updateScoreAndCompletion();
          } else {
            showScoreDialog(context, score);
          }
        } else if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          selectedOption = null;
          isLoadingNextQuestion = false;
          Navigator.of(context).pop(); // Close the loading dialog
        } else {
          // Update isCompleted to true and score in Firestore
          level3.QuizInfo completedQuiz = level3.quizzes[currentQuestionIndex];
          completedQuiz.isCompleted = true;
          completedQuiz.score = score;

          isLoadingNextQuestion = false;
          Navigator.of(context).pop(); // Close the dialog

          if (score >= 5) {
            showScoreDialog(context, score); // Show score popup
            updateScoreAndCompletion();
          } else {
            showQuizNotPassedDialog(context);
          }
        }
      });
    });
  }

  Future<void> updateScoreAndCompletion() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the score and completion status in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection(quiz.level)
            .doc(quiz.quizId) // Use the quiz ID from the widget
            .set({
          'score': score,
          'isCompleted': true,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating score and completion: $e');
    }
  }

  void showQuizNotPassedDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Quiz Not Passed',
      desc: 'Unfortunately, you did not pass the quiz.',
      btnOkOnPress: () {
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuizzesScreen()),
        );
      },
    )..show();
  }

  void showScoreDialog(BuildContext context, int score) {
    String dialogMessage;

    if (isTimerExpired) {
      dialogMessage =
          'Time is up! Your quiz answers have been saved. You Scored $score/10 marks.';
    } else {
      dialogMessage = 'You scored $score/10 marks.';
    }

    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: isTimerExpired ? 'Time Up!' : 'Quiz Completed',
      desc: '$dialogMessage',
      btnOkOnPress: () {
        _countdownTimer?.cancel(); // Cancel the timer if it's still running
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 105, 160, 205), // You can replace this with your desired color
    ));
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    // Calculate responsive font size based on screen width

    final horizontalPadding = screenWidth * 0.05;
    if (!isTimerExpired && _countdownTimer == null && !isTimerDialogShown) {
      isTimerDialogShown = true; // Set the flag to true
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Remember!',
          desc: 'You have 10 minutes to complete this quiz!',
          btnCancelOnPress: () {
            Navigator.pop(context);
          },
          btnOkOnPress: () {
            startTimer();
          },
        )..show();
      });
    }

    Row generateDots() {
      List<Widget> dots = [];
      for (int i = 0; i < totalQuestions; i++) {
        dots.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == currentQuestionIndex
                  ? const Color.fromARGB(255, 57, 146, 193)
                  : Colors.grey,
            ),
          ),
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dots,
      );
    }

    return Scaffold(
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
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'Warning!',
                desc: 'Your score will be lost!',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  Navigator.pop(context);
                },
              )..show();
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
          title: Text(
            quiz.title,
            style: const TextStyle(
                letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment:
                      Alignment.topLeft, // Adjust the alignment as needed
                  child: Container(
                    margin: EdgeInsets.only(
                        left: isPortrait ? horizontalPadding : 0,
                        top: isPortrait ? 20 : 0), // Adjust margins as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adjust the spacing between title and timer

                        Center(
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: isTimerExpired
                                        ? 0
                                        : (remainingSeconds / 600),
                                    color: isTimerExpired
                                        ? Colors.red
                                        : Colors.green,
                                    strokeWidth:
                                        8, // Adjust the thickness of the circle
                                  ),
                                ),
                                Text(
                                  '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (questions.isEmpty)
                  Center(
                    child: SpinKitFadingCube(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                  )
                else
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Center(
                        child: Container(
                          width: isPortrait
                              ? screenWidth * 0.8
                              : screenWidth * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 57, 146, 193),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.question_mark,
                                    size: 40, color: Colors.white54),
                                const SizedBox(width: 10),
                                Container(
                                  width: 240, // Adjust as needed
                                  child: Text(
                                    questions[currentQuestionIndex]
                                        .questionText,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'Open_Sans',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Show if the answer is correct

                      const SizedBox(height: 20),

                      Column(
                        children: questions[currentQuestionIndex]
                            .options
                            .take(4) // Take the first 4 options
                            .map(
                              (option) => InkWell(
                                onTap: isLoadingNextQuestion || quizCompleted
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedOption = option;
                                          answerSelected(option);
                                        });
                                      },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 40),
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: selectedOption == option
                                        ? Colors.green
                                        : Colors
                                            .white, // Change this color to your desired color
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (quizCompleted)
                            IconButton(
                              onPressed: isLoadingNextQuestion
                                  ? null
                                  : () {
                                      moveToNextQuestion();
                                    },
                              icon: const Icon(Icons.done),
                              color: Colors.blue,
                              iconSize: 60,
                            ),
                          if (!quizCompleted && selectedOption != null)
                            IconButton(
                              onPressed: isLoadingNextQuestion
                                  ? null
                                  : () {
                                      moveToNextQuestion();
                                    },
                              icon:
                                  const Icon(Icons.arrow_circle_right_rounded),
                              color: Colors.blue,
                              iconSize: 60,
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      generateDots(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<dynamic> options;
  final String correctOption;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOption,
  });
}
