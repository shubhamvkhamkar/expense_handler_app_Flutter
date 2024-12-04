import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_handler/Screens/add_expenses_screen.dart';
import 'package:expense_handler/Screens/bottomNavigation/app_bar_bottom_navigation_bar.dart';
import 'package:expense_handler/Screens/chart/expense_cart.dart';
import 'package:expense_handler/Screens/chart/reports_screen.dart';
import 'package:expense_handler/Screens/profile_page.dart';
import 'package:expense_handler/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentIndex = 0;

  final List<Widget> _pages = [
    AddExpensesScreen(),
    ReportsScreen()
  ];


  Future<Map<String, double>> _fetchBudgetAndExpenses() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    double totalExpenses = 0.0;
    double monthlyBudget = 0.0;

    try {
      // Fetch monthlyBudget from user's document
      DocumentSnapshot userDoc = await
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Safely access the 'monthlyBudget' field
        final userData = userDoc.data() as Map<String, dynamic>?;
        monthlyBudget = (userData?['monthlyBudget'] as num?)?.toDouble() ?? 0.0;
      }

      // Fetch total expenses from "expenses" subcollection
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expense')
          .get();

      for (var doc in expenseSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalExpenses += (data['amount'] as num?)?.toDouble() ?? 0.0;
      }
    } catch (e) {
      throw Exception("Failed to fetch budget and expenses: $e");
    }

    return {
      'monthlyBudget': monthlyBudget,
      'totalExpenses': totalExpenses,
    };
  }
  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          toolbarHeight: 75,
          elevation: 0,
          backgroundColor: tPrimaryColor,
          title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Welcome\n${widget.username}',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
              )),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(username: widget.username),
                      ));
                },
                icon: CircleAvatar(
                  radius: 25,
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
            )

          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,

          selectedItemColor: Colors.amber,
          onTap: (index) {
            setState(() {

              _currentIndex = index;
            });
          },
          items: [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 40),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Reports',
            ),
          ],
        ),

        body: _currentIndex == 0
                ? _buildHomeContent(currentMonth)
               : _pages[_currentIndex-1],
    );
}

Widget _buildHomeContent(String currentMonth) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [

      SizedBox(
        height: 10,
      ),
      FutureBuilder<Map<String,double>>(
        future: _fetchBudgetAndExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {'monthlyBudget': 0.0, 'totalExpenses': 0.0};
          double monthlyBudget = data['monthlyBudget']!;
          double totalExpenses = data['totalExpenses']!;
          double remainingBudget = monthlyBudget - totalExpenses;
          return SingleChildScrollView(
            child: Column(
            
              children: [
            
                Card(
                  elevation: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      gradient: LinearGradient(
                        colors: [Color(0xFFf6d365),Color(0xFFfda085)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                      )
                    ),
                    height: 150,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Current Month',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                          Center(
                              child: Text(
                                currentMonth,
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.red),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Total Expenses : \Rs ${totalExpenses.toStringAsFixed(
                                    2)}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Remaining Budget: \Rs  ${remainingBudget
                                    .toStringAsFixed(2)}'
                            ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
            
            
              ],
            ),
          );
        },
      ),
      Expanded(child: ExpenseCart()),


    ],
  );
}
}


