import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_handler/Screens/home_screen.dart';
import 'package:expense_handler/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  State<LoginSignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailContorller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isSignup = false;

  Future<void> _authenticate() async {
    try {
      UserCredential userCredential;
      if (isSignup) {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailContorller.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'username': _usernameController.text.trim()});
        await userCredential.user!
            .updateDisplayName(_usernameController.text.trim());
      } else {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailContorller.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      if (!isSignup) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomeScreen(
                    username: userCredential.user!.displayName ?? 'User',
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign Up Succsfully ! Please Log In')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No User Found')));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
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
        toolbarHeight: 75,
        backgroundColor: tPrimaryColor,
        title: Text(
          "Expense App",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    isSignup
                        ? 'assets/images/admin.png'
                        : 'assets/images/user1.jpeg',
                    width: 200,
                    height: 200,
                  ),
                ),
                Text(
                  isSignup ? "Sign Up " : "Login",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                ),
                SizedBox(
                  height: 35,
                ),
                if (isSignup)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                          hintText: 'Enter Your USername',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21)
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailContorller,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        hintText: 'Enter Your Email Id',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21)
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility
                                  : Icons.visibility_off
                            ), onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                          },
                          ),
                          labelText: 'Password',
                          hintText: 'Enter Your Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21)
                          )),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
                  shadowColor: WidgetStateProperty.all<Color>(tPrimaryColor),
                  elevation: WidgetStateProperty.all<double>(8),
                  fixedSize: WidgetStateProperty.all<Size>(Size(200, 50)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)))),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _authenticate();
                      }
                    },

                    child: Text(
                      isSignup ? "Sign Up" : "Login",
                      style: TextStyle(fontSize: 18,color: tWhiteColor),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isSignup = !isSignup;
                      });
                    },
                    child: Text(isSignup
                        ? "Already have an account? Login "
                        : "Don't have an Account? Register here"))
              ],
            ),
          )),
        ),
      ),
    );
  }
}
