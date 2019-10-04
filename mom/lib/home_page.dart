import 'package:flutter/material.dart';
import 'package:mom/charts/pie_chart.dart';
import 'charts/line_area_chart.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = """Shreyas's""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name dashboard'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: MyLineChart(),
                ),
              ),
            ),
            Expanded(
                child: Container(
              child: MyPieChart(),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.portrait),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        },
      ),
    );
  }
}
