import 'package:asaf/services/auth_services.dart';
import 'package:asaf/ui/auth/login_screen.dart';
import 'package:asaf/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  var _passwordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Hero(
                    tag: 'toptextHero', // Unique tag for the password field
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        "Create\nAccount",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Hero(
                          tag: 'nameHero',
                          child: Material(
                            elevation: 8,
                            shadowColor: Colors.black87,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              focusNode:
                                  nameFocus, // Assign the FocusNode to the name field
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              controller: nameController,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Name',
                                prefixIcon: const Icon(Ionicons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }

                                return null;
                              },
                              onEditingComplete: () {
                                if (nameController.text.isEmpty) {
                                  // Show an error message for the empty field
                                  Utils().toastMessage('Empty Field!');
                                } else {
                                  // Move focus to the email field when "Tab" is pressed
                                  FocusScope.of(context)
                                      .requestFocus(emailFocus);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Hero(
                          tag: 'emailHero',
                          child: Material(
                            elevation: 8,
                            shadowColor: Colors.black87,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              focusNode:
                                  emailFocus, // Assign the FocusNode to the email field
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              controller: emailController,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email',
                                prefixIcon: const Icon(Ionicons.mail_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onEditingComplete: () {
                                if (emailController.text.isEmpty) {
                                  // Show an error message for the empty field
                                  Utils().toastMessage('Empty Field!');
                                } else {
                                  // Move focus to the password field when "Tab" is pressed
                                  FocusScope.of(context)
                                      .requestFocus(passwordFocus);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Hero(
                          tag: 'passwordHero',
                          child: Material(
                            elevation: 8,
                            shadowColor: Colors.black87,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            child: Row(
                              // Wrap the TextFormField with a Row
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    focusNode:
                                        passwordFocus, // Assign the FocusNode to the password field
                                    obscureText:
                                        !_passwordVisible, // Toggle password visibility
                                    controller: passwordController,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Password',
                                      prefixIcon: const Icon(
                                          Ionicons.lock_closed_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          // Toggle password visibility when the button is pressed
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      if (value.length < 8 &&
                                          !value
                                              .contains(RegExp(r'[A-Za-z]')) &&
                                          !value.contains(RegExp(r'[0-9]')) &&
                                          !value.contains(RegExp(
                                              r'[!@#$%^&*(),.?":{}|<>]'))) {
                                        return 'Password must be at least 8 characters long';
                                      }
                                      if (!value
                                          .contains(RegExp(r'[A-Za-z]'))) {
                                        return 'Password must contain at least one letter';
                                      }
                                      if (!value.contains(RegExp(r'[0-9]'))) {
                                        return 'Password must contain at least one number';
                                      }
                                      if (!value.contains(
                                          RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                        return 'Password must contain at least one special character';
                                      }
                                      return null;
                                    },
                                    onEditingComplete: () {
                                      if (passwordController.text.isEmpty) {
                                        // Show an error message for the empty field
                                        Utils().toastMessage('Empty Field!');
                                      } else {
                                        // Handle submission or move to the next field as needed
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Password must contain number, special characters, alphabets, and be at least 8 characters long',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 05),
                  Hero(
                    tag: 'buttonHero',
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
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
                                await _auth
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString(),
                                )
                                    .then((userCredential) async {
                                  DateTime signUpDate = DateTime.now();
                                  int signUpYear = signUpDate.year;

                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userCredential.user!.uid)
                                      .set({
                                    'aname': nameController.text.toString(),
                                    'bemail': emailController.text.toString(),
                                    'cphoneno': 'Phone No',
                                    'dgender': 'Gender',
                                    'fdateofbirth': 'YY-MM-DD',
                                    'gprofileImageUrl': 'null',
                                    'signupdate': signUpDate.toLocal(),
                                    'signupyear': signUpYear,
                                  });

                                  Navigator.pop(context);

                                  Utils().toastMessage(
                                      'Sign up successful! You can now log in.');

                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          LoginScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
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
                                });
                              } on FirebaseAuthException catch (e) {
                                Navigator.of(context).pop();

                                String errorMessage = '';
                                if (e.code == 'email-already-in-use') {
                                  errorMessage =
                                      'This email is already in use.';
                                } else if (e.code == 'weak-password') {
                                  errorMessage = 'Password is too weak.';
                                } else {
                                  errorMessage =
                                      'An error occurred. Please try again.';
                                  print('Error: ${e.message}');
                                }

                                Utils().toastMessage(errorMessage);
                              } catch (e) {
                                Navigator.of(context).pop();
                                print('Error: $e');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 12,
                              shadowColor: Colors.black87,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => AuthService().signInWithGoogle(
                            context), // Replace with your Google sign-in function
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/google.png', // Replace with your Google icon path
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap:
                            _handleAppleSignIn, // Replace with your Apple sign-in function
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/apple.png', // Replace with your Apple icon path
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap:
                            _handleFacebookSignIn, // Replace with your Facebook sign-in function
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/facebook.png', // Replace with your Facebook icon path
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _handleFacebookSignIn() async {
  // ... Your Facebook Sign-In code ...
}

Future<void> _handleAppleSignIn() async {
  // ... Your Apple Sign-In code ...
}
