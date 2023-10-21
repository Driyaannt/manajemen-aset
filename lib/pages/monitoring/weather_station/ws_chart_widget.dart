import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/weather_station/ws_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/weather_station.dart';

class WsChartWidget extends StatelessWidget {
  const WsChartWidget({
    Key? key,
    required this.wsController,
  }) : super(key: key);

  final WsController wsController;

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
        maximumLabels: 3,
        labelRotation: 270,
        // visibleMinimum: ((wsController.dataWS.length <= 30)
        //     ? 0
        //     : ((wsController.dataWS.length).toDouble() - 20)),
        // visibleMaximum: ((wsController.dataWS.length - 1).toDouble()),
      ),
      series: <ChartSeries>[
        FastLineSeries<WsData, dynamic>(
          name: 'Wind Speed (m/s)',
          dataSource: wsController.dataWS,
          enableTooltip: true,
          color: wsController.getColorByColorVar('windspeed'),
          xValueMapper: (WsData data, _) => data.dateUtc,
          yValueMapper: (WsData data, _) => double.parse(data.windSpeed),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WsData, dynamic>(
          name: 'Temp (C)',
          dataSource: wsController.dataWS,
          enableTooltip: true,
          color: wsController.getColorByColorVar('temp'),
          xValueMapper: (WsData data, _) => data.dateUtc,
          yValueMapper: (WsData data, _) => double.parse(data.temp),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WsData, dynamic>(
          name: 'UV Index',
          dataSource: wsController.dataWS,
          enableTooltip: true,
          color: wsController.getColorByColorVar('uv_index'),
          xValueMapper: (WsData data, _) => data.dateUtc,
          yValueMapper: (WsData data, _) => double.parse(data.uvIndex),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WsData, dynamic>(
          name: 'Solar Rad',
          dataSource: wsController.dataWS,
          enableTooltip: true,
          color: wsController.getColorByColorVar('solar_rad'),
          xValueMapper: (WsData data, _) => data.dateUtc,
          yValueMapper: (WsData data, _) => double.parse(data.solarRad),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<WsData, dynamic>(
          name: 'Curah Hujan',
          dataSource: wsController.dataWS,
          enableTooltip: true,
          color: wsController.getColorByColorVar('curah_hujan'),
          xValueMapper: (WsData data, _) => data.dateUtc,
          yValueMapper: (WsData data, _) => double.parse(data.curahHujan),
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
