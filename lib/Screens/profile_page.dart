import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_handler/loginScreen/login_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ProfilePage extends StatefulWidget{
  final String username;

  ProfilePage({required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double _totalExpenses = 0.0;
  double _monthlyBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if(user == null){
      throw Exception('No user Logged in');
    }

    try{
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      double budget =(userDoc['monthlyBudget'] as num?)?.toDouble() ?? 0.0;
      QuerySnapshot expenseSnapshot = await _firestore.
      collection('users')
          .doc(user.uid).
    collection('expense')
          .get();

      double total = 0.0;

      for (var doc in expenseSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        total += (data['amount'] as num?)?.toDouble() ?? 0.0;
      }

      setState(() {
        _monthlyBudget = budget;
        _totalExpenses = total;
      });
    }
    catch(e){
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Failed to fetch user deatils : $e'))
     );
    }

        }



  Future<void> _updateBudget(double newBudget) async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user == null){
    throw Exception("user Not Logged in");
  }
  try{
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'monthlyBudget' : newBudget});

    setState(() {
      _monthlyBudget = newBudget;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Monthly budget update Successfully'))
    );
  }
  catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update budget : $e'))
    );
  }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: tSecondaryColor.withOpacity(0.5),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: tPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.username,
                  style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const Text(
                'Account Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading:
                const Icon(Icons.account_balance_wallet, color: tPrimaryColor),
                title: const Text('Total Expenses'),
                trailing: Text(
                  'Rs ${_totalExpenses.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Budget Management
              const Text(
                'Manage Budget',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.money, color: tPrimaryColor),
                title: const Text('Monthly Budget'),
                subtitle: Text(
                  'Rs ${_monthlyBudget.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit,),
                  onPressed: () {
                    _showBudgetDialog();
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: 24),

              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) => LoginSignupScreen(),),
                        (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBudgetDialog() {
    final TextEditingController budgetController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Monthly Budget'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter your budget',
              prefixText: 'Rs ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double newBudget =
                    double.tryParse(budgetController.text) ?? 0.0;
                if (newBudget > 0) {
                  _updateBudget(newBudget);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}