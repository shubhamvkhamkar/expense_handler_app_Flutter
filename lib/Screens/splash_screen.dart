import 'dart:async';

import 'package:expense_handler/Screens/onboarding_screen.dart';
import 'package:expense_handler/loginScreen/login_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

 @override
  void initState() {

    super.initState();
    _navigate();
  }
 Future<void> _navigate() async {
   // Simulate a delay for the splash screen
   await Future.delayed(Duration(seconds: 3));


   // Check if onboarding has been completed
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

   // Check if a user is logged in
   User? user = FirebaseAuth.instance.currentUser;

   if (!hasSeenOnboarding) {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (_) =>
           OnboardingScreen(
           onComplete: () async {
         await prefs.setBool('hasSeenOnboarding', true);
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (_) => user != null
                 ? HomeScreen(username:
             user.displayName ?? 'User')
                 : LoginSignupScreen(),
           ),
         );
       })),
     );
   } else if (user != null) {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (_) =>
           HomeScreen(username: user.displayName ?? 'User')),
     );
   } else {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (_) => LoginSignupScreen()),
     );
   }
 }


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    var isDrakMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Hero(
               tag: "logo",
               child: Image.asset('assets/logo/logo.png', width: 300, height: 300,))
          ],
        ),
      ),
    );
  }
}