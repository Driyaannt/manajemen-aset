import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manajemen_aset/models/config_colors.dart';
import 'package:manajemen_aset/models/notif.dart';
import 'package:manajemen_aset/network/base_url_controller.dart';

import '../../../models/weather_station.dart';

class WsController extends GetxController {
  final String idWs;
  var isLoadingData = false.obs;
  var isLoadingNotif = false.obs;
  var isLoadingConfig = false.obs;
  var dataLoadedSuccessfully = true.obs;
  var notifLoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;
  DateTime? dateTime = DateTime.now();

  RxList<WsData> dataWS = <WsData>[].obs;
  var configColors = <ConfigColors>[].obs;
  var notif = NotifWs().obs;

  WsController(this.idWs);

  @override
  void onInit() {
    super.onInit();
    fetchDataWs(DateFormat('yyyy-MM-dd 23:mm:ss').format(dateTime!), idWs);
    fetchNotif(idWs);
    fetchConfigColors();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<WsController>();
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
        fetchDataWs(DateFormat('yyyy-MM-dd 23:mm:ss').format(dateTime!), idWs);
      }
    });
  }

  Future<void> refreshData() async {
    // Implementasikan logika refresh data di sini
    // Misalnya, panggil method untuk memuat ulang data dari server
    dataWS.clear();
    configColors.clear();

    fetchDataWs(DateFormat('yyyy-MM-dd 23:mm:ss').format(dateTime!), idWs);
    fetchNotif(idWs);
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
        body: {"ws_id": id},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        notif.value = NotifWs.fromJson(jsonResponse);
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

  // mengambil data wind turbine
  Future<void> fetchDataWs(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingData(true);
      // [WS.03]
      Uri url = Uri.parse("$domain/api/weather-station/status");
      var response = await http.post(
        url,
        body: {"id": id, "date": date, "draw": "1"},
      );
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        // cek apakah jsonData['real_data'] null
        if (jsonData['real_data'] == null || jsonData['real_data'].isEmpty) {
          dataWS == [];
          dataWS.clear();
          dataLoadedSuccessfully(true);
        } else {
          List<dynamic> realData = jsonData['real_data'];
          List<WsData> newDataWS = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['date']));
            var windSpeed = realData[i]['wind_speed'];
            var curahHujan = realData[i]['curah_hujan'];
            var windDir = realData[i]['wind_dir'];
            var temp = realData[i]['temp'];
            var uvIndex = realData[i]['uv_index'];
            var solarRad = realData[i]['solar_rad'];

            newDataWS.add(WsData(
              dateTime,
              windSpeed,
              curahHujan,
              windDir,
              temp,
              uvIndex,
              solarRad,
            ));
          }
          dataWS.assignAll(newDataWS);
          dataLoadedSuccessfully(true);
        }
      } else {
        dataLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        await fetchDataWs(date, id, retryCount: retryCount - 1);
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
        await Future.delayed(const Duration(seconds: 1));
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
