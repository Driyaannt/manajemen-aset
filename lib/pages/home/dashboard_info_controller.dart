// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../models/prod_energi.dart';
import '../../network/base_url_controller.dart';

class DashboardInfoC extends GetxController {
  final String idPembangkit;
  var dataDailyProd = ProdEnergi().obs;
  var isLoading = false.obs;

  DashboardInfoC(this.idPembangkit);

  @override
  void onInit() {
    super.onInit();
    fetchData(DateFormat('yyyy-MM-dd').format(DateTime.now()), idPembangkit);
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<DashboardInfoC>();
    super.onClose();
  }

  Future<void> fetchData(String date, String id, {int retryCount = 3}) async {
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
        var jsonData = jsonDecode(response.body);
        dataDailyProd.value = ProdEnergi.fromJson(jsonData);
      } else {
        throw Exception('Failed to load power data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(const Duration(seconds: 1));
        await fetchData(date, id, retryCount: retryCount - 1);
      } else {
        throw Exception(e.toString());
      }
    } finally {
      isLoading(false);
      // update();
    }
  }
}
