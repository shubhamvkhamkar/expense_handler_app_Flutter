import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget{
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;


  Future<Map<String, double>> _fetchCategoryData() async {
    final User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    if (user == null) {
      throw Exception("User not logged in");
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Access the current user's document
        .collection('expense') // Access the "expenses" subcollection
        .get();

    Map<String, double> categoryData = {};

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String category = data['title'] ?? 'Other'; // Default to 'Other' if title is missing
      double amount = (data['amount'] as num?)?.toDouble() ?? 0.0; // Safely cast amount to double
      categoryData[category] = (categoryData[category] ?? 0) + amount;
    }

    return categoryData;
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Reports'),
     ),
     body: FutureBuilder<Map<String ,double>>(
       future: _fetchCategoryData(),
       builder: (context, snapshot) {
         if(!snapshot.hasData){
           return Center(child: CircularProgressIndicator());
         }
         final categoryData = snapshot.data!;
         return Padding(
           padding: const EdgeInsets.all(50.0),
           child: PieChart(
             PieChartData(

               sections: categoryData.entries.map((entry){
                 return PieChartSectionData(
                   titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                   title: "${entry.key}\n\Rs${entry.value}",
                   value: entry.value,
                   color: Colors.primaries[categoryData.keys.toList()
                   .indexOf(entry.key) % Colors.primaries.length],
                 );
               }).toList()
             )
           ),
         );
       },
     ),
   );
  }

}