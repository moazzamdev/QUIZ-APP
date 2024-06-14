import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../home_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HelpCenterScreen(),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  final messageController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                  'Help Center',
                  style: TextStyle(
                      letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
                ),
              ),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 140),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Open_Sans',
                          color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    FAQCard(
                      question: 'How do I reset my password?',
                      answer:
                          'You can reset your password by clicking on the "Forgot Password" link on the login screen.',
                    ),
                    FAQCard(
                      question: 'Can I change my username?',
                      answer:
                          'Yes, you can change your username by navigating to your profile icon and updating your profile.',
                    ),
                    FAQCard(
                      question: 'Facing slow data loading?',
                      answer:
                          'Yes, slow data loading can depend on WiFi speed and fetching large data from database.',
                    ),
                    FAQCard(
                      question: 'Can i delete my account?',
                      answer:
                          'No, you cannot delete your account once it created.',
                    ),
                    FAQCard(
                      question: 'Can i chnage my Email address?',
                      answer:
                          'No, all the account login and data is based on email, so it cannot be changed.',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Query not resolved?',
                              style: TextStyle(
                                  fontFamily: 'Open_Sans',
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Write to us our team will get back to you.',
                              style: TextStyle(
                                  fontFamily: 'Open_Sans',
                                  fontSize: 11,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Hero(
                              tag:
                                  'nameHero', // Unique tag for the password field
                              child: Material(
                                elevation: 8,
                                shadowColor: Colors.black87,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  obscureText: false,
                                  controller: messageController,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: InputDecoration(
                                    //labelText: widget.initialMessage,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter Query',
                                    prefixIcon: const Icon(
                                        Icons.question_mark_outlined),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Hero(
                              tag: '', // Unique tag for the password field
                              child: Material(
                                elevation: 8,
                                shadowColor: Colors.black87,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  controller: emailController,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: InputDecoration(
                                    //labelText: widget.initialMessage,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Your Email',
                                    prefixIcon: const Icon(Icons.mail),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Show loading spinner
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

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('queries')
                                          .add({
                                        'email': emailController,
                                        'query': messageController,
                                        'timestamp':
                                            FieldValue.serverTimestamp(),
                                      });

                                      // Close the loading spinner dialog
                                      Navigator.of(context).pop();

                                      // Show success message (you can use a SnackBar here)

                                      // Delay the navigation by 2 seconds
                                      await Future.delayed(
                                          Duration(seconds: 2));

                                      // Navigate to the DashboardScreen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardScreen(),
                                        ),
                                      );
                                    } catch (error) {
                                      // Close the loading spinner dialog
                                      Navigator.of(context).pop();

                                      // Handle the error (show an error message or SnackBar)
                                      print('Error uploading query: $error');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    elevation: 12,
                                    shadowColor: Colors.black87,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Add more FAQCard widgets as needed
                          ],
                        ),
                      ),
                    ),
                  ]),
            ))));
  }
}

class FAQCard extends StatefulWidget {
  final String question;
  final String answer;
  final TextStyle questionStyle;
  final TextStyle answerStyle;

  FAQCard({
    required this.question,
    required this.answer,
    this.questionStyle = const TextStyle(),
    this.answerStyle = const TextStyle(),
  });

  @override
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: TextStyle(fontFamily: 'Open_Sans'),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            child: Text(widget.answer),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
      ),
    );
  }
}
