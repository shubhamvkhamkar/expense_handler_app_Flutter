import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditExpenseScreen extends StatefulWidget{
  final String expenseId;
  final Map<String ,dynamic> expeseData;

  EditExpenseScreen({required this.expenseId, required this.expeseData});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {

  late TextEditingController _titleController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _titleController =  TextEditingController(text: widget.expeseData['title']);
    _amountController = TextEditingController(text: widget.expeseData['amount'].toString());
  }

  void _updateExpense() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      // Update the specific expense in the current user's expenses subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Access the current user's document
          .collection('expense') // Access the "expenses" subcollection
          .doc(widget.expenseId) // Target the specific expense
          .update({
        'title': _titleController.text.trim(),
        'amount': double.parse(_amountController.text.trim()),
      });

      Navigator.pop(context); // Navigate back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Expense updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update expense: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Edit Expense'),
     ),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           TextField(
             controller: _titleController,
             decoration: InputDecoration(labelText: 'Title',
             border: OutlineInputBorder()),
           ),
           SizedBox(height: 20,),
           TextField(
             controller: _amountController, 
             decoration: InputDecoration(labelText: "Amount",
             border: OutlineInputBorder()),
             keyboardType: TextInputType.number,
           ),
           SizedBox(height: 30,),
           ElevatedButton(
               style: ButtonStyle(
                 shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(21))),
                 elevation: WidgetStateProperty.all(30),
                 fixedSize: WidgetStateProperty.all(Size(200, 50),)
               ),
               onPressed: _updateExpense,
               child: Text('Update Expense'))
         ],
       ),
     ),
   );
  }
}