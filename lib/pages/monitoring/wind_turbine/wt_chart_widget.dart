import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/wind_turbine/wt_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/wind_turbine.dart';

class WtChartWidget extends StatelessWidget {
  const WtChartWidget({
    Key? key,
    required this.wtController,
  }) : super(key: key);

  final WtController wtController;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.longPress,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      ),
      legend: const Legend(
        isVisible: true,
        height: '50%',
        width: '100%',
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      // Konfigurasi grafik di sini
      axes: <ChartAxis>[
        NumericAxis(
          name: 'yAxis',
          opposedPosition: true,
        )
      ],
      primaryXAxis: CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 100,
        zoomFactor: 0.95,
        labelRotation: 270,
        // visibleMinimum: ((wtController.dataWt.length <= 30)
        //     ? 0
        //     : ((wtController.dataWt.length).toDouble() - 20)),
        // visibleMaximum: ((wtController.dataWt.length - 1).toDouble()),
      ),
      series: <ChartSeries>[
        FastLineSeries<WtData, dynamic>(
          name: 'Wind Speed (m/s)',
          dataSource: wtController.dataWt.toList(),
          enableTooltip: true,
          color: wtController.getColorByColorVar('windspeed'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.windSpeed),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WtData, dynamic>(
          name: 'Rpm Bilah',
          dataSource: wtController.dataWt,
          enableTooltip: true,
          color: wtController.getColorByColorVar('rpm_bilah'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.rpmBilah),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WtData, dynamic>(
          name: 'Rpm Generator',
          dataSource: wtController.dataWt,
          enableTooltip: true,
          color: wtController.getColorByColorVar('rpm_gen'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.rpmGenerator),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WtData, dynamic>(
          name: 'Power (W)',
          dataSource: wtController.dataWt,
          enableTooltip: true,
          color: wtController.getColorByColorVar('power'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.powerWatt),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WtData, dynamic>(
          name: 'Tegangan (V)',
          dataSource: wtController.dataWt,
          enableTooltip: true,
          color: wtController.getColorByColorVar('volt'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.voltDc),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WtData, dynamic>(
          name: 'Arus (A)',
          dataSource: wtController.dataWt,
          enableTooltip: true,
          color: wtController.getColorByColorVar('ampere'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.ampereDc),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
      ],
    );
  }
}
