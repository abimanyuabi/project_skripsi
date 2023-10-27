import 'package:flutter/material.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget sensorReadingChartView(
    {required List<SensorModel> arrayOfParameter,
    String? chartName,
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
        title: ChartTitle(text: chartName ?? "Parameter chart"),
        legend: const Legend(isVisible: true),
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<SensorModel, String>>[
          LineSeries<SensorModel, String>(
              name: "Ph",
              dataSource: arrayOfParameter,
              xValueMapper: (SensorModel data, _) =>
                  data.createdAt.month.toString() +
                  "/" +
                  data.createdAt.day.toString(),
              yValueMapper: (SensorModel data, _) => data.phReadings),
          LineSeries<SensorModel, String>(
              name: "Temp",
              dataSource: arrayOfParameter,
              xValueMapper: (SensorModel data, _) =>
                  data.createdAt.month.toString() +
                  "/" +
                  data.createdAt.day.toString(),
              yValueMapper: (SensorModel data, _) => data.tempReadings),
          LineSeries<SensorModel, String>(
              name: "Water Usage",
              dataSource: arrayOfParameter,
              xValueMapper: (SensorModel data, _) =>
                  data.createdAt.month.toString() +
                  "/" +
                  data.createdAt.day.toString(),
              yValueMapper: (SensorModel data, _) => data.waterUsage),
        ],
      ),
    ),
  );
}

Widget waterChemistryChartView(
    {required List<WaterChemistryModel> arrayOfParameter,
    String? chartName,
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
        title: ChartTitle(text: chartName ?? "Parameter chart"),
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<WaterChemistryModel, String>>[
          LineSeries<WaterChemistryModel, String>(
              name: "Alk",
              dataSource: arrayOfParameter,
              xValueMapper: (WaterChemistryModel data, _) =>
                  data.dateTime.month.toString() +
                  "/" +
                  data.dateTime.day.toString(),
              yValueMapper: (WaterChemistryModel data, _) => data.alkalinity),
          LineSeries<WaterChemistryModel, String>(
              name: "Cal",
              dataSource: arrayOfParameter,
              xValueMapper: (WaterChemistryModel data, _) =>
                  data.dateTime.month.toString() +
                  "/" +
                  data.dateTime.day.toString(),
              yValueMapper: (WaterChemistryModel data, _) => data.calcium),
          LineSeries<WaterChemistryModel, String>(
              name: "Mag",
              dataSource: arrayOfParameter,
              xValueMapper: (WaterChemistryModel data, _) =>
                  data.dateTime.month.toString() +
                  "/" +
                  data.dateTime.day.toString(),
              yValueMapper: (WaterChemistryModel data, _) => data.magnesium),
        ],
      ),
    ),
  );
}
