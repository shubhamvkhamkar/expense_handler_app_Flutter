import 'package:expense_handler/Screens/splash_screen.dart';
import 'package:expense_handler/loginScreen/login_signup_screen.dart';
import 'package:expense_handler/utils/theme/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  /*await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);*/
  /*SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? onboardingSeen = prefs.getBool('onboarding_seen');*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


   MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}

