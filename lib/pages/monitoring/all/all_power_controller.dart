import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../models/baterai.dart';
import '../../../models/config_colors.dart';
import '../../../models/diesel.dart';
import '../../../models/inverter.dart';
import '../../../models/load.dart';
import '../../../models/solar_panel.dart';
import '../../../models/wind_turbine.dart';
import '../../../network/base_url_controller.dart';

class AllPowerController extends GetxController {
  // final String idCluster;
  var isLoadingWt = false.obs;
  var isLoadingSp = false.obs;
  var isLoadingDs = false.obs;
  var isLoadingBt = false.obs;
  var isLoadingIv = false.obs;
  var isLoadingLoad = false.obs;
  var isLoadingConfig = false.obs;

  var wtLoadedSuccessfully = true.obs;
  var spLoadedSuccessfully = true.obs;
  var dsLoadedSuccessfully = true.obs;
  var btLoadedSuccessfully = true.obs;
  var ivLoadedSuccessfully = true.obs;
  var loadLoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;

  DateTime? dateTime = DateTime.now();

  RxList<WtData> dataWt = <WtData>[].obs;
  RxList<SpData> dataSp = <SpData>[].obs;
  RxList<DieselData> dataDs = <DieselData>[].obs;
  RxList<BateraiData> dataBt = <BateraiData>[].obs;
  RxList<InverterData> dataIv = <InverterData>[].obs;
  RxList<Load> dataLoad = <Load>[].obs;
  var configColors = <ConfigColors>[].obs;

  // AllPowerController(this.idCluster, this.apiModel);

  @override
  void onInit() {
    super.onInit();
    fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
    fetchDataDs(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataBt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataIv(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
    fetchDataLoad(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
    fetchConfigColors();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<AllPowerController>();
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
        fetchDataDs(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
        fetchDataBt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
        fetchDataIv(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
        fetchDataLoad(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
        fetchConfigColors();
      }
    });
  }

  Future<void> refreshData() async {
    // Implementasikan logika refresh data di sini
    // Misalnya, panggil method untuk memuat ulang data dari server
    dataWt.clear();
    dataSp.clear();
    dataDs.clear();
    dataBt.clear();
    dataIv.clear();
    dataLoad.clear();
    configColors.clear();

    fetchDataWt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataSp(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
    fetchDataDs(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataBt(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
    fetchDataIv(DateFormat('yyyy-MM-dd').format(dateTime!), '3');
    fetchDataLoad(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
    fetchConfigColors();
  }

  // mengambil data wind turbine
  Future<void> fetchDataWt(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingWt(true);
      // [WT.01]
      Uri url = Uri.parse("$domain/api/wind-turbine/get-day-alldata");
      var response = await http.post(
        url,
        body: {"id": id, "date": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

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
          wtLoadedSuccessfully(true);
        }
      } else {
        wtLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataWt(date, id, retryCount: retryCount - 1);
      } else {
        wtLoadedSuccessfully(false);
      }
    } finally {
      isLoadingWt(false);
    }
  }

  // mengambil data solar panel
  Future<void> fetchDataSp(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingSp(true);
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
          spLoadedSuccessfully(true);
        }
      } else {
        spLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataSp(date, id, retryCount: retryCount - 1);
      } else {
        spLoadedSuccessfully(false);
      }
    } finally {
      isLoadingSp(false);
    }
  }

  // mengambil data diesel
  Future<void> fetchDataDs(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingDs(true);
      // [PN.01]
      Uri url = Uri.parse("$domain/api/panel/realtime");
      var response = await http.post(url, body: {"id": id, "date": date});
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataDs == [];
          jsonData.clear();
        } else {
          List<dynamic> realData = jsonData['data'];
          List<DieselData> newDataDs = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var pf = realData[i]['pf'];
            var volt = realData[i]['volt'];
            var ampere = realData[i]['ampere'];
            var power = realData[i]['power'];
            // dataWt.clear();
            newDataDs.add(DieselData(
              dateTime,
              pf,
              volt,
              ampere,
              power,
            ));
          }
          dataDs.assignAll(newDataDs);
          dsLoadedSuccessfully(true);
        }
      } else {
        dsLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataDs(date, id, retryCount: retryCount - 1);
      } else {
        dsLoadedSuccessfully(false);
      }
    } finally {
      isLoadingDs(false);
    }
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
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
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
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataIv(date, id, retryCount: retryCount - 1);
      } else {
        ivLoadedSuccessfully(false);
      }
    } finally {
      isLoadingIv(false);
    }
  }

  // mengambil data load
  Future<void> fetchDataLoad(String date, String id,
      {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingLoad(true);
      // [PN.01]
      Uri url = Uri.parse("$domain/api/panel/realtime");
      var response = await http.post(url, body: {"id": id, "date": date});
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // cek apakah jsonData[data] null
        if (jsonData['data'] == null || jsonData['data'].isEmpty) {
          dataLoad == [];
          jsonData.clear();
        } else {
          List<dynamic> realData = jsonData['data'];
          List<Load> newDataLoad = [];
          for (var i = 0; i < realData.length; i++) {
            var dateTime = DateFormat('HH:mm:ss')
                .format(DateTime.parse(realData[i]['datetime']));
            var pf = realData[i]['pf'];
            var volt = realData[i]['volt'];
            var ampere = realData[i]['ampere'];
            var power = realData[i]['power'];
            if (double.parse(power) > 0) {
              var negativeLoad = double.parse(power) * -1;
              newDataLoad.add(
                  Load(dateTime, pf, volt, ampere, negativeLoad.toString()));
            } else {
              newDataLoad.add(Load(dateTime, pf, volt, ampere, power));
            }
          }
          dataLoad.assignAll(newDataLoad);
          loadLoadedSuccessfully(true);
        }
      } else {
        loadLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await fetchDataLoad(date, id, retryCount: retryCount - 1);
      } else {
        loadLoadedSuccessfully(false);
      }
    } finally {
      isLoadingLoad(false);
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
