import 'package:asaf/services/auth_services.dart';
import 'package:asaf/ui/auth/signup_screen.dart';
import 'package:asaf/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asaf/ui/posts/home_screen.dart';
import '../forgot_password.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                      "Welcome\nBack",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Hero(
                        tag: 'emailHero',
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
                                Utils().toastMessage('Empty Field!');
                              } else {
                                // Move focus to the password field when "Tab" is pressed
                                FocusScope.of(context).nextFocus();
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
                          child: TextFormField(
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
                              prefixIcon:
                                  const Icon(Ionicons.lock_closed_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: _passwordVisible
                                      ? Colors.blue
                                      : Colors.grey, // Customize the icon color
                                ),
                                onPressed: () {
                                  // Toggle password visibility when the button is pressed
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              // Additional password validation logic can be added here
                              return null;
                            },
                            onEditingComplete: () {
                              if (passwordController.text.isEmpty) {
                                Utils().toastMessage('Empty Field!');
                              } else {
                                // Handle submission or move to the next field as needed
                              }
                            },
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'forgotHero',
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const ForgotPassword(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var slideAnimation = Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    );

                                    return SlideTransition(
                                      position: slideAnimation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 800),
                                ),
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                    ],
                  ),
                ),
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
                                    color: Colors
                                        .blue, // Choose your desired color
                                    size: 50.0, // Choose your desired size
                                  ),
                                );
                              },
                            );

                            try {
                              await _auth.signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString(),
                              );

                              // Close the loading indicator
                              Navigator.pop(context);

                              // Navigate to the next screen after successful login
                              Navigator.pushReplacement(
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
                              if (e.code == 'user-not-found' ||
                                  e.code == 'wrong-password') {
                                errorMessage = 'Invalid email or password.';
                              } else {
                                errorMessage =
                                    'An error occurred. Please try again.';
                                print('Error: ${e.message}');
                              }

                              // Display the error message using a Snackbar
                              Utils().toastMessage(errorMessage);
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
                          'Login',
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
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignupScreen(),
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
                      child: const Text('Sign up'),
                    ),
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

Future<void> _handleFacebookSignIn() async {
  // ... Your Facebook Sign-In code ...
}

Future<void> _handleAppleSignIn() async {
  // ... Your Apple Sign-In code ...
}
