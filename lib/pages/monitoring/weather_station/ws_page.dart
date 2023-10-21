import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/weather_station/ws_chart_widget.dart';
import 'package:manajemen_aset/pages/monitoring/weather_station/ws_controller.dart';

import '../../../widget/button/small_button.dart';

class WsPage extends StatelessWidget {
  final String idWs;
  const WsPage({Key? key, required this.idWs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WsController controller = Get.put(WsController(
      idWs,
    ));
    // Dispose the controller when the widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<WsController>();
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
                  controller.isLoadingData.isTrue ||
                  controller.isLoadingNotif.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.dataLoadedSuccessfully.isFalse ||
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
                if (controller.dataWS.isEmpty) {
                  // cek apakah data ws kosong
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
                  } else {
                    // jika data wt kosong dan datetime != hari ini
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
                } else {
                  // jika dataWs tidak kosong
                  // cek apakah datetime == tanggal hari ini dan value status dari [NTF.01] == true
                  // jika benar, maka akan menampilkan grafik dan msg value
                  if (DateFormat('yyyy-MM-dd').format(controller.dateTime!) ==
                          DateFormat('yyyy-MM-dd').format(DateTime.now()) &&
                      controller.notif.value.status == true) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showDatePicker(controller, context),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: WsChartWidget(wsController: controller),
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: WsChartWidget(wsController: controller),
                        ),
                      ],
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

  Container showDatePicker(WsController controller, BuildContext context) {
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
