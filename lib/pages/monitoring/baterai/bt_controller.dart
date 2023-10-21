import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manajemen_aset/models/baterai.dart';
import 'package:manajemen_aset/models/config_colors.dart';
import 'package:manajemen_aset/models/inverter.dart';

import '../../../network/base_url_controller.dart';

class BtController extends GetxController {
  final String idBt;
  var isLoadingBt = false.obs;
  var isLoadingBt2 = false.obs;
  var isLoadingIv = false.obs;
  var isLoadingIv2 = false.obs;
  var isLoadingConfig = false.obs;
  var btLoadedSuccessfully = true.obs;
  var bt2LoadedSuccessfully = true.obs;
  var ivLoadedSuccessfully = true.obs;
  var iv2LoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;
  DateTime? dateTime = DateTime.now();

  RxList<BateraiData> dataBt = <BateraiData>[].obs;
  RxList<BateraiData2> dataBt2 = <BateraiData2>[].obs;
  RxList<InverterData> dataIv = <InverterData>[].obs;
  RxList<InverterData2> dataIv2 = <InverterData2>[].obs;
  var configColors = <ConfigColors>[].obs;

  BtController(this.idBt);

  @override
  void onInit() {
    super.onInit();
    fetchDataBt(DateFormat('yyyy-MM-dd').format(dateTime!), idBt);
    fetchDataBt2(DateFormat('yyyy-MM-dd').format(dateTime!));
    fetchDataIv(DateFormat('yyyy-MM-dd').format(dateTime!), idBt);
    fetchDataIv2(DateFormat('yyyy-MM-dd').format(dateTime!));
    fetchConfigColors();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<BtController>();
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
        fetchDataBt(DateFormat('yyyy-MM-dd').format(dateTime!), idBt);
        fetchDataBt2(DateFormat('yyyy-MM-dd').format(dateTime!));
        fetchDataIv(DateFormat('yyyy-MM-dd').format(dateTime!), idBt);
        fetchDataIv2(DateFormat('yyyy-MM-dd').format(dateTime!));
      }
    });
  }

  Future<void> refreshData() async {
    // Implementasikan logika refresh data di sini
    // Misalnya, panggil method untuk memuat ulang data dari server
    dataBt.clear();
    dataBt2.clear();
    dataIv.clear();
    dataIv2.clear();
    configColors.clear();

    fetchDataBt(DateFormat('yyyy-MM-dd').format(dateTime!), idBt);
    fetchDataBt2(DateFormat('yyyy-MM-dd').format(dateTime!));
    fetchDataIv(DateFormat('yyyy-MM-dd').format(dateTime!), idBt);
    fetchDataIv2(DateFormat('yyyy-MM-dd').format(dateTime!));
    fetchConfigColors();
  }

  // mengambil data baterai
  Future<void> fetchDataBt(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingBt(true);
      // [BT.01]
      Uri url = Uri.parse("$domain/api/battery/realtime");
      var response = await http.post(url, body: {"id": id, "date": date});
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataBt == [];
          jsonData.clear();
        } else {
          List<dynamic> realData = jsonData['data'];

          List<BateraiData> newDataBt = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var voltBt = realData[i]['volt'];
            var ampereBt = realData[i]['ampere'];
            var powerBt = realData[i]['power'];
            // dataWt.clear();
            newDataBt.add(BateraiData(
              dateTime,
              voltBt,
              ampereBt,
              powerBt,
            ));
          }
          dataBt.assignAll(newDataBt);
          btLoadedSuccessfully(true);
        }
      } else {
        btLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataBt(date, id, retryCount: retryCount - 1);
      } else {
        btLoadedSuccessfully(false);
      }
    } finally {
      isLoadingBt(false);
    }
  }

  // mengambil data baterai
  Future<void> fetchDataBt2(String date, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingBt2(true);
      // [BT.01]
      Uri url = Uri.parse("$domain/api/battery/realtime");
      var response = await http.post(url, body: {"id": "3", "date": date});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataBt2 == [];
          jsonData.clear();
        } else {
          List<dynamic> realData = jsonData['data'];
          List<BateraiData2> newDataBt2 = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var voltBt = realData[i]['volt'];
            var ampereBt = realData[i]['ampere'];
            var powerBt = realData[i]['power'];
            // dataWt.clear();
            newDataBt2.add(BateraiData2(
              dateTime,
              voltBt,
              ampereBt,
              powerBt,
            ));
          }
          dataBt2.assignAll(newDataBt2);
          bt2LoadedSuccessfully(true);
        }
      } else {
        bt2LoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataBt2(date, retryCount: retryCount - 1);
      } else {
        bt2LoadedSuccessfully(false);
      }
    } finally {
      isLoadingBt2(false);
    }
  }

  // mengambil data inverter
  Future<void> fetchDataIv(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingIv(true);
      // [IV.01]
      Uri url = Uri.parse("$domain/api/inverter/realtime");
      var response = await http.post(url, body: {"id": id, "date": date});
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataIv == [];
          ivLoadedSuccessfully(true);
          jsonData.clear();
        } else {
          List<dynamic> realData = jsonData['data'];

          List<InverterData> newDataIv = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var voltIv = realData[i]['volt'];
            var ampereIv = realData[i]['ampere'];
            var powerIv = realData[i]['power'];

            // dataWt.clear();
            newDataIv.add(InverterData(
              dateTime,
              voltIv,
              ampereIv,
              powerIv,
            ));
          }
          dataIv.assignAll(newDataIv);
          ivLoadedSuccessfully(true);
        }
      } else {
        ivLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        Future.delayed(const Duration(seconds: 3));
        return fetchDataIv(date, id, retryCount: retryCount - 1);
      } else {
        ivLoadedSuccessfully(false);
      }
    } finally {
      isLoadingIv(false);
    }
  }

  // mengambil data inverter
  Future<void> fetchDataIv2(String date, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingIv2(true);
      // [IV.01]
      Uri url = Uri.parse("$domain/api/inverter/realtime");
      var response = await http.post(url, body: {"id": "3", "date": date});
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataIv2 == [];
          jsonData.clear();
          iv2LoadedSuccessfully(true);
        } else {
          List<dynamic> realData = jsonData['data'];
          List<InverterData2> newDataIv2 = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var voltIv = realData[i]['volt'];
            var ampereIv = realData[i]['ampere'];
            var powerIv = realData[i]['power'];
            newDataIv2.add(InverterData2(
              dateTime,
              voltIv,
              ampereIv,
              powerIv,
            ));
          }
          dataIv2.assignAll(newDataIv2);
          iv2LoadedSuccessfully(true);
        }
      } else {
        iv2LoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataIv2(date, retryCount: retryCount - 1);
      } else {
        iv2LoadedSuccessfully(false);
      }
    } finally {
      isLoadingIv2(false);
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
