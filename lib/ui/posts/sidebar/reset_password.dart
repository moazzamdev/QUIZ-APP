import 'package:asaf/ui/posts/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MaterialApp(
    home: ResetPassword(),
  ));
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unique tag for the password field
                  const Material(
                    color: Colors.transparent,
                    child: Text(
                      "Reset\nPassword",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 180),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Unique tag for the password field
                        Material(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: SpinKitChasingDots(
                                    color: Colors
                                        .blue, // Choose your desired color
                                    size: 50.0, // Choose your desired size
                                  ),
                                );
                              },
                            );

                            try {
                              await _auth
                                  .sendPasswordResetEmail(
                                      email: emailController.text.toString())
                                  .then((value) {});

                              // Close the loading indicator
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Password reset link sent. Check your email.'),
                                ),
                              );

                              // Navigate to the next screen after successful login
                              Navigator.pop(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const DashboardScreen(),
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
                            } on FirebaseAuthException catch (e) {
                              // Close the loading indicator
                              Navigator.of(context).pop();

                              String errorMessage = '';
                              if (e.code == 'user-not-found') {
                                errorMessage = 'Invalid email';
                              } else if (e.code ==
                                  'reset-password-email-sent') {
                                errorMessage =
                                    'Password reset link sent. Check your email.';
                              } else {
                                errorMessage =
                                    'An error occurred. Please try again.';
                                print('Error: ${e.message}');
                              }

                              // Display the error message using a Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                ),
                              );
                            } catch (e) {
                              // Close the loading indicator
                              Navigator.of(context).pop();

                              // Handle other errors
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
                          'Reset',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  const SizedBox(
                    height: 180,
                  ),
                ])),
      ),
    );
  }
}
