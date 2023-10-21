import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/baterai/bt_chart_widget.dart';
import 'package:manajemen_aset/pages/monitoring/baterai/bt_chart_widget2.dart';
import 'package:manajemen_aset/pages/monitoring/baterai/bt_controller.dart';

import '../../../widget/button/small_button.dart';

class BtPage extends StatelessWidget {
  final String idBt;
  const BtPage({Key? key, required this.idBt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BtController controller = Get.put(BtController(idBt));
    // Dispose the controller when the widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<BtController>();
    });
    if (idBt == "2") {
      return RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Obx(
              (() {
                if (controller.isLoadingBt2.isTrue ||
                    controller.isLoadingIv2.isTrue ||
                    controller.isLoadingConfig.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.bt2LoadedSuccessfully.isFalse ||
                    controller.iv2LoadedSuccessfully.isFalse ||
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
                  // cek apakah data baterai dan inverter kosong
                  if (controller.dataBt2.isEmpty &&
                      controller.dataIv2.isEmpty) {
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
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  } else {
                    // jika data baterai dan inverter tidak kosong
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showDatePicker(controller, context),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: BtChartWidget2(btController: controller),
                        ),
                      ],
                    );
                  }
                }
              }),
            ),
          ],
        ),
      );
    } else {
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
                if (controller.isLoadingBt.isTrue ||
                    controller.isLoadingIv.isTrue ||
                    controller.isLoadingConfig.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.btLoadedSuccessfully.isFalse ||
                    controller.ivLoadedSuccessfully.isFalse ||
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
                  // cek apakah data baterai dan inverter kosong
                  if (controller.dataBt.isEmpty && controller.dataIv.isEmpty) {
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
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  } else {
                    // jika data baterai dan inverter tidak kosong
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showDatePicker(controller, context),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: BtChartWidget(btController: controller),
                        ),
                      ],
                    );
                  }
                }
              }),
            ),
          ],
        ),
      );
    }
  }

  Container showDatePicker(BtController controller, BuildContext context) {
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
