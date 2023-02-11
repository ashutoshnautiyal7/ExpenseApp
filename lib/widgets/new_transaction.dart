import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // late String titleInput;
  final _titleController = TextEditingController();
  // these controller listens user ip and saves the user input
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  // consturctor
  void _submitData() {
    if (_amountController.text.isEmpty) return;

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null)
      return;
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2004),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _selectedDate = pickedDate;
      });
    });
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

            controller: _titleController,
            onSubmitted: (_) => _submitData,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            // onChanged: (val) {
            //   // so we are creating a anonumous function
            //   amountInput = val;
            // },
            controller: _amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData,
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'no date chosen '
                      : DateFormat.yMd().format(_selectedDate).toString()),
                ),
                ElevatedButton(
                  child: Text('choose date'),
                  onPressed: _presentDatePicker,
                )
              ],
            ),
          ),
          TextButton(
            child: Text('Add Transaction'),
            onPressed: _submitData,
          )
        ]),
      ),
    );
  }
}
