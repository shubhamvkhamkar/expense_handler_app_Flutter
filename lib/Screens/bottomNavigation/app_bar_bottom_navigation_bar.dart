import 'package:expense_handler/Screens/add_expenses_screen.dart';
import 'package:expense_handler/Screens/chart/reports_screen.dart';
import 'package:expense_handler/Screens/home_screen.dart';

import 'package:flutter/material.dart';

class AppBarBottomNavigationBar extends StatefulWidget{
  @override
  State<AppBarBottomNavigationBar> createState() => _AppBarBottomNavigationBarState();
}

class _AppBarBottomNavigationBarState extends State<AppBarBottomNavigationBar> {


  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [

   AddExpensesScreen(),
    ReportsScreen(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavBarItem(Icons.home, "Home", 0),
                _buildNavBarItem(Icons.add_circle, '', 1),
                _buildNavBarItem(Icons.bar_chart, 'Bar Report', 3)
              ],
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex]

    );
  }


  Widget _buildNavBarItem(IconData icon, String lable, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
         _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              icon,
            color: _currentIndex == index ? 
            Colors.blue : Colors.grey
          ),
          Text(lable,
          style: TextStyle(
            color: _currentIndex == index 
                ?
                Colors.blue
                :Colors.grey,
            fontSize: 12,

          ),)
        ],
      ),
    );
  }
}