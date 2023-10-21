import 'package:flutter/material.dart';
import 'package:manajemen_aset/in_progress_page.dart';
import 'package:manajemen_aset/models/api.dart';
import 'package:manajemen_aset/pages/monitoring/all/all_power_page.dart';
import 'package:manajemen_aset/pages/monitoring/baterai/bt_page.dart';
import 'package:manajemen_aset/pages/monitoring/solar_panel/sp_page.dart';
import 'package:manajemen_aset/pages/monitoring/weather_station/ws_page.dart';
import 'package:manajemen_aset/pages/monitoring/wind_turbine/wt_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringScreen extends StatefulWidget {
  final String idPerangkat;
  final String jenisPerangkat;

  const MonitoringScreen({
    Key? key,
    required this.jenisPerangkat,
    required this.idPerangkat,
  }) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  ApiModel? apiModel;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  // fungsi untuk mendapatkan domain
  void _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final apiUrl = prefs.getString('api_url') ?? 'http://ebt-polinema.site';
    setState(() {
      apiModel = ApiModel(domain: apiUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    String jenisPerangkat = widget.jenisPerangkat;
    if (apiModel == null) {
      return const CircularProgressIndicator();
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SwitchCaseWidget(
          jenisPerangkat: jenisPerangkat,
          idPerangkat: widget.idPerangkat,
          apiModel: apiModel!,
        ),
      ),
    );
  }
}

class SwitchCaseWidget extends StatelessWidget {
  final String jenisPerangkat;
  final String idPerangkat;
  final ApiModel apiModel;

  const SwitchCaseWidget({
    Key? key,
    required this.jenisPerangkat,
    required this.idPerangkat,
    required this.apiModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (jenisPerangkat) {
      case 'PLTB':
        return WtPage(idWt: idPerangkat);
      case 'PLTS':
        return SpPage(idSp: idPerangkat);
      case 'Diesel':
        return const InProgressPage();
      case 'Baterai':
        return BtPage(idBt: idPerangkat);
      case 'Weather Station':
        return WsPage(idWs: idPerangkat);
      case 'Rumah Energi':
        return const AllPowerPage(idCluster: '1');
      default:
        return const InProgressPage();
    }
  }
}
