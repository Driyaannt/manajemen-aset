import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/solar_panel/sp_chart_widget.dart';
import 'package:manajemen_aset/pages/monitoring/solar_panel/sp_controller.dart';

import '../../../widget/button/small_button.dart';

class SpPage extends StatelessWidget {
  final String idSp;
  const SpPage({Key? key, required this.idSp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SpController controller = Get.put(SpController(idSp));
    // Dispose the controller when the widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<SpController>();
    });
    return RefreshIndicator(
      onRefresh: () async {
        // Panggil fungsi untuk memperbarui data di sini
        await controller.refreshData();
      },
      child: ListView(
        shrinkWrap: true,
        children: [
          Obx(
            (() {
              if (controller.isLoadingData.isTrue ||
                  controller.isLoadingConfig.isTrue ||
                  controller.isLoadingNotif.isTrue ||
                  controller.isLoadingProd.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.dataLoadedSuccessfully.isFalse ||
                  controller.prodLoadedSuccessfully.isFalse ||
                  controller.notifLoadedSuccessfully.isFalse ||
                  controller.configLoadedSuccessfully.isFalse) {
                return Column(
                  children: [
                    ButtonIcon(
                      title: 'Coba Lagi',
                      icon: Iconsax.refresh,
                      onPressed: () {
                        controller.refreshData();
                      },
                    ),
                  ],
                );
              } else {
                // cek apakah data sp tidak kosong
                if (controller.dataSp.isNotEmpty) {
                  // cek apakah datetime == tanggal hari ini dan value status dari [NTF.01] == true
                  // jika benar, maka akan menampilkan grafik dan msg value
                  if (DateFormat('yyyy-MM-dd').format(controller.dateTime!) ==
                          DateFormat('yyyy-MM-dd').format(DateTime.now()) &&
                      controller.notif.value.status == true) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showDatePicker(controller, context),
                        showProdEnergi(controller),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SpChartWidget(spController: controller),
                        ),
                        Text(
                          controller.notif.value.msg,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
                  } else {
                    // jika salah, maka akan menampilkan grafik saja
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showDatePicker(controller, context),
                        showProdEnergi(controller),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: SpChartWidget(spController: controller),
                        ),
                      ],
                    );
                  }
                } else {
                  // cek apakah dateTime == tanggal hari ini
                  // jika iya maka akan menampilkan msg dari fetchNotif [NTF.01]
                  if (DateFormat('yyyy-MM-dd').format(controller.dateTime!) ==
                      DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showDatePicker(controller, context),
                          const SizedBox(height: 16),
                          Image.asset('img/no-data.png'),
                          Text(
                            controller.notif.value.msg ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                    // jika data sp kosong dan datetime != hari ini
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showDatePicker(controller, context),
                          const SizedBox(height: 16),
                          Image.asset('img/no-data.png'),
                          const Text(
                            "Data Tidak Dapat Ditemukan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              }
            }),
          ),
        ],
      ),
    );
  }

  Padding showProdEnergi(SpController controller) {
    // String kwh = spController.dataDailyProd.value.powerKwh;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Produksi Energi Hari Ini',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.9,
            ),
          ),
          Text(
            '${controller.dataDailyProd.value.powerKwh ?? '-'} kWh',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Container showDatePicker(SpController controller, BuildContext context) {
    return Container(
      width: 230,
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 217, 224, 223),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          const Icon(
            Iconsax.calendar_1,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            DateFormat('dd MMM yyyy').format(controller.dateTime!),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () async {
              controller.getDatePicker(context);
            },
            icon: const Icon(
              Iconsax.arrow_circle_down5,
              size: 22,
              color: Color(0xFF129575),
            ),
          ),
        ],
      ),
    );
  }
}
