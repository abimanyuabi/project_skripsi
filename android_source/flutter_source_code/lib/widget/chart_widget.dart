import 'package:flutter/material.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget chartView(
    {required List<ParameterModel> arrayOfParameter,
    double? chartWidth,
    double? chartHeight,
    double? chartBorderWidth,
    double? chartBorderRadius}) {
  return SizedBox(
    width: chartWidth,
    height: chartHeight,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: chartBorderWidth ?? 2),
          borderRadius: BorderRadius.circular(chartBorderRadius ?? 6)),
      child: SfCartesianChart(
        title: ChartTitle(text: "Parameter chart"),
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: LineSeries<ParameterModel, String>(
            dataSource: arrayOfParameter,
            xValueMapper: (ParameterModel data, _) =>
                data.sensorModel.phReadings.toString(),
            yValueMapper: (ParameterModel data, _) =>
                data.sensorModel.createdAt.month +
                data.sensorModel.createdAt.day +
                data.sensorModel.createdAt.hour),
      ),
    ),
  );
}
