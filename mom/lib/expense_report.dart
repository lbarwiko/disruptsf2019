import 'package:flutter/material.dart';

class ExpenseReportPage extends StatefulWidget {
  final Map<String, dynamic> data;

  ExpenseReportPage(this.data);

  @override
  _ExpenseReportPageState createState() => _ExpenseReportPageState();
}

class _ExpenseReportPageState extends State<ExpenseReportPage> {

  @override
  void initState() {
    super.initState();
    processData(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense report'),
      ),
      body: Container(),
    );
  }

  void processData(Map<String, dynamic> data) {

  }
}
