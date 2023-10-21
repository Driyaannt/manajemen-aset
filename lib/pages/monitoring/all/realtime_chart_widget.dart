import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/all/realtime_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/realtime_energy.dart';

class RealtimeChartWidget extends StatelessWidget {
  const RealtimeChartWidget({
    Key? key,
    required this.realtimeController,
  }) : super(key: key);

  final RealtimeController realtimeController;

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
        maximumLabels: 3,
        // visibleMinimum: ((realtimeController.dataWt.length <= 30)
        //     ? 0
        //     : ((realtimeController.dataWt.length).toDouble() - 20)),
        // visibleMaximum: ((realtimeController.dataWt.length - 1).toDouble()),
      ),
      series: <ChartSeries>[
        FastLineSeries<RealtimeEnergyWt, dynamic>(
          name: 'Power PLTB (W)',
          dataSource: realtimeController.dataWt.toList(),
          enableTooltip: true,
          color: realtimeController.getColorByColorVar('pltb'),
          xValueMapper: (RealtimeEnergyWt data, _) => data.dateUtc,
          yValueMapper: (RealtimeEnergyWt data, _) =>
              double.parse(data.powerWatt),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<RealtimeEnergyWt, dynamic>(
          name: 'Wind Speed (m/s)',
          dataSource: realtimeController.dataWt,
          enableTooltip: true,
          color: realtimeController.getColorByColorVar('windspeed'),
          xValueMapper: (RealtimeEnergyWt data, _) => data.dateUtc,
          yValueMapper: (RealtimeEnergyWt data, _) =>
              double.parse(data.windSpeed),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<RealtimeEnergySp, dynamic>(
          name: 'Power PLTS (W)',
          dataSource: realtimeController.dataSp,
          enableTooltip: true,
          color: realtimeController.getColorByColorVar('plts'),
          xValueMapper: (RealtimeEnergySp data, _) => data.dateUtc,
          yValueMapper: (RealtimeEnergySp data, _) =>
              double.parse(data.powerSp),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<RealtimeEnergySp, dynamic>(
          name: 'Solar Rad (W/m²)',
          dataSource: realtimeController.dataSp,
          enableTooltip: true,
          color: realtimeController.getColorByColorVar('solar_rad'),
          xValueMapper: (RealtimeEnergySp data, _) => data.dateUtc,
          yValueMapper: (RealtimeEnergySp data, _) =>
              double.parse(data.solarRad),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<RealtimeEnergySp, dynamic>(
          name: 'Power PLTD (W)',
          dataSource: realtimeController.dataSp,
          enableTooltip: true,
          color: realtimeController.getColorByColorVar('volt'),
          xValueMapper: (RealtimeEnergySp data, _) => data.dateUtc,
          yValueMapper: (RealtimeEnergySp data, _) =>
              double.parse(data.powerDiesel),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<RealtimeEnergySp, dynamic>(
          name: 'BBM (liter)',
          dataSource: realtimeController.dataSp,
          enableTooltip: true,
          color: realtimeController.getColorByColorVar('ampere'),
          xValueMapper: (RealtimeEnergySp data, _) => data.dateUtc,
          yValueMapper: (RealtimeEnergySp data, _) => double.parse(data.bbm),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
      ],
    );
  }
}
