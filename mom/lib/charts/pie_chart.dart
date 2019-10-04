import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class MyPieChart extends StatefulWidget {
  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getRadiusPieChart(false),
    );
  }

  SfCircularChart getRadiusPieChart(bool isTileView) {
    return SfCircularChart(
      title: ChartTitle(text: isTileView ? '' : 'Expenditure by categories'),
      legend: Legend(
          isVisible: isTileView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap),
      series: getPieSeries(isTileView),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<PieSeries<_PieData, String>> getPieSeries(bool isTileView) {
    return <PieSeries<_PieData, String>>[
      PieSeries<_PieData, String>(
          dataSource: chartData,
          xValueMapper: (_PieData data, _) => data.xData,
          yValueMapper: (_PieData data, _) => data.yData,
          dataLabelMapper: (_PieData data, _) => data.xData,
          startAngle: 100,
          endAngle: 100,
          pointRadiusMapper: (_PieData data, _) => data.radius,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }

  final List<_PieData> chartData = <_PieData>[];

  void loadData() async {
    setState(() {
      chartData.clear();
    });
    var response = await http.get('$BASE_URL/transactionData');
    Map<String, dynamic> responseMap = json.decode(response.body);
    Map<String, dynamic> cateogories = responseMap['cateogories'];
    for (String key in cateogories.keys) {
      var data = _PieData(key, cateogories[key],
          (100.0 * (1 - (cateogories[key] / 100))).toString());
      chartData.add(data);
    }
    chartData.sort((_PieData a, _PieData b) {
      return b.yData - a.yData;
    });
    setState(() {});
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.radius]);

  final String xData;
  final num yData;
  final String radius;
}
