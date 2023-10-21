import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/report_ws.dart';
import '../../../network/base_url_controller.dart';

class HistoryWsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String idPerangkat;
  late TabController tabController;
  var isLoading = false.obs;
  DateTime? dateTime = DateTime.now();
  DateTime? monthTime = DateTime.now();
  RxList<ReportWs> dataReport = <ReportWs>[].obs;
  RxList<ReportWsMonth> dataReportMonth = <ReportWsMonth>[].obs;

  HistoryWsController(this.idPerangkat);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchDataDaily(DateFormat('yyyy-MM').format(dateTime!),
        DateFormat('d').format(dateTime!), idPerangkat);
    tabController.addListener(() {
      if (tabController.index == 0) {
        fetchDataDaily(DateFormat('yyyy-MM').format(dateTime!),
            DateFormat('d').format(dateTime!), idPerangkat);
      } else if (tabController.index == 1) {
        fetchDataMonthly(DateFormat('yyyy-MM').format(monthTime!),
            DateFormat('yyyyMM').format(monthTime!), idPerangkat);
      }
    });
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<HistoryWsController>();
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
        fetchDataDaily(DateFormat('yyyy-MM').format(dateTime!),
            DateFormat('d').format(dateTime!), idPerangkat);
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
        fetchDataMonthly(DateFormat('yyyy-MM').format(monthTime!),
            DateFormat('yyyyMM').format(monthTime!), idPerangkat);
      }
    });
  }

  Future<void> fetchDataDaily(String dateMonth, String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoading(true);
      // [WS.06]
      Uri url = Uri.parse("$domain/api/weather-station/report-monthly");
      var response = await http.post(
        url,
        body: {"id": id, "date_month": dateMonth},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<ReportWs> newDataWs = [];

        for (var item in jsonData) {
          if (item['date_day'] == date) {
            var report = ReportWs.fromJson(item);
            newDataWs.add(report);
          }
        }
        dataReport.assignAll(newDataWs);
      } else {
        throw Exception('Failed to report data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 5));
        await fetchDataDaily(dateMonth, date, id, retryCount: retryCount - 1);
      } else {
        Get.defaultDialog(
          middleText: 'Gagal Mengambil Data',
          onConfirm: () => fetchDataDaily(dateMonth, date, id),
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDataMonthly(String dateMonth, String month, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoading(true);
      // [WS.07]
      Uri url = Uri.parse("$domain/api/weather-station/report-yearly");
      var response = await http.post(
        url,
        body: {"id": id, "date_month": dateMonth},
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<ReportWsMonth> newDataWs = [];

        for (var item in jsonData) {
          if (item['date_month'] == month) {
            var report = ReportWsMonth.fromJson(item);
            newDataWs.add(report);
          }
        }
        dataReportMonth.assignAll(newDataWs);
      } else {
        throw Exception('Failed to report data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 5));
        await fetchDataMonthly(dateMonth, month, id,
            retryCount: retryCount - 1);
      } else {
        throw Exception(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }
}
