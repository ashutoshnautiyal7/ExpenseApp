import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/material.dart'=
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        child: transactions.isEmpty
            ? Column(
                children: [
                  Text('No transactions added yet'),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/ronaldo.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                // its the alternative for scroll view which won't give us errors. Note it is to be used inside container else will give errors. note: container needs to be given some height else nothing will be rendered

                // listview builder for  list which load only what's visible

                itemBuilder: (context, index) {
                  // now here we'll be removing the card wiith listtitle widget

                  // return Card(
                  //   child: Row(
                  //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.symmetric(
                  //           vertical: 10,
                  //           horizontal: 15,
                  //         ),
                  //         decoration: BoxDecoration(
                  //             border: Border.all(
                  //           width: 2,
                  //           color: Colors.purple,
                  //         )),
                  //         padding:
                  //             EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  //         child: Text(
                  //           '\$ ${transactions[index].amount.toStringAsFixed(2)}',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20,
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //         ),
                  //       ),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             transactions[index].title,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.bold, fontSize: 24),
                  //             textAlign: TextAlign.right,
                  //           ),
                  //           Text(
                  //             // tx.date.toString(),
                  //             "Jan 15 2023",
                  //             style: TextStyle(
                  //                 color: Color.fromARGB(255, 114, 111, 111)),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // );

                  // replacing the card with the listitle widget

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: FittedBox(
                            child: Text('\$${transactions[index].amount}'),
                          ),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                          DateFormat.yMMM().format(transactions[index].date)),
                    ),
                  );
                },
                itemCount: transactions.length,
              ));
  }
}
