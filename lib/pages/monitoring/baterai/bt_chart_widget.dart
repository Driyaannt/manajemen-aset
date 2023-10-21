import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/baterai/bt_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BtChartWidget extends StatelessWidget {
  const BtChartWidget({
    Key? key,
    required this.btController,
  }) : super(key: key);

  final BtController btController;

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
        // visibleMinimum: ((btController.dataBt.length <= 30)
        //     ? 0
        //     : ((btController.dataBt.length).toDouble() - 20)),
        // visibleMaximum: ((btController.dataBt.length - 1).toDouble()),
      ),
      series: <ChartSeries>[
        FastLineSeries<dynamic, dynamic>(
          name: 'Power Baterai (W)',
          dataSource: btController.dataBt,
          enableTooltip: true,
          color: btController.getColorByColorVar('power'),
          xValueMapper: (dynamic data, _) => data.datetimeBt,
          yValueMapper: (dynamic data, _) => double.parse(data.powerBt),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<dynamic, dynamic>(
          name: 'Power Inverter (W)',
          dataSource: btController.dataIv,
          enableTooltip: true,
          color: btController.getColorByColorVar('power'),
          xValueMapper: (dynamic data, _) => data.datetimeIv,
          yValueMapper: (dynamic data, _) => double.parse(data.powerIv),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<dynamic, dynamic>(
          name: 'Tegangan (V)',
          dataSource: btController.dataBt,
          enableTooltip: true,
          color: btController.getColorByColorVar('volt'),
          xValueMapper: (dynamic data, _) => data.datetimeBt,
          yValueMapper: (dynamic data, _) => double.parse(data.voltBt),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<dynamic, dynamic>(
          name: 'Arus Baterai (A)',
          dataSource: btController.dataBt,
          enableTooltip: true,
          color: btController.getColorByColorVar('ampere'),
          xValueMapper: (dynamic data, _) => data.datetimeBt,
          yValueMapper: (dynamic data, _) => double.parse(data.ampereBt),
          yAxisName: 'yAxis',
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.triangle,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<dynamic, dynamic>(
          name: 'Arus Inverter (A)',
          dataSource: btController.dataIv,
          enableTooltip: true,
          color: btController.getColorByColorVar('ampere'),
          xValueMapper: (dynamic data, _) => data.datetimeIv,
          yValueMapper: (dynamic data, _) => double.parse(data.ampereIv),
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
