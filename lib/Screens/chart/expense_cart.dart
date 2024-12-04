import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../edit_expense_screen.dart';

class ExpenseCart extends StatefulWidget{

  @override
  State<ExpenseCart> createState() => _ExpenseCartState();
}

class _ExpenseCartState extends State<ExpenseCart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth =FirebaseAuth.instance;

  Stream<QuerySnapshot> _fetchUserExpnses(){
    final User? user = _auth.currentUser;

    if(user == null){
      throw Exception('User not logged in');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('expense')
        .orderBy('date',descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchUserExpnses(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Error : ${snapshot.error}'));
        }
        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No expense found'));
        }
        final expenses = snapshot.data!.docs;
        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            print(expenses[index].data());

            var expense = expenses[index].data()
            as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(top: 5,bottom: 5),
              child: SingleChildScrollView(
                child: Card(

                  elevation: 20,
                 color: Colors.purple.shade200,
                  child: ListTile(
                
                    leading: Icon(Icons.shopping_cart,color: Colors.blue,),
                    title: Text(expense['title'] ?? 'Unknown Title',style: TextStyle(fontWeight: FontWeight.bold,),),
                
                    subtitle: Row(
                
                
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\Rs.${expense['amount']}",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),),
                            Text("\Date : ${expense['date'] ?? 'unknown Date'}",style: TextStyle(color: Colors.black),),
                          ],
                        )
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                
                      children: [
                
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditExpenseScreen(
                                    expenseId: expenses[index].id,
                                    expeseData: expense,
                                  ),
                                ));
                          },
                          icon: Icon(Icons.edit,color:Colors.green,),
                        ),
                        IconButton(
                            onPressed: ()  async {
                              try {
                                final User? user = FirebaseAuth.instance.currentUser;
                
                                if (user == null) {
                                  throw Exception("User not logged in");
                                }
                
                                // Delete the expense document
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('expense')
                                    .doc(expenses[index].id)
                                    .delete();
                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Expense deleted successfully')),
                                );
                
                                // Optionally update UI after deletion
                                setState(() {
                                  expenses.removeAt(index);
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to delete expense: $e')),
                                );
                              }
                            },
                            icon: Icon(Icons.delete,color: Colors.red,))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );

      },
    );
  }
}