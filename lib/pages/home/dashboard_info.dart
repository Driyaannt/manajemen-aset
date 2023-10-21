import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/home/dashboard_info_controller.dart';
import 'package:manajemen_aset/pages/tren_analitik/tren_analitik.dart';

import '../../widget/button/big_button.dart';
import '../../widget/button/small_button_icon.dart';
import '../jenisPeralatanPembangkit/jpp_list_page.dart';
import '../monitoring/all/power_screen_total.dart';
import '../monitoring/produksi_energi/prod_energi_page.dart';

class DashboardInfo extends StatelessWidget {
  const DashboardInfo(
      {Key? key,
      required this.namaPembangkit,
      required this.idPembangkit,
      required this.documentId,
      required this.latPembangkit,
      required this.lngPembangkit,
      required this.colorAlarm,
      required this.colorWT,
      required this.colorSP,
      required this.colorDS,
      required this.isAnon})
      : super(key: key);

  final String namaPembangkit;
  final String idPembangkit;
  final String documentId;
  final double latPembangkit;
  final double lngPembangkit;
  final Color colorAlarm;
  final Color colorWT;
  final Color colorSP;
  final Color colorDS;
  final bool isAnon;

  @override
  Widget build(BuildContext context) {
    final DashboardInfoC dashboardInfoC = Get.put(DashboardInfoC(idPembangkit));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<DashboardInfoC>();
    });
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDragHandle(),
            const SizedBox(height: 16),
            // nama Pembangkit
            Text(
              namaPembangkit,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(thickness: 2),

            // produksi energi
            const Text(
              'Produksi Energi Hari ini (kWh) ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),

            // timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Terakhir Diperbaharui: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF484848),
                  ),
                ),
                Text(
                  DateFormat('HH:mm, dd MMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF484848),
                  ),
                ),
              ],
            ),

            // produksi energi
            const SizedBox(height: 16),
            Obx(() {
              if (dashboardInfoC.isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // kwh pltb
                    kwhPembangkit(
                      double.parse(dashboardInfoC.dataDailyProd.value.kwhWt)
                          .toStringAsFixed(3),
                      'img/pltb.png',
                      'PLTB',
                      colorWT,
                    ),

                    // kwh plts
                    kwhPembangkit(
                      double.parse(dashboardInfoC.dataDailyProd.value.kwhSp)
                          .toStringAsFixed(3),
                      'img/plts.png',
                      'PLTS',
                      colorSP,
                    ),

                    // kwh pltd
                    kwhPembangkit(
                      double.parse(dashboardInfoC.dataDailyProd.value.kwhDs)
                          .toStringAsFixed(3),
                      'img/pltd.png',
                      'PLTD',
                      colorDS,
                    ),

                    // kwh total
                    kwhPembangkit(
                      dashboardInfoC.dataDailyProd.value.kwhAll
                          .toStringAsFixed(3),
                      'img/energy.png',
                      'Total',
                      const Color(0xFF129575),
                    ),
                  ],
                );
              }
            }),
            const SizedBox(height: 8),
            const Divider(thickness: 2),

            // produksi energi (load)
            SmallButtonIcon(
              title: "Produksi Energi (kWh)",
              bgColor: const Color(0xFFDBEBE7),
              icon: Iconsax.chart_1,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProdEnergiPage(
                      idCluster: idPembangkit,
                    ),
                  ),
                );
              },
            ),

            // chart realtime monitoring produksi energi
            SmallButtonIcon(
              title: "Realtime Monitoring",
              bgColor: const Color(0xFFDBEBE7),
              icon: Iconsax.diagram,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PowerScreenTotal(
                      idCluster: idPembangkit,
                    ),
                  ),
                );
              },
            ),

            // tren dan analitik
            SmallButtonIcon(
              title: "Tren dan Analitik",
              bgColor: const Color(0xFFDBEBE7),
              icon: Iconsax.trend_up,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrenAnalitik()),
                );
              },
            ),

            // tombol detail
            BigButton(
              title: 'Detail',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListJpp(
                      docPembangkitId: documentId,
                      latPembangkit: latPembangkit,
                      lngPembangkit: lngPembangkit,
                      idPembangkit: idPembangkit,
                      isAnon: isAnon,
                      namaPembangkit: namaPembangkit,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  kwhPembangkit(String kwh, String img, dynamic title, Color color) {
    return Column(
      children: [
        Image(
          image: AssetImage(img),
          width: 50,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          kwh,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
