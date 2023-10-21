import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/models/api.dart';
import 'package:manajemen_aset/pages/monitoring/all/realtime_chart_widget.dart';
import 'package:manajemen_aset/pages/monitoring/all/realtime_controller.dart';

import '../../../widget/button/small_button.dart';

class RealtimePage extends StatelessWidget {
  final String idCluster;
  final ApiModel apiModel;
  final double height;
  const RealtimePage(
      {Key? key,
      required this.idCluster,
      required this.apiModel,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RealtimeController controller =
        Get.put(RealtimeController(idCluster, apiModel));
    // Dispose the controller when the widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<RealtimeController>();
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
              if (controller.isLoadingConfig.isTrue ||
                  controller.isLoadingDataSp.isTrue ||
                  controller.isLoadingDataWt.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.dataSpLoadedSuccessfully.isFalse ||
                  controller.dataWtLoadedSuccessfully.isFalse ||
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
                // cek apakah data wt kosong
                if (controller.dataWt.isNotEmpty &&
                    controller.dataSp.isNotEmpty) {
                  // jika dataWt tidak kosong
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      showDatePicker(controller, context),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: height,
                        child:
                            RealtimeChartWidget(realtimeController: controller),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
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
            }),
          ),
        ],
      ),
    );
  }

  Container showDatePicker(
      RealtimeController controller, BuildContext context) {
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
