import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class UpdateProfile extends StatefulWidget {
  String initialMessage;
  String initialGender;
  String initialPhoneno;

  String initialDateOfBirth;

  UpdateProfile({
    required this.initialMessage,
    required this.initialGender,
    required this.initialPhoneno,
    required this.initialDateOfBirth,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController messageController;
  late TextEditingController genderController;
  late TextEditingController phonenoController;

  late TextEditingController dateOfBirthController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: widget.initialMessage);
    genderController = TextEditingController(text: widget.initialGender);
    phonenoController = TextEditingController(text: widget.initialPhoneno);

    dateOfBirthController =
        TextEditingController(text: widget.initialDateOfBirth);
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
        resizeToAvoidBottomInset: false,
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
                Navigator.pop(context);
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
              'Update Profile',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Hero(
                      tag: 'nameHero', // Unique tag for the password field
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black87,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
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
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Hero(
                      tag: 'phoneHero', // Unique tag for the password field
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black87,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          obscureText: false,
                          controller: phonenoController,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            //labelText: widget.initialMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Hero(
                      tag: 'genderHero', // Unique tag for the password field
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black87,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          obscureText: false,
                          controller: genderController,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            //labelText: widget.initialMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.people_alt),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Hero(
                      tag: 'dobHero', // Unique tag for the password field
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black87,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          controller: dateOfBirthController,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            //labelText: widget.initialMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.date_range),
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
                              var user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                // Update user profile data
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                  'aname': messageController.text.toString(),
                                  'cphoneno': phonenoController.text.toString(),
                                  'fdateofbirth':
                                      dateOfBirthController.text.toString(),
                                  'dgender': genderController.text.toString(),
                                });

                                // Close the loading spinner dialog
                                Navigator.of(context).pop();

                                // Show success message

                                // Delay the navigation by 2 seconds
                                await Future.delayed(Duration(seconds: 2));

                                // Navigate to the DashboardScreen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen()),
                                );
                              }
                            } catch (e) {
                              // Close the loading spinner dialog
                              Navigator.of(context).pop();
                              print('Error: $e');
                            }
                            Utils().toastMessage('Updated Sucessfuly');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 12,
                              shadowColor: Colors.black87,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
