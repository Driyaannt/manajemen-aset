import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/models/api.dart';
import 'package:manajemen_aset/pages/monitoring/all/realtime_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PowerScreenTotal extends StatefulWidget {
  final String idCluster;
  const PowerScreenTotal({Key? key, required this.idCluster}) : super(key: key);

  @override
  State<PowerScreenTotal> createState() => _PowerScreenTotalState();
}

class _PowerScreenTotalState extends State<PowerScreenTotal>
    with SingleTickerProviderStateMixin {
  // TabController? _tabController;
  ApiModel? apiModel;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
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
    if (apiModel == null) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Realtime Monitoring',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            children: [
              RealtimePage(
                idCluster: widget.idCluster,
                apiModel: apiModel!,
                height: MediaQuery.of(context).size.height * 0.68,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
