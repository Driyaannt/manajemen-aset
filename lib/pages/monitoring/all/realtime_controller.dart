import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manajemen_aset/models/api.dart';
import 'package:manajemen_aset/models/config_colors.dart';

import '../../../models/realtime_energy.dart';
import '../../../network/base_url_controller.dart';

class RealtimeController extends GetxController {
  final String idCluster;
  final ApiModel apiModel;
  var isLoadingDataWt = false.obs;
  var isLoadingDataSp = false.obs;
  var isLoadingConfig = false.obs;
  var dataWtLoadedSuccessfully = true.obs;
  var dataSpLoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;
  DateTime? dateTime = DateTime.now();

  RxList<RealtimeEnergyWt> dataWt = <RealtimeEnergyWt>[].obs;
  RxList<RealtimeEnergySp> dataSp = <RealtimeEnergySp>[].obs;
  var configColors = <ConfigColors>[].obs;

  RealtimeController(this.idCluster, this.apiModel);

  @override
  void onInit() {
    super.onInit();
    fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
    fetchConfigColors();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<RealtimeController>();
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
        fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
        fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
      }
    });
  }

  Future<void> refreshData() async {
    dataWt.clear();
    dataSp.clear();
    configColors.clear();

    fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
    fetchConfigColors();
  }

  // mengambil data wind turbine
  Future<void> fetchDataWt(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingDataWt(true);
      // [WT.07]
      Uri url = Uri.parse("$domain/api/wind-turbine/power-status");
      var response = await http.post(
        url,
        body: {"id": id, "date": date, "draw": "1"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // cek apakah jsonData[data] null
        if (jsonData['prod_kwh'] == null || jsonData['prod_kwh'].isEmpty) {
          dataWt == [];
          dataWt.clear();
          dataWtLoadedSuccessfully(true);
        } else {
          List<dynamic> realData = jsonData['prod_kwh'];
          List<RealtimeEnergyWt> newDataWt = [];
          for (var i = 0; i < realData.length; i++) {
            var dateUtc = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['date_utc']));
            var windSpeed = realData[i]['wind_speed'];
            var powerWatt = realData[i]['power_watt'];

            newDataWt.add(RealtimeEnergyWt(
              dateUtc,
              windSpeed,
              powerWatt,
            ));
          }
          dataWt.assignAll(newDataWt);
          dataWtLoadedSuccessfully(true);
        }
      } else {
        dataWtLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        await fetchDataWt(date, id, retryCount: retryCount - 1);
      } else {
        dataWtLoadedSuccessfully(false);
      }
    } finally {
      isLoadingDataWt(false);
    }
  }

  // mengambil data solar panel
  Future<void> fetchDataSp(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingDataSp(true);
      // [SP.02]
      Uri url = Uri.parse("$domain/api/solar-panel/power-status");
      var response = await http.post(
        url,
        body: {"id": id, "date": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // cek apakah jsonData[data] null
        if (jsonData['prod_kwh'] == null || jsonData['prod_kwh'].isEmpty) {
          dataSp == [];
          dataSpLoadedSuccessfully(true);
          dataSp.clear();
        } else {
          List<dynamic> realData = jsonData['prod_kwh'];
          List<RealtimeEnergySp> newDataSp = [];
          for (var i = 0; i < realData.length; i++) {
            var dateUtc = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['date_utc']));
            var solarRad = realData[i]['solar_rad'];
            var powerWatt = realData[i]['power'];
            newDataSp
                .add(RealtimeEnergySp(dateUtc, solarRad, powerWatt, '0', '0'));
          }
          dataSp.assignAll(newDataSp);
          dataSpLoadedSuccessfully(true);
        }
      } else {
        dataSpLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        return fetchDataSp(date, id, retryCount: retryCount - 1);
      } else {
        dataSpLoadedSuccessfully(false);
      }
    } finally {
      isLoadingDataSp(false);
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
        await Future.delayed(const Duration(seconds: 1));
        return fetchConfigColors(retryCount: retryCount - 1);
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
