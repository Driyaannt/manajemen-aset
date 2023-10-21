import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manajemen_aset/models/config_colors.dart';
import 'package:manajemen_aset/models/notif.dart';

import '../../../models/solar_panel.dart';
import '../../../network/base_url_controller.dart';

class SpController extends GetxController {
  final String idSp;
  var isLoadingData = false.obs;
  var isLoadingNotif = false.obs;
  var isLoadingProd = false.obs;
  var isLoadingConfig = false.obs;
  var dataLoadedSuccessfully = true.obs;
  var notifLoadedSuccessfully = true.obs;
  var prodLoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;
  DateTime? dateTime = DateTime.now();

  RxList<SpData> dataSp = <SpData>[].obs;
  var configColors = <ConfigColors>[].obs;
  var notif = NotifSp().obs;
  var dataDailyProd = SpDailyProd().obs;

  SpController(this.idSp);

  @override
  void onInit() {
    super.onInit();
    fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), idSp);
    fetchNotif(idSp);
    fetchDailyProd(DateFormat('yyyy-MM-dd').format(dateTime!), idSp);
    fetchConfigColors();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<SpController>();
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
        fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), idSp);
        fetchDailyProd(DateFormat('yyyy-MM-dd').format(dateTime!), idSp);
      }
    });
  }

  Future<void> refreshData() async {
    // Implementasikan logika refresh data di sini
    // Misalnya, panggil method untuk memuat ulang data dari server
    dataSp.clear();
    configColors.clear();

    fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), idSp);
    fetchNotif(idSp);
    fetchDailyProd(DateFormat('yyyy-MM-dd').format(dateTime!), idSp);
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
        body: {"sp_id": id},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        notif.value = NotifSp.fromJson(jsonResponse);
        notifLoadedSuccessfully(true);
      } else {
        notifLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        await fetchNotif(id, retryCount: retryCount - 1);
      } else {
        notifLoadedSuccessfully(false);
      }
    } finally {
      isLoadingNotif(false);
    }
  }

  // mangambil data daily prod solar panel
  Future<void> fetchDailyProd(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingProd(true);
      // [SP.03]
      Uri url = Uri.parse("$domain/api/solar-panel/daily-production");
      var response = await http.post(
        url,
        body: {"id": id, "date_day": date},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        dataDailyProd.value = SpDailyProd.fromJson(jsonResponse);
        prodLoadedSuccessfully(true);
      } else {
        prodLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        await fetchDailyProd(date, id, retryCount: retryCount - 1);
      } else {
        dataLoadedSuccessfully(false);
      }
    } finally {
      isLoadingProd(false);
    }
  }

  // mengambil data wind turbine
  Future<void> fetchDataSp(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingData(true);
      // [SP.01]
      Uri url = Uri.parse("$domain/api/solar-panel/realtime-by-date");
      var response = await http.post(
        url,
        body: {"id": id, "date": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataSp == [];
          dataSp.clear();
        } else {
          List<dynamic> realData = jsonData['data'];
          List<SpData> newDataSp = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var solarRad = realData[i]['solar_rad'];
            var energiPrimer = realData[i]['energi_primer'];
            var volt = realData[i]['volt'];
            var ampere = realData[i]['ampere'];
            var power = realData[i]['power'];

            newDataSp.add(SpData(
              dateTime,
              solarRad,
              energiPrimer,
              volt,
              ampere,
              power,
            ));
          }
          dataSp.assignAll(newDataSp);
          dataLoadedSuccessfully(true);
        }
      } else {
        dataLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        await fetchDataSp(date, id, retryCount: retryCount - 1);
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
        configColors.addAll(configColorsData);
        configLoadedSuccessfully(true);
      } else {
        configLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        Future.delayed(const Duration(seconds: 1));
        return fetchConfigColors(retryCount: retryCount - 1);
      } else {
        configLoadedSuccessfully(false);
      }
    } finally {
      isLoadingConfig(false);
    }
  }

  getColorByColorVar(String colorVar) {
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
