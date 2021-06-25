import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  // getter that are calculate dynamically
  List<Map<String, dynamic>> get groupedTransactionsValues {
    // generate a list if we know the nomber of elements
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E('fr').format(weekDay).substring(0, 1).toUpperCase(),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    // change list to another type
    return groupedTransactionsValues.fold(
      0.0,
      (sum, item) => sum + item['amount'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues
              .map(
                (data) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0.0 ? 0.0 : data['amount'] / totalSpending,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
