import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/all/all_power_chart_widget.dart';
import 'package:manajemen_aset/pages/monitoring/all/all_power_controller.dart';

import '../../../widget/button/small_button.dart';
import '../produksi_energi/bar_chart_widget.dart';
import '../produksi_energi/prod_energi_controller.dart';

class AllPowerPage extends StatelessWidget {
  final String idCluster;
  final double? height;
  const AllPowerPage({Key? key, required this.idCluster, this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AllPowerController allPowerC = Get.put(AllPowerController());
    final ProdEnergiController prodEnergiC =
        Get.put(ProdEnergiController(idCluster));
    // Dispose the controller when the widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<AllPowerController>();
      Get.delete<ProdEnergiController>();
    });
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                // Panggil fungsi untuk memperbarui data di sini
                await allPowerC.refreshData();
              },
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Obx(
                    (() {
                      if (allPowerC.isLoadingWt.isTrue ||
                          allPowerC.isLoadingSp.isTrue ||
                          allPowerC.isLoadingDs.isTrue ||
                          allPowerC.isLoadingBt.isTrue ||
                          allPowerC.isLoadingIv.isTrue ||
                          allPowerC.isLoadingLoad.isTrue ||
                          allPowerC.isLoadingConfig.isTrue) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (allPowerC.wtLoadedSuccessfully.isFalse ||
                          allPowerC.spLoadedSuccessfully.isFalse ||
                          allPowerC.dsLoadedSuccessfully.isFalse ||
                          allPowerC.btLoadedSuccessfully.isFalse ||
                          allPowerC.ivLoadedSuccessfully.isFalse ||
                          allPowerC.loadLoadedSuccessfully.isFalse ||
                          allPowerC.configLoadedSuccessfully.isFalse) {
                        return Column(
                          children: [
                            ButtonIcon(
                              title: 'Coba Lagi',
                              icon: Iconsax.refresh,
                              onPressed: () {
                                allPowerC.refreshData();
                              },
                            ),
                          ],
                        );
                      } else if (allPowerC.dataWt.isNotEmpty ||
                          allPowerC.dataSp.isNotEmpty ||
                          allPowerC.dataDs.isNotEmpty ||
                          allPowerC.dataBt.isNotEmpty ||
                          allPowerC.dataIv.isNotEmpty ||
                          allPowerC.dataLoad.isNotEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            showDatePicker(allPowerC, context),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: AllPowerChartWidget(allPowerC: allPowerC),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              showDatePicker(allPowerC, context),
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
                    }),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() {
                if (prodEnergiC.isLoadingLoad.isTrue ||
                    prodEnergiC.isLoadingData.isTrue ||
                    prodEnergiC.isLoadingColor.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (prodEnergiC.dataLoadedSuccessfully.isFalse ||
                      prodEnergiC.dataLoadLoadedSuccessfully.isFalse ||
                      prodEnergiC.configLoadedSuccessfully.isFalse) {
                    return Column(
                      children: [
                        ButtonIcon(
                          title: 'Coba Lagi',
                          icon: Iconsax.refresh,
                          onPressed: () {
                            prodEnergiC.refreshDataDaily();
                          },
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        showDatePickerP(prodEnergiC, context),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: BarChartWidget(
                              controller: prodEnergiC, title: 'Jam'),
                        ),
                      ],
                    );
                  }
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Container showDatePickerP(
      ProdEnergiController controller, BuildContext context) {
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

  Container showDatePicker(AllPowerController allPowerC, BuildContext context) {
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
            DateFormat('dd MMM yyyy').format(allPowerC.dateTime!),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () async {
              allPowerC.getDatePicker(context);
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
