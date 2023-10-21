import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/monitoring/produksi_energi/prod_energi_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/prod_energi.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  final ProdEnergiController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
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
        position: LegendPosition.top,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: TextStyle(fontSize: 15),
      ),
      primaryYAxis: NumericAxis(),
      primaryXAxis: CategoryAxis(title: AxisTitle(text: title)),
      series: <ChartSeries<dynamic, dynamic>>[
        StackedColumnSeries<ProdEnergiWtData, dynamic>(
          name: 'PLTB',
          groupName: 'Produksi Energi',
          dataSource: controller.dataWt,
          width: 1.0,
          spacing: 0.2,
          color: controller.getColorByColorVar('pltb'),
          xValueMapper: (ProdEnergiWtData data, _) => data.interval,
          yValueMapper: (ProdEnergiWtData data, _) =>
              double.parse(data.powerKwh),
        ),
        StackedColumnSeries<ProdEnergiDsData, dynamic>(
          name: 'PLTD',
          groupName: 'Produksi Energi',
          dataSource: controller.dataDs,
          width: 1.0,
          spacing: 0.2,
          color: controller.getColorByColorVar('pltd'),
          xValueMapper: (ProdEnergiDsData data, _) => data.interval,
          yValueMapper: (ProdEnergiDsData data, _) =>
              double.parse(data.powerKwh),
        ),
        StackedColumnSeries<ProdEnergiSpData, dynamic>(
          name: 'PLTS',
          groupName: 'Produksi Energi',
          dataSource: controller.dataSp,
          width: 1.0,
          spacing: 0.2,
          color: controller.getColorByColorVar('plts'),
          xValueMapper: (ProdEnergiSpData data, _) => data.interval,
          yValueMapper: (ProdEnergiSpData data, _) =>
              double.parse(data.powerKwh),
        ),
        StackedColumnSeries<ProdEnergiTotal, dynamic>(
          isVisibleInLegend: false,
          isVisible: true,
          isTrackVisible: false,
          enableTooltip: false,
          name: 'Total',
          groupName: 'Produksi Energi',
          dataSource: controller.dataAll,
          width: 1.0,
          spacing: 0.2,
          color: Colors.transparent,
          xValueMapper: (ProdEnergiTotal data, _) => data.interval,
          yValueMapper: (ProdEnergiTotal data, _) =>
              double.parse(data.powerKwh),
        ),
        StackedColumnSeries<LoadData, dynamic>(
          name: 'Load',
          groupName: 'Load',
          dataSource: controller.dataLoad,
          width: 1.0,
          spacing: 0.2,
          color: controller.getColorByColorVar('load'),
          xValueMapper: (LoadData data, _) => data.hours,
          yValueMapper: (LoadData data, _) => double.parse(data.powerKwh),
        ),
      ],
    );
  }
}