import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // late String titleInput;
  final titleController = TextEditingController();
  // these controller listens user ip and saves the user input
  final amountController = TextEditingController();

  // consturctor
  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) return;
    widget.addTx(
      enteredTitle,
      enteredAmount,
    );

    Navigator.of(context).pop();
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
          Container(
            height: 70,
            child: Row(
              children: [
                Text('no date chosen '),
                ElevatedButton(
                  child: Text('choose date'),
                  onPressed: () {},
                )
              ],
            ),
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
