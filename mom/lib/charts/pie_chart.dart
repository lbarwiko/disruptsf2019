import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyPieChart extends StatefulWidget {
  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getRadiusPieChart(false),
    );
  }

  SfCircularChart getRadiusPieChart(bool isTileView) {
    return SfCircularChart(
      title: ChartTitle(
          text: isTileView
              ? ''
              : 'Expenditure by categories'),
      legend: Legend(
          isVisible: isTileView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap),
      series: getPieSeries(isTileView),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<PieSeries<_PieData, String>> getPieSeries(bool isTileView) {
    final List<_PieData> chartData = <_PieData>[
      _PieData('Argentina', 505370, '45%'),
      _PieData('Belgium', 551500, '53.7%'),
      _PieData('Cuba', 312685, '59.6%'),
      _PieData('Dominican Republic', 350000, '72.5%'),
      _PieData('Egypt', 301000, '85.8%'),
      _PieData('Kazakhstan', 300000, '90.5%'),
      _PieData('Somalia', 357022, '95.6%')
    ];
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
}

class _PieData {
  _PieData(this.xData, this.yData, [this.radius]);

  final String xData;
  final num yData;
  final String radius;
}
