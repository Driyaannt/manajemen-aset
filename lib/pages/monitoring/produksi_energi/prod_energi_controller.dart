import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/config_colors.dart';
import '../../../models/prod_energi.dart';
import '../../../network/base_url_controller.dart';

class ProdEnergiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String idCluster;
  late TabController tabController;
  var isLoadingData = false.obs;
  var isLoadingLoad = false.obs;
  var isLoadingColor = false.obs;
  var dataLoadedSuccessfully = true.obs;
  var dataLoadLoadedSuccessfully = true.obs;
  var configLoadedSuccessfully = true.obs;
  DateTime? dateTime = DateTime.now();
  DateTime? monthTime = DateTime.now();
  DateTime? yearTime = DateTime.now();

  RxList<ProdEnergiWtData> dataWt = <ProdEnergiWtData>[].obs;
  RxList<ProdEnergiSpData> dataSp = <ProdEnergiSpData>[].obs;
  RxList<ProdEnergiDsData> dataDs = <ProdEnergiDsData>[].obs;
  RxList<ProdEnergiTotal> dataAll = <ProdEnergiTotal>[].obs;
  RxList<LoadData> dataLoad = <LoadData>[].obs;
  RxList<ConfigColors> configColors = <ConfigColors>[].obs;

  ProdEnergiController(this.idCluster);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchConfigColors();
    getDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idCluster);
    getDataLoadDaily(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
    tabController.addListener(() {
      if (tabController.index == 0) {
        clearData();
        fetchConfigColors();
        getDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idCluster);
        getDataLoadDaily(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
      } else if (tabController.index == 1) {
        clearData();
        fetchConfigColors();
        getDataMonthly(DateFormat('yyyy-MM').format(dateTime!), idCluster);
        // getDataLoadDaily(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
      } else if (tabController.index == 2) {
        clearData();
        fetchConfigColors();
        getDataYearly(DateFormat('yyyy-MM').format(dateTime!), idCluster);
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
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
        fetchConfigColors();
        getDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idCluster);
        getDataLoadDaily(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
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
        fetchConfigColors();
        getDataMonthly(DateFormat('yyyy-MM').format(monthTime!), idCluster);
        // getDataLoadDaily(DateFormat('yyyy-MM-dd').format(dateTime!), '2');
      }
    });
  }

  getYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: yearTime!,
              onChanged: (DateTime yearTime) {
                Navigator.pop(context);
                yearTime = yearTime;
                fetchConfigColors();
                getDataYearly(
                    DateFormat('yyyy-MM').format(yearTime), idCluster);
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  clearData() {
    dataWt.clear();
    dataSp.clear();
    dataDs.clear();
    dataAll.clear();
    dataLoad.clear();
    configColors.clear();
  }

  Future<void> refreshDataDaily() async {
    clearData();

    getDataDaily(DateFormat('yyyy-MM-dd').format(dateTime!), idCluster);
    getDataLoadDaily(DateFormat('yyyy-MM-dd').format(dateTime!), '4');
    fetchConfigColors();
  }

  Future<void> refreshDataMonthly() async {
    clearData();

    getDataMonthly(DateFormat('yyyy-MM').format(dateTime!), idCluster);
    await fetchConfigColors();
  }

  Future<void> refreshDataYearly() async {
    clearData();

    getDataYearly(DateFormat('yyyy-MM').format(dateTime!), idCluster);
    await fetchConfigColors();
  }

  // mangambil data produksi energi harian
  Future getDataDaily(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingData(true);
      // [CL.02]
      Uri url = Uri.parse("$domain/api/cluster/power-production-daily");
      var response = await http.post(
        url,
        body: {"id": id, "date_day": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> wtData = jsonData['wind_turbine']["detail"];
        List<dynamic> spData = jsonData['solar_panel']["detail"];
        List<dynamic> dsData = jsonData['diesel']["detail"];
        List<dynamic> allData = jsonData['all']["detail"];

        List<ProdEnergiWtData> newDataWt = [];
        List<ProdEnergiSpData> newDataSp = [];
        List<ProdEnergiDsData> newDataDs = [];
        List<ProdEnergiTotal> newDataAll = [];

        for (var i = 0; i < wtData.length; i++) {
          var hours = wtData[i]['hours'];
          var powerKwh = wtData[i]['power_kwh'] ?? '0';
          newDataWt.add(ProdEnergiWtData(interval: hours, powerKwh: powerKwh));
        }

        for (var i = 0; i < spData.length; i++) {
          var hours = spData[i]['hours'];
          var powerKwh = spData[i]['power_kwh'] ?? '0';
          newDataSp.add(ProdEnergiSpData(interval: hours, powerKwh: powerKwh));
        }

        for (var i = 0; i < dsData.length; i++) {
          var hours = dsData[i]['hours'];
          var powerKwh = dsData[i]['power_kwh'] ?? '0';
          newDataDs.add(ProdEnergiDsData(interval: hours, powerKwh: powerKwh));
        }

        for (var i = 0; i < allData.length; i++) {
          var hours = allData[i]['hours'];
          var powerKwh = allData[i]['power_kwh'] ?? 0;
          newDataAll.add(
              ProdEnergiTotal(interval: hours, powerKwh: powerKwh.toString()));
        }

        dataWt.assignAll(newDataWt);
        dataSp.assignAll(newDataSp);
        dataDs.assignAll(newDataDs);
        dataAll.assignAll(newDataAll);
        dataLoadedSuccessfully(true);
      } else {
        dataLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await getDataDaily(date, id, retryCount: retryCount - 1);
      } else {
        dataLoadedSuccessfully(false);
      }
    } finally {
      isLoadingData(false);
    }
  }

  // mangambil data produksi energi bulanan
  Future getDataMonthly(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingData(true);
      // [CL.03]
      Uri url = Uri.parse("$domain/api/cluster/power-production-monthly");
      var response = await http.post(
        url,
        body: {"id": id, "date_month": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> wtData = jsonData['wind_turbine']["detail"];
        List<dynamic> spData = jsonData['solar_panel']["detail"];
        List<dynamic> dsData = jsonData['diesel']["detail"];
        List<dynamic> allData = jsonData['all']["detail"];

        List<ProdEnergiWtData> newDataWt = [];
        List<ProdEnergiSpData> newDataSp = [];
        List<ProdEnergiDsData> newDataDs = [];
        List<ProdEnergiTotal> newDataAll = [];

        for (var i = 0; i < wtData.length; i++) {
          var days = wtData[i]['days'];
          var powerKwh = wtData[i]['power_kwh'] ?? '0';
          newDataWt.add(ProdEnergiWtData(interval: days, powerKwh: powerKwh));
        }

        for (var i = 0; i < spData.length; i++) {
          var days = spData[i]['days'];
          var powerKwh = spData[i]['power_kwh'] ?? '0';
          newDataSp.add(ProdEnergiSpData(interval: days, powerKwh: powerKwh));
        }

        for (var i = 0; i < dsData.length; i++) {
          var days = dsData[i]['days'];
          var powerKwh = dsData[i]['power_kwh'] ?? '0';
          newDataDs.add(ProdEnergiDsData(interval: days, powerKwh: powerKwh));
        }

        for (var i = 0; i < allData.length; i++) {
          var days = allData[i]['days'];
          var powerKwh = allData[i]['power_kwh'] ?? 0;
          newDataAll.add(
              ProdEnergiTotal(interval: days, powerKwh: powerKwh.toString()));
        }

        dataWt.assignAll(newDataWt);
        dataSp.assignAll(newDataSp);
        dataDs.assignAll(newDataDs);
        dataAll.assignAll(newDataAll);
        dataLoadedSuccessfully = RxBool(true);
      } else {
        dataLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await getDataMonthly(date, id, retryCount: retryCount - 1);
      } else {
        dataLoadedSuccessfully = RxBool(false);
      }
    } finally {
      isLoadingData(false);
    }
  }

  // mangambil data produksi energi harian
  Future getDataYearly(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingData(true);
      // [CL.04]
      Uri url = Uri.parse("$domain/api/cluster/power-production-yearly");
      var response = await http.post(
        url,
        body: {"id": id, "date_year": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> wtData = jsonData['wind_turbine']["detail"];
        List<dynamic> spData = jsonData['solar_panel']["detail"];
        List<dynamic> dsData = jsonData['diesel']["detail"];
        List<dynamic> allData = jsonData['all']["detail"];

        List<ProdEnergiWtData> newDataWt = [];
        List<ProdEnergiSpData> newDataSp = [];
        List<ProdEnergiDsData> newDataDs = [];
        List<ProdEnergiTotal> newDataAll = [];

        for (var i = 0; i < wtData.length; i++) {
          var months = wtData[i]['months'];
          var powerKwh = wtData[i]['power_kwh'] ?? '0';
          newDataWt.add(ProdEnergiWtData(interval: months, powerKwh: powerKwh));
        }

        for (var i = 0; i < spData.length; i++) {
          var months = spData[i]['months'];
          var powerKwh = spData[i]['power_kwh'] ?? '0';
          dataSp.clear();
          newDataSp.add(ProdEnergiSpData(interval: months, powerKwh: powerKwh));
        }

        for (var i = 0; i < dsData.length; i++) {
          var months = dsData[i]['months'];
          var powerKwh = dsData[i]['power_kwh'] ?? '0';
          newDataDs.add(ProdEnergiDsData(interval: months, powerKwh: powerKwh));
        }

        for (var i = 0; i < allData.length; i++) {
          var months = allData[i]['months'];
          var powerKwh = allData[i]['power_kwh'] ?? 0;
          newDataAll.add(
              ProdEnergiTotal(interval: months, powerKwh: powerKwh.toString()));
        }

        dataWt.assignAll(newDataWt);
        dataSp.assignAll(newDataSp);
        dataDs.assignAll(newDataDs);
        dataLoadedSuccessfully = RxBool(true);
      } else {
        dataLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await getDataYearly(date, id, retryCount: retryCount - 1);
      } else {
        dataLoadedSuccessfully = RxBool(false);
      }
    } finally {
      isLoadingData(false);
    }
  }

  Future getDataLoadDaily(String date, String id, {int retryCount = 3}) async {
    try {
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;
      isLoadingLoad(true);

      // [PN.02]
      Uri url = Uri.parse("$domain/api/panel/history-hourly");
      var response = await http.post(
        url,
        body: {"id": id, "date": date},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> loadData = jsonData['data'];
        List<LoadData> newLoadData = [];

        for (var i = 0; i < loadData.length; i++) {
          var hours = loadData[i]['hours'];
          var powerKwh = loadData[i]['power_kwh'] ?? '0';
          if (double.parse(powerKwh) > 0) {
            var negativeLoad = double.parse(powerKwh) * -1;
            newLoadData
                .add(LoadData(hours: hours, powerKwh: negativeLoad.toString()));
          } else {
            newLoadData.add(LoadData(hours: hours, powerKwh: powerKwh));
          }
        }
        dataLoad.assignAll(newLoadData);
        dataLoadLoadedSuccessfully(true);
      } else {
        dataLoadLoadedSuccessfully(false);
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 3));
        await getDataLoadDaily(date, id, retryCount: retryCount - 1);
      } else {
        dataLoadLoadedSuccessfully(false);
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
      isLoadingColor(true);
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
      isLoadingColor(false);
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
