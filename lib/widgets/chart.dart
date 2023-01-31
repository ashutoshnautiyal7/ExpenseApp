import 'package:first_app/models/transaction.dart';
import 'package:first_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  // creating a getter --> calculated dynamicaLLY
  List<Map<String, Object>> get groupedTransactcionValues {
    return List.generate(7, (index) {
      // this generates a list with size 7
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      // summing up the tranactions
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E(weekDay));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  // again creating a getter in order to calculate spending pct of total
  double get totalSpending {
    return groupedTransactcionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  // fold changes the list to another type depending on the function passed inside fold

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedTransactcionValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              data['day'].toString(),
              data['amount'] as double,
              totalSpending == 0.0
                  ? 0.0
                  : (data['amount'] as double) / totalSpending,
            ),
          );
        }).toList(),
      ),
    );
  }
}
