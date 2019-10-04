import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;

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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: getDefaultSplineChart(false),
        ),
      ),
    );
  }

  SfCartesianChart getDefaultSplineChart(bool isTileView) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isTileView ? '' : 'Predicted expenses'),
      legend: Legend(isVisible: false),
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          minimum: 50,
          maximum: 150,
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '\${value}',
          majorTickLines: MajorTickLines(size: 0)),
      series: getSplineSeries(isTileView),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<SplineSeries<_ChartData, String>> getSplineSeries(bool isTileView) {
    return <SplineSeries<_ChartData, String>>[
      SplineSeries<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.high,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      SplineSeries<_ChartData, String>(
        enableTooltip: false,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x ,
        yValueMapper: (_ChartData sales, _) => sales.high + 10,
        markerSettings: MarkerSettings(isVisible: false),
      ),
    ];
  }

  final List<_ChartData> chartData = <_ChartData>[];

  void processData(var data) async {
    setState(() {
      chartData.clear();
    });

    var spendingList = data['spending'];

    var initialDate = DateTime.now().subtract(Duration(days: 23));
    double prev = 0;
    for (double spending in spendingList) {
      print('spending ${spending - prev}');
      var data =
          _ChartData(DateFormat('Md').format(initialDate), spending - prev);
      prev = spending;
      chartData.add(data);
      initialDate = initialDate.add(Duration(days: 1));
    }



    setState(() {});
  }
}

class _ChartData {
  _ChartData(this.x, this.high);

  final String x;
  final double high;
}
