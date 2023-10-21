import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/report_bt.dart';
import '../../../network/base_url_controller.dart';

class HistoryBtController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String idPerangkat;
  late TabController tabController;
  var isLoading = false.obs;
  DateTime? dateTime = DateTime.now();
  DateTime? monthTime = DateTime.now();
  var dataReport = ReportBt().obs;
  HistoryBtController(this.idPerangkat);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idPerangkat);
    tabController.addListener(() {
      if (tabController.index == 0) {
        fetchDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idPerangkat);
      } else if (tabController.index == 1) {
        fetchDataMonthly(DateFormat('yyyy-MM').format(monthTime!), idPerangkat);
      }
    });
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<HistoryBtController>();
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
        fetchDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idPerangkat);
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
        fetchDataMonthly(DateFormat('yyyy-MM').format(monthTime!), idPerangkat);
      }
    });
  }

  Future<void> fetchDataDaily(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoading(true);
      // [CL.05]
      Uri url = Uri.parse("$domain/api/cluster/wind-turbine/report-daily");
      var response = await http.post(
        url,
        body: {"id": id, "date_day": date},
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        dataReport.value = ReportBt.fromJson(jsonData);
      } else {
        throw Exception('Failed to report data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataDaily(date, id, retryCount: retryCount - 1);
      } else {
        Get.defaultDialog(
          middleText: 'Gagal Mengambil Data',
          onConfirm: () => fetchDataDaily(date, id),
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDataMonthly(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoading(true);
      // [CL.06]
      Uri url = Uri.parse("$domain/api/cluster/wind-turbine/report-monthly");
      var response = await http.post(
        url,
        body: {"id": id, "date_month": date},
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        dataReport.value = ReportBt.fromJson(jsonData);
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
