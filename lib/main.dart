import 'dart:ffi';
import 'dart:ui';
import 'dart:io';

import 'package:first_app/widgets/chart.dart';
import 'package:first_app/widgets/new_transaction.dart';
import 'package:first_app/widgets/transaction_list.dart';
import 'package:first_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';

// package for screen orientation
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
      ), // difining the colors fonts and other things for later use
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // widgetsbinding observer for app lifecycle stuff
  final List<Transaction> _userTransactions = [];
//  helow
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  bool _showChart = false;

  //  adding new method for the  applifecycle part
  didChangeAppLifecycleState(AppLifecycleState state) {
    //this method is called whenever the app reaches to a new state in the lifecycle
    print(state); //
  }

  // setting up  a listener to trigger the dispose method
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  dispose() {
    // WidgetsBinding.instance.removeObserver(observer)
    WidgetsBinding.instance.removeObserver(this);
    super
        .dispose(); // in dispose you clear all listners you have in the lifecycle
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  // let's create a method to open the floating sheet
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) =>
          tx.id ==
          id); // removeWhere removes a item when a certaion condition is met
    });
  }

//  widget builder for the clean code

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('show chart'),
          Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  //  note: these builder methods improve the code readabilty and not the efficiency

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget build(BuildContext context) {
    // context builds the skeleton of your widget tree---> it shows how the widgets are related to each other

    //   context also holds the position J of widgets in the widget tree
    // checking weather our device is in landscape mode or not

    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // storing the appbar in the appbar variable
    final appBar = AppBar(
      backgroundColor: Colors.deepPurple,
      title: Text('Expense App'),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add)),
      ],
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SingleChildScrollView(
      // the other way is you can wrap transactions list in container and define some height to it
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          if (!isLandscape)
            ..._buildPortraitContent(
              // this returns the list of widgets  but  here we have to pass a single widget and not the list of widgets so we'll use the spread operator like the one used in javascript

              // NOTE: this three dots tell the dart  to take out the elements from the list and merge them into the surrounding list
              mediaQuery,
              appBar,
              txListWidget,
            ),
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar, txListWidget)
        ],
      ),
    );

// done with this app
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          ) // cupertino widgets are for ios
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
