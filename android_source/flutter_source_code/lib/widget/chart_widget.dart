import 'package:flutter/material.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget sensorReadingChartView(
    {required List<SensorModel> arrayOfSensor,
    required AdaptiveSize adaptiveSize,
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
            border:
                Border.all(color: Colors.grey, width: chartBorderWidth ?? 2),
            borderRadius: BorderRadius.circular(chartBorderRadius ?? 6)),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptiveSize.adaptWidth(desiredSize: 16),
                      top: adaptiveSize.adaptHeight(desiredSize: 16)),
                  child: headingText1(
                      text: "Sensor Readings", adaptiveSize: adaptiveSize),
                )),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: "Water Ph"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                series: <LineSeries<SensorModel, String>>[
                  LineSeries<SensorModel, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      name: "ph",
                      dataSource: arrayOfSensor,
                      xValueMapper: (SensorModel data, _) =>
                          "${data.createdAt.month.toString()}/${data.createdAt.day.toString()}/${data.createdAt.hour.toString()}:${data.createdAt.minute.toString()}",
                      yValueMapper: (SensorModel data, _) => data.phReadings),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                title: ChartTitle(text: "Water Temperature"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SensorModel, String>>[
                  LineSeries<SensorModel, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      name: "°C",
                      dataSource: arrayOfSensor,
                      xValueMapper: (SensorModel data, _) =>
                          "${data.createdAt.month.toString()}/${data.createdAt.day.toString()}/${data.createdAt.hour.toString()}:${data.createdAt.minute.toString()}",
                      yValueMapper: (SensorModel data, _) => data.tempReadings),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                title: ChartTitle(text: "Water Usage"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SensorModel, String>>[
                  LineSeries<SensorModel, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      name: "Lt",
                      dataSource: arrayOfSensor,
                      xValueMapper: (SensorModel data, _) =>
                          "${data.createdAt.month.toString()}/${data.createdAt.day.toString()}/${data.createdAt.hour.toString()}:${data.createdAt.minute.toString()}",
                      yValueMapper: (SensorModel data, _) => data.waterUsage),
                ],
              ),
            ),
          ],
        ),
      ));
}

Widget dosingHistoryChartview(
    {required List<DosingProfileModel> inpDosingProfileModels,
    required AdaptiveSize adaptiveSize,
    required double chartWidth,
    required double chartHeight}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: chartWidth),
    height: adaptiveSize.adaptHeight(desiredSize: chartHeight),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: adaptiveSize.adaptWidth(desiredSize: 16),
                    top: adaptiveSize.adaptHeight(desiredSize: 16)),
                child: headingText1(
                    text: "Dosing History", adaptiveSize: adaptiveSize),
              )),
          const Spacer(),
          SizedBox(
            height: adaptiveSize.adaptHeight(
                desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
            child: SfCartesianChart(
              title: ChartTitle(text: "Alkalinity"),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: const Legend(isVisible: true),
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<DosingProfileModel, String>>[
                LineSeries<DosingProfileModel, String>(
                    name: "Alk",
                    dataSource: inpDosingProfileModels,
                    xValueMapper: (DosingProfileModel data, _) =>
                        "${data.dateTime!.month.toString()}/${data.dateTime!.day.toString()}/${data.dateTime!.hour.toString()}:${data.dateTime!.minute.toString()}",
                    yValueMapper: (DosingProfileModel data, _) =>
                        data.alkalinityDosage),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: adaptiveSize.adaptHeight(
                desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
            child: SfCartesianChart(
              title: ChartTitle(text: "Calcium"),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: const Legend(isVisible: true),
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<DosingProfileModel, String>>[
                LineSeries<DosingProfileModel, String>(
                    name: "Cal",
                    dataSource: inpDosingProfileModels,
                    xValueMapper: (DosingProfileModel data, _) =>
                        "${data.dateTime!.month.toString()}/${data.dateTime!.day.toString()}/${data.dateTime!.hour.toString()}:${data.dateTime!.minute.toString()}",
                    yValueMapper: (DosingProfileModel data, _) =>
                        data.calciumDosage),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: adaptiveSize.adaptHeight(
                desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
            child: SfCartesianChart(
              title: ChartTitle(text: "Magnesium"),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: const Legend(isVisible: true),
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<DosingProfileModel, String>>[
                LineSeries<DosingProfileModel, String>(
                    name: "Mag",
                    dataSource: inpDosingProfileModels,
                    xValueMapper: (DosingProfileModel data, _) =>
                        "${data.dateTime!.month.toString()}/${data.dateTime!.day.toString()}/${data.dateTime!.hour.toString()}:${data.dateTime!.minute.toString()}",
                    yValueMapper: (DosingProfileModel data, _) =>
                        data.magnesiumDosage),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget waterChemistryChartView(
    {required List<WaterChemistryModel> arrayOfParameter,
    required AdaptiveSize adaptiveSize,
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
            border:
                Border.all(color: Colors.grey, width: chartBorderWidth ?? 2),
            borderRadius: BorderRadius.circular(chartBorderRadius ?? 6)),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptiveSize.adaptWidth(desiredSize: 16),
                      top: adaptiveSize.adaptHeight(desiredSize: 16)),
                  child: headingText1(
                      text: chartName ?? "Water Chemistry",
                      adaptiveSize: adaptiveSize),
                )),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                title: ChartTitle(text: "Alkalinity"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<WaterChemistryModel, String>>[
                  LineSeries<WaterChemistryModel, String>(
                      name: "Alk",
                      dataSource: arrayOfParameter,
                      xValueMapper: (WaterChemistryModel data, _) =>
                          "${data.dateTime.month.toString()}/${data.dateTime.day.toString()}",
                      yValueMapper: (WaterChemistryModel data, _) =>
                          data.alkalinity),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                title: ChartTitle(text: "Calcium"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<WaterChemistryModel, String>>[
                  LineSeries<WaterChemistryModel, String>(
                      name: "Cal",
                      dataSource: arrayOfParameter,
                      xValueMapper: (WaterChemistryModel data, _) =>
                          "${data.dateTime.month.toString()}/${data.dateTime.day.toString()}",
                      yValueMapper: (WaterChemistryModel data, _) =>
                          data.calcium),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                title: ChartTitle(text: "Magnesium"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<WaterChemistryModel, String>>[
                  LineSeries<WaterChemistryModel, String>(
                      name: "Mag",
                      dataSource: arrayOfParameter,
                      xValueMapper: (WaterChemistryModel data, _) =>
                          "${data.dateTime.month.toString()}/${data.dateTime.day.toString()}",
                      yValueMapper: (WaterChemistryModel data, _) =>
                          data.magnesium),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: adaptiveSize.adaptHeight(
                  desiredSize: adaptiveSize.deviceSize.height / 10 * 3),
              child: SfCartesianChart(
                title: ChartTitle(text: chartName ?? "Salinity"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: const Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<WaterChemistryModel, String>>[
                  LineSeries<WaterChemistryModel, String>(
                      name: "Sal",
                      dataSource: arrayOfParameter,
                      xValueMapper: (WaterChemistryModel data, _) =>
                          "${data.dateTime.month.toString()}/${data.dateTime.day.toString()}",
                      yValueMapper: (WaterChemistryModel data, _) =>
                          data.salinity),
                ],
              ),
            ),
          ],
        )),
  );
}
