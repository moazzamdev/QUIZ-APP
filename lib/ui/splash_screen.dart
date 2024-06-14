import 'package:asaf/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:asaf/ui/posts/home_screen.dart';

final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Use TickerProviderStateMixin
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  double _activeDotPosition = 0;

  late AnimationController _dotAnimationController;
  late Animation<double> _dotsAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Adjust the duration as needed
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _dotAnimationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 750), // Adjust the duration as needed
    );

    _dotsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _dotAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(); // Start the rotation animation
    _dotAnimationController.repeat(); // Start the dot animation

    // Update the active dot position as the dot animation progresses
    _dotAnimationController.addListener(() {
      setState(() {
        _activeDotPosition =
            _dotsAnimation.value * (3 - 1); // Assuming 3 dots (0, 1, 2)
      });
    });

    if (user != null) {
      Future.delayed(const Duration(seconds: 3), () {
        _dotAnimationController
            .dispose(); // Dispose the dot animation controller
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const DashboardScreen()), // Replace with your home screen
        );
        
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        _dotAnimationController
            .dispose(); // Dispose the dot animation controller
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });

    }
    
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose the dot animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _rotationAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                  child: const Image(
                    image: AssetImage('assets/logooo.png'),
                    // You can adjust the fit property as needed
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20, // Add some space between the image and text
            ),
            const Text(
              'ASAF', // Replace with your actual text
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open_Sans'),
            ),
            const SizedBox(height: 50), // Add space below the text
            DotsIndicator(
              dotsCount: 3,
              position:
                  _activeDotPosition.round(), // Round to the nearest integer
              decorator: const DotsDecorator(
                color: Colors.grey, // Color of inactive dots
                activeColor: Colors.blue, // Color of active dot
                size: Size.square(9.0), // Size of each dot
                activeSize: Size(10.0, 9.0), // Size of active dot
              ),
            ),
          ],
        ),
      ),
    );
  }
}
