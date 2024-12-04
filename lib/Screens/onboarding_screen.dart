import 'dart:async';

import 'package:expense_handler/constants/colors.dart';
import 'package:expense_handler/loginScreen/login_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  OnboardingScreen({required this.onComplete});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>  with SingleTickerProviderStateMixin{


  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    _setOnboardingScreen();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginSignupScreen(),
          ));
    });
  }

  Future<void> _setOnboardingScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onbording_seen', true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        actions: [
          OutlinedButton(onPressed: (){
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen(),));
          },
              child: Text('Sign Up',
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                    tag: 'logo',
                    child: Image.asset('assets/logo/onbording1.png')),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome to Expense Tecker ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Track your expense with ease',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: widget.onComplete,
                  child: Text('Welcome'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
