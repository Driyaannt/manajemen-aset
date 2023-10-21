import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/report_sp.dart';
import '../../../network/base_url_controller.dart';

class HistorySpController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String idPembangkit;
  late TabController tabController;
  var isLoading = false.obs;
  DateTime? dateTime = DateTime.now();
  DateTime? monthTime = DateTime.now();
  RxList<ReportSpData> dataSp = <ReportSpData>[].obs;
  Rx<ReportSp> reportSp = ReportSp().obs;

  HistorySpController(this.idPembangkit);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idPembangkit);
    tabController.addListener(() {
      if (tabController.index == 0) {
        dataSp.clear();
        fetchDataDaily(
            DateFormat('yyyy-MM-dd').format(dateTime!), idPembangkit);
      } else if (tabController.index == 1) {
        dataSp.clear();
        fetchDataMonthly(
            DateFormat('yyyy-MM').format(monthTime!), idPembangkit);
      }
    });
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<HistorySpController>();
    super.onClose();
  }

  getDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: dateTime!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value != null) {
        dateTime = value;
        fetchDataDaily(
            DateFormat('yyyy-MM-dd').format(dateTime!), idPembangkit);
      }
    });
  }

  getMonthPicker(BuildContext context) {
    showMonthPicker(
      context: context,
      initialDate: monthTime!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value != null) {
        monthTime = value;
        fetchDataMonthly(
            DateFormat('yyyy-MM').format(monthTime!), idPembangkit);
      }
    });
  }

  Future<void> fetchDataDaily(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoading(true);
      // [CL.02]
      Uri url = Uri.parse("$domain/api/cluster/power-production-daily");
      var response = await http.post(
        url,
        body: {"id": id, "date_day": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> spData = jsonData['solar_panel']["detail"];
        List<ReportSpData> newDataSp = [];

        for (var i = 0; i < spData.length; i++) {
          var hours = spData[i]['hours'];
          var solarRad = spData[i]['solar_rad'] ?? '0';
          var powerKwh = spData[i]['power_kwh'] ?? '0';
          var powerWatt = spData[i]['power_watt'] ?? '0';

          newDataSp.add(ReportSpData(
              interval: hours,
              powerKwh: powerKwh,
              powerWatt: powerWatt,
              solarRad: solarRad));
        }
        dataSp.assignAll(newDataSp);
        calculateSolarPanelStats(newDataSp);
      } else {
        throw Exception('Failed to report data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataDaily(date, id, retryCount: retryCount - 1);
      } else {
        throw Exception(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  ReportSp calculateSolarPanelStats(List<dynamic> reportSpList) {
    double totalSolarRad = 0;
    double minSolarRad = double.infinity;
    double maxSolarRad = 0;
    double totalPowerKwh = 0;
    double minPowerKwh = double.infinity;
    double maxPowerKwh = 0;
    double totalPowerWatt = 0;
    double minPowerWatt = double.infinity;
    double maxPowerWatt = 0;

    for (var i = 0; i < reportSpList.length; i++) {
      final solarRad = double.parse(reportSpList[i].solarRad.toString());
      final powerKwh = double.parse(reportSpList[i].powerKwh.toString());
      final powerWatt = double.parse(reportSpList[i].powerWatt.toString());

      // hitung semua data
      totalSolarRad += solarRad;
      totalPowerKwh += powerKwh;
      totalPowerWatt += powerWatt;

      // mencari nilai min
      if (solarRad < minSolarRad) {
        minSolarRad = solarRad;
      }
      if (powerKwh < minPowerKwh) {
        minPowerKwh = powerKwh;
      }
      if (powerWatt < minPowerWatt) {
        minPowerWatt = powerWatt;
      }

      // mencari nilai max
      if (solarRad > maxSolarRad) {
        maxSolarRad = solarRad;
      }
      if (powerKwh > maxPowerKwh) {
        maxPowerKwh = powerKwh;
      }
      if (powerWatt > maxPowerWatt) {
        maxPowerWatt = powerWatt;
      }
    }

    // hitung avg
    final avgSolarRad = totalSolarRad / reportSpList.length;
    final avgPowerKwh = totalPowerKwh / reportSpList.length;
    final avgPowerWatt = totalPowerWatt / reportSpList.length;

    ReportSp calculatedReportSp = ReportSp(
      minSolarRad: minSolarRad,
      maxSolarRad: maxSolarRad,
      avgSolarRad: avgSolarRad,
      minPower: minPowerWatt,
      maxPower: maxPowerWatt,
      avgPower: avgPowerWatt,
      minProdKwh: minPowerKwh,
      maxProdKwh: maxPowerKwh,
      avgProdKwh: avgPowerKwh,
    );
    return reportSp.value = calculatedReportSp;
  }

  Future<void> fetchDataMonthly(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoading(true);
      // [CL.03]
      Uri url = Uri.parse("$domain/api/cluster/power-production-monthly");
      var response = await http.post(
        url,
        body: {"id": id, "date_month": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> spData = jsonData['solar_panel']["detail"];
        List<ReportSpData> newDataSp = [];

        for (var i = 0; i < spData.length; i++) {
          var days = spData[i]['days'];
          var solarRad = spData[i]['solar_rad'] ?? '0';
          var powerKwh = spData[i]['power_kwh'] ?? '0';
          var powerWatt = spData[i]['power_watt'] ?? '0';

          newDataSp.add(ReportSpData(
              interval: days,
              powerKwh: powerKwh,
              powerWatt: powerWatt,
              solarRad: solarRad));
        }
        dataSp.assignAll(newDataSp);
        calculateSolarPanelStats(newDataSp);
      } else {
        throw Exception('Failed to report data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataMonthly(date, id, retryCount: retryCount - 1);
      } else {
        throw Exception(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }
}
