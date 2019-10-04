import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyLineChart extends StatefulWidget {
  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getDefaultSplineChart(false),
    );
  }

  SfCartesianChart getDefaultSplineChart(bool isTileView) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isTileView ? '' : 'Average high/low temperature of London'),
      legend: Legend(isVisible: isTileView ? false : true),
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          minimum: 30,
          maximum: 80,
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '\${value}',
          majorTickLines: MajorTickLines(size: 0)),
      series: getSplineSeries(isTileView),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<SplineSeries<_ChartData, String>> getSplineSeries(bool isTileView) {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData('Jan', 43, 41),
      _ChartData('Feb', 45, 45),
      _ChartData('Mar', 50, 48),
      _ChartData('Apr', 55, 52),
      _ChartData('May', 63, 57),
      _ChartData('Jun', 68, 61),
      _ChartData('Jul', 72, 66),
      _ChartData('Aug', 70, 66),
      _ChartData('Sep', 66, 63),
      _ChartData('Oct', 57, 55),
      _ChartData('Nov', 50, 50),
      _ChartData('Dec', 45, 45)
    ];
    return <SplineSeries<_ChartData, String>>[
      SplineSeries<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.high,
        markerSettings: MarkerSettings(isVisible: true),
        name: 'High',
      ),
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.high, this.average);

  final String x;
  final double high;
  final double average;
}
