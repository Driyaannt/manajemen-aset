import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/solar_panel/sp_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/solar_panel.dart';

class SpChartWidget extends StatelessWidget {
  const SpChartWidget({
    Key? key,
    required this.spController,
  }) : super(key: key);

  final SpController spController;

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
        // visibleMinimum: ((spController.dataSp.length <= 30)
        //     ? 0
        //     : ((spController.dataSp.length).toDouble() - 20)),
        // visibleMaximum: ((spController.dataSp.length - 1).toDouble()),
      ),
      series: <ChartSeries>[
        FastLineSeries<SpData, dynamic>(
          name: 'Solar Rad',
          dataSource: spController.dataSp.toList(),
          enableTooltip: true,
          color: spController.getColorByColorVar('solar_rad'),
          xValueMapper: (SpData data, _) => data.dateTime,
          yValueMapper: (SpData data, _) => double.parse(data.solarRad),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<SpData, dynamic>(
          name: 'Power (W)',
          dataSource: spController.dataSp.toList(),
          enableTooltip: true,
          color: spController.getColorByColorVar('power'),
          xValueMapper: (SpData data, _) => data.dateTime,
          yValueMapper: (SpData data, _) => double.parse(data.power),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<SpData, dynamic>(
          name: 'Tegangan (V)',
          dataSource: spController.dataSp.toList(),
          enableTooltip: true,
          color: spController.getColorByColorVar('volt'),
          xValueMapper: (SpData data, _) => data.dateTime,
          yValueMapper: (SpData data, _) => double.parse(data.volt),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<SpData, dynamic>(
          name: 'Arus (A)',
          dataSource: spController.dataSp.toList(),
          enableTooltip: true,
          color: spController.getColorByColorVar('ampere'),
          xValueMapper: (SpData data, _) => data.dateTime,
          yValueMapper: (SpData data, _) => double.parse(data.ampere),
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
