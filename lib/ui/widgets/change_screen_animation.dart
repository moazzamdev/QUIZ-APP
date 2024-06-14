import 'package:flutter/material.dart';

class ChangeScreenAnimation {
  static late AnimationController _controller;
  static late Animation<double> _loginSlideAnimation;
  static late Animation<double> _createAccountSlideAnimation;

  static void initialize({required TickerProvider vsync, int loginItems = 1, int createAccountItems = 1}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    const double loginScreenEnd = 0;
    final double createAccountScreenEnd = -loginItems.toDouble();

    _loginSlideAnimation = Tween<double>(begin: 0, end: loginScreenEnd).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _createAccountSlideAnimation = Tween<double>(begin: 0, end: createAccountScreenEnd).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  static void forward() {
    _controller.forward();
  }

  static void reverse() {
    _controller.reverse();
  }

  static double getLoginSlideAnimation() {
    return _loginSlideAnimation.value;
  }

  static double getCreateAccountSlideAnimation() {
    return _createAccountSlideAnimation.value;
  }
}
