import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/produksi_energi/bar_chart_widget.dart';
import 'package:manajemen_aset/pages/monitoring/produksi_energi/prod_energi_controller.dart';
import 'package:manajemen_aset/widget/button/small_button.dart';

class ProdEnergiPage extends StatelessWidget {
  final String idCluster;
  const ProdEnergiPage({Key? key, required this.idCluster}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProdEnergiController>(
      init: ProdEnergiController(idCluster),
      builder: (controller) {
        // final ProduksiEnergiController controller =
        //     Get.put(ProduksiEnergiController(idCluster));
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Produksi Energi (kWh) - Tuban',
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Iconsax.arrow_left_24),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Column(
                  children: [
                    // Tab Bar
                    TabBar(
                      controller: controller.tabController,
                      isScrollable: true,
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.black54,
                      indicator: const BubbleTabIndicator(
                        indicatorHeight: 33,
                        indicatorColor: Color.fromARGB(225, 18, 149, 117),
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        indicatorRadius: 20,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      tabs: [
                        Tab(
                          child: filter(context, 'Harian',
                              MediaQuery.of(context).size.width * 0.20),
                        ),
                        Tab(
                          child: filter(context, 'Bulanan',
                              MediaQuery.of(context).size.width * 0.23),
                        ),
                        Tab(
                          child: filter(context, 'Tahunan',
                              MediaQuery.of(context).size.width * 0.28),
                        ),
                      ],
                    ),

                    // Tab View
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 1.7,
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          // harian
                          Column(
                            children: [
                              Obx(
                                () {
                                  if (controller.isLoadingLoad.isTrue ||
                                      controller.isLoadingData.isTrue ||
                                      controller.isLoadingColor.isTrue) {
                                    return const SizedBox(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (controller
                                          .dataLoadedSuccessfully.isFalse ||
                                      controller
                                          .dataLoadLoadedSuccessfully.isFalse ||
                                      controller
                                          .configLoadedSuccessfully.isFalse) {
                                    return Column(
                                      children: [
                                        ButtonIcon(
                                          title: 'Coba Lagi',
                                          icon: Iconsax.refresh,
                                          onPressed: () {
                                            controller.refreshDataDaily();
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        showDatePicker(controller, context),
                                        SizedBox(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.68,
                                          child: BarChartWidget(
                                              controller: controller,
                                              title: 'Jam'),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),

                          // bulanan
                          Column(
                            children: [
                              Obx(
                                () {
                                  if (controller.isLoadingData.isTrue ||
                                      controller.isLoadingLoad.isTrue ||
                                      controller.isLoadingColor.isTrue) {
                                    return const SizedBox(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (controller
                                          .dataLoadedSuccessfully.isFalse ||
                                      controller
                                          .dataLoadLoadedSuccessfully.isFalse ||
                                      controller
                                          .configLoadedSuccessfully.isFalse) {
                                    return Column(
                                      children: [
                                        ButtonIcon(
                                          title: 'Coba Lagi',
                                          icon: Iconsax.refresh,
                                          onPressed: () {
                                            controller.refreshDataDaily();
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        showMonthPicker(controller, context),
                                        SizedBox(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.68,
                                          child: BarChartWidget(
                                              controller: controller,
                                              title: 'Tanggal'),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),

                          // tahunan
                          Column(
                            children: [
                              Obx(
                                () {
                                  if (controller.isLoadingData.isTrue ||
                                      controller.isLoadingLoad.isTrue ||
                                      controller.isLoadingColor.isTrue) {
                                    return const SizedBox(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (controller
                                          .dataLoadedSuccessfully.isFalse ||
                                      controller
                                          .dataLoadLoadedSuccessfully.isFalse ||
                                      controller
                                          .configLoadedSuccessfully.isFalse) {
                                    return Column(
                                      children: [
                                        ButtonIcon(
                                          title: 'Coba Lagi',
                                          icon: Iconsax.refresh,
                                          onPressed: () {
                                            controller.refreshDataDaily();
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        showYearPicker(controller, context),
                                        SizedBox(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.68,
                                          child: BarChartWidget(
                                              controller: controller,
                                              title: 'Bulan'),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container filter(BuildContext context, String title, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(225, 18, 149, 117),
        ),
        color: Colors.white60,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container showDatePicker(
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

  Container showMonthPicker(
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
            DateFormat('MMM yyyy').format(controller.monthTime!),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () async {
              controller.getMonthPicker(context);
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

  Container showYearPicker(
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
            DateFormat('yyyy').format(controller.yearTime!),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () async {
              controller.getYearPicker(context);
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
