import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class MyLineChart extends StatefulWidget {
  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  static const String BASE_URL = "https://ead733c0.ngrok.io";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getDefaultSplineChart(false),
    );
  }

  SfCartesianChart getDefaultSplineChart(bool isTileView) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isTileView ? '' : 'Previous month expenditure'),
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
    ];
  }

  final List<_ChartData> chartData = <_ChartData>[];

  void loadData() async {
    setState(() {
      chartData.clear();
    });
    var response = await http.get('$BASE_URL/transactionData');
    Map<String, dynamic> responseMap = json.decode(response.body);
    var spendingList = responseMap['spending'];
    var income = responseMap['income'];
    var cateogories = responseMap['cateogories'];

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
