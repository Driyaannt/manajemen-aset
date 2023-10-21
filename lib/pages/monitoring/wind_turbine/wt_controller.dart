import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manajemen_aset/models/config_colors.dart';
import 'package:manajemen_aset/models/notif.dart';
import 'package:manajemen_aset/models/wind_turbine.dart';

import '../../../network/base_url_controller.dart';

class WtController extends GetxController {
  final String idWt;
  var isLoadingData = false.obs;
  var isLoadingNotif = false.obs;
  var isLoadingProd = false.obs;
  var isLoadingConfig = false.obs;
  var dataLoadedSuccessfully = true.obs;
  var notifLoadedSuccessfully = true.obs;
  var prodLoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;

  DateTime? dateTime = DateTime.now();

  RxList<WtData> dataWt = <WtData>[].obs;
  var configColors = <ConfigColors>[].obs;
  var notif = NotifWt().obs;
  var dataDailyProd = WtDailyProd().obs;

  WtController(this.idWt);

  @override
  void onInit() {
    super.onInit();
    fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), idWt);
    fetchNotif(idWt);
    fetchDailyProd(DateFormat('yyyy-MM-dd').format(dateTime!), idWt);
    fetchConfigColors();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<WtController>();
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
        // update();
        fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), idWt);
        fetchDailyProd(DateFormat('yyyy-MM-dd').format(dateTime!), idWt);
      }
    });
  }

  Future<void> refreshData() async {
    dataWt.clear();
    configColors.clear();

    fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), idWt);
    fetchNotif(idWt);
    fetchDailyProd(DateFormat('yyyy-MM-dd').format(dateTime!), idWt);
    fetchConfigColors();
  }

  // mengambil data notifikasi live data
  Future<void> fetchNotif(String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingNotif(true);
      // [NTF.01]
      Uri url = Uri.parse("$domain/api/notif/livedata-status");
      var response = await http.post(
        url,
        body: {"wt_id": id},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        notif.value = NotifWt.fromJson(jsonResponse);
        notifLoadedSuccessfully(true);
      } else {
        notifLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchNotif(id, retryCount: retryCount - 1);
      } else {
        notifLoadedSuccessfully(false);
      }
    } finally {
      isLoadingNotif(false);
    }
  }

  // mangambil data wind turbine
  Future<void> fetchDailyProd(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingProd(true);
      // [WT.08]
      Uri url = Uri.parse("$domain/api/wind-turbine/daily-production");
      var response = await http.post(
        url,
        body: {"id": id, "date_day": date},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        dataDailyProd.value = WtDailyProd.fromJson(jsonResponse);
        prodLoadedSuccessfully(true);
      } else {
        prodLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDailyProd(date, id, retryCount: retryCount - 1);
      } else {
        prodLoadedSuccessfully(false);
      }
    } finally {
      isLoadingProd(false);
    }
  }

  // mengambil data wind turbine
  Future<void> fetchDataWt(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingData(true);
      // [WT.01]
      Uri url = Uri.parse("$domain/api/wind-turbine/get-day-alldata");
      var response = await http.post(
        url,
        body: {"id": id, "date": date},
      );
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataWt == [];
          dataWt.clear();
        } else {
          List<dynamic> realData = jsonData['data'];
          List<WtData> newDataWt = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['date_utc']));
            var windSpeed = realData[i]['wind_speed'];
            var rpmBilah = realData[i]['rpm_bilah'];
            var rpmGenerator = realData[i]['rpm_generator'];
            var ampereDc = realData[i]['ampere_dc'];
            var voltDc = realData[i]['volt_dc'];
            var powerWatt = realData[i]['power_watt'];
            // dataWt.clear();
            newDataWt.add(WtData(
              dateTime,
              windSpeed,
              rpmBilah,
              rpmGenerator,
              powerWatt,
              ampereDc,
              voltDc,
            ));
          }
          dataWt.assignAll(newDataWt);
          dataLoadedSuccessfully(true);
        }
      } else {
        dataLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataWt(date, id, retryCount: retryCount - 1);
      } else {
        dataLoadedSuccessfully(false);
      }
    } finally {
      isLoadingData(false);
    }
  }

  // mengambil data config color
  Future<void> fetchConfigColors({int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingConfig(true);
      // [DC.01]
      Uri url = Uri.parse("$domain/api/config-colors/get-data");
      var response = await http.post(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<ConfigColors> configColorsData =
            jsonResponse.map((data) => ConfigColors.fromJson(data)).toList();
        configColors.assignAll(configColorsData);
        configLoadedSuccessfully(true);
      } else {
        configLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchConfigColors(retryCount: retryCount - 1);
      } else {
        configLoadedSuccessfully(false);
      }
    } finally {
      isLoadingConfig(false);
    }
  }

  getColorByColorVar(String colorVar) {
    if (configColors.isNotEmpty) {
      ConfigColors colorItem;
      try {
        colorItem = configColors.firstWhere(
          (color) => color.colorVar.toLowerCase() == colorVar.toLowerCase(),
        );
        return Color(int.parse(colorItem.colorCode.replaceAll('#', '0xFF')));
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }
}
