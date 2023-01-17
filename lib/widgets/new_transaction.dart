import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewTransaction extends StatelessWidget {
  // late String titleInput;
  // late String amountInput;

  //  the alernative way of taking the title input and the amount input is down
  final titleController =
      TextEditingController(); // these controller listens user ip and saves the user input
  final amountController = TextEditingController();

  final Function addTx;

  NewTransaction(this.addTx); // consturctor

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) return;
    addTx(
      enteredTitle,
      enteredAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        // since container have padding and margin args so we wrapped our  column with the container
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            // onChanged takes a function that takes the String argument but returns nothing
            // onChanged: (val) {
            //   // so we are creating a anonumous function
            //   titleInput = val;
            // },

            controller: titleController,
            onSubmitted: (_) => submitData,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            // onChanged: (val) {
            //   // so we are creating a anonumous function
            //   amountInput = val;
            // },
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => submitData,
          ),
          TextButton(
            child: Text('Add Transaction'),
            onPressed: submitData,
          )
        ]),
      ),
    );
  }
}
