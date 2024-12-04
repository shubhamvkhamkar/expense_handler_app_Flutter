import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_handler/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensesScreen extends StatefulWidget{


  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addExpense(){
    DateTime now = DateTime.now();
    try{
       final User? user = _auth.currentUser;
       if(user == null){
         throw Exception('User Not Logged in');
       }
      final expenseData = {
        'title' : _titleController.text.trim(),
        'amount' : double.parse(_amountController.text.trim()),
        'date' : DateFormat('yyyy-MM-dd HH:mm').format(now),
      };
       FirebaseFirestore.instance
       .collection('users')
       .doc(user.uid)
       .collection('expense')
       .add(expenseData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense Add Succesfully'))
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
    _titleController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Expenses',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.title,color: tPrimaryColor,),
                  labelText: 'Title',
              hintText: "Enter Expense Name",
              border: OutlineInputBorder()),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(

                prefixIcon: Icon(Icons.money,color: Colors.green,),
                  labelText: 'Amount',
                  hintText: 'Expense Amount',
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _addExpense,
                style: ButtonStyle(
                  elevation: WidgetStateProperty.all<double>(15),
                    shadowColor: WidgetStateProperty.all<Color>(Colors.amber),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(21))),
                fixedSize: WidgetStateProperty.all(Size(200, 50))),
                    
                child: Text('Add Expense'))
          ],
        ),
      ),
    );
  }
}