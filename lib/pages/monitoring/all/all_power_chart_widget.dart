import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/all/all_power_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/baterai.dart';
import '../../../models/diesel.dart';
import '../../../models/inverter.dart';
import '../../../models/load.dart';
import '../../../models/solar_panel.dart';
import '../../../models/wind_turbine.dart';

class AllPowerChartWidget extends StatelessWidget {
  const AllPowerChartWidget({
    Key? key,
    required this.allPowerC,
  }) : super(key: key);

  final AllPowerController allPowerC;

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
          labelRotation: 270
          // visibleMinimum: ((allPowerC.dataWt.length <= 30)
          //     ? 0
          //     : ((allPowerC.dataWt.length).toDouble() - 20)),
          // visibleMaximum: ((allPowerC.dataWt.length - 1).toDouble()),
          ),
      series: <ChartSeries>[
        FastLineSeries<WtData, dynamic>(
          name: 'Power PLTB (W)',
          dataSource: allPowerC.dataWt,
          enableTooltip: true,
          color: allPowerC.getColorByColorVar('pltb'),
          xValueMapper: (WtData data, _) => data.dateUtc,
          yValueMapper: (WtData data, _) => double.parse(data.powerWatt),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<SpData, dynamic>(
          name: 'Power PLTS (W)',
          dataSource: allPowerC.dataSp,
          enableTooltip: true,
          color: allPowerC.getColorByColorVar('plts'),
          xValueMapper: (SpData data, _) => data.dateTime,
          yValueMapper: (SpData data, _) => double.parse(data.power),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<DieselData, dynamic>(
          name: 'Power PLTD (W)',
          dataSource: allPowerC.dataDs,
          enableTooltip: true,
          color: allPowerC.getColorByColorVar('pltd'),
          xValueMapper: (DieselData data, _) => data.datetime,
          yValueMapper: (DieselData data, _) => double.parse(data.power),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<BateraiData, dynamic>(
          name: 'Power Baterai (W)',
          dataSource: allPowerC.dataBt,
          enableTooltip: true,
          color: allPowerC.getColorByColorVar('bat'),
          xValueMapper: (BateraiData data, _) => data.datetimeBt,
          yValueMapper: (BateraiData data, _) => double.parse(data.powerBt),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<InverterData, dynamic>(
          name: 'Power Inverter (W)',
          dataSource: allPowerC.dataIv,
          enableTooltip: true,
          color: allPowerC.getColorByColorVar('inv'),
          xValueMapper: (InverterData data, _) => data.datetimeIv,
          yValueMapper: (InverterData data, _) => double.parse(data.powerIv),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 0,
        ),
        FastLineSeries<Load, dynamic>(
          name: 'Power Load (W)',
          dataSource: allPowerC.dataLoad,
          enableTooltip: true,
          color: allPowerC.getColorByColorVar('load'),
          xValueMapper: (Load data, _) => data.datetime,
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          yValueMapper: (Load data, _) => double.parse(data.power),
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
