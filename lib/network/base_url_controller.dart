import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api.dart';

class BaseURLController extends GetxController {
  Rx<ApiModel> apiModel = ApiModel(domain: 'http://ebt-polinema.site').obs;

  @override
  void onInit() {
    _loadConfig();
    super.onInit();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final domain = prefs.getString('api_url');
    if (domain != null) {
      apiModel.value = ApiModel(domain: domain);
    }
  }

  Future<void> setDomain(String newDomain) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_url', newDomain);
    apiModel.value = ApiModel(domain: newDomain);
  }
}
