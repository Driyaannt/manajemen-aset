import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_pembangkit/rumah_energi/history_re_controller.dart';

import '../../asset/aset_controller.dart';

class HistoryRumahEnergi extends StatelessWidget {
  final String docPerangkatId;
  final String docPembangkitId;
  final String idPembangkit;
  final String idPerangkat;
  const HistoryRumahEnergi(
      {Key? key,
      required this.docPerangkatId,
      required this.docPembangkitId,
      required this.idPembangkit,
      required this.idPerangkat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryRumahEnergiC controller =
        Get.put(HistoryRumahEnergiC(idPembangkit));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<HistoryRumahEnergiC>();
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // id asset
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Center(
            child: Text(
              '0604001',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF129575),
              ),
            ),
          ),
        ),

        // mekanik
        ExpansionTileCard(
          elevation: 0,
          baseColor: const Color.fromARGB(223, 212, 221, 218),
          expandedTextColor: const Color(0xFF129575),
          title: const Text(
            'Spek Dasar Mekanik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              // color: Color(0xFF129575),
            ),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder(
              stream: AsetController()
                  .listAset(docPembangkitId, docPerangkatId, 'mekanik'),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data!.docs[index];
                        String spd11 = documentSnapshot['spd11'] ?? "-";
                        String spd12 = documentSnapshot['spd12'] ?? "-";
                        String spd13 = documentSnapshot['spd13'] ?? "-";
                        String spd14 = documentSnapshot['spd14'] ?? "-";
                        String spd15 = documentSnapshot['spd15'] ?? "-";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textAset('SPD 1.1: $spd11'),
                            textAset('SPD 1.2: $spd12'),
                            textAset('SPD 1.3: $spd13'),
                            textAset('SPD 1.4: $spd14'),
                            textAset('SPD 1.5: $spd15'),
                            kondisiAset(),
                            rekomendasiAset(),
                            const Divider(thickness: 1)
                          ],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // elektrik
        ExpansionTileCard(
          elevation: 0,
          baseColor: const Color.fromARGB(223, 212, 221, 218),
          expandedTextColor: const Color(0xFF129575),
          title: const Text(
            'Spek Dasar Elektrik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder(
              stream: AsetController()
                  .listAset(docPembangkitId, docPerangkatId, 'elektrik'),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data!.docs[index];
                        // final String mekanikId =
                        //     snapshot.data!.docs[index].id;
                        // String id = documentSnapshot['id'] ?? "-";
                        String spd21 = documentSnapshot['spd21'] ?? "-";
                        String spd22 = documentSnapshot['spd22'] ?? "-";
                        String spd23 = documentSnapshot['spd23'] ?? "-";
                        String spd24 = documentSnapshot['spd24'] ?? "-";
                        String spd25 = documentSnapshot['spd25'] ?? "-";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textAset('SPD 2.1: $spd21'),
                            textAset('SPD 2.2: $spd22'),
                            textAset('SPD 2.3: $spd23'),
                            textAset('SPD 2.4: $spd24'),
                            textAset('SPD 2.5: $spd25'),
                            kondisiAset(),
                            rekomendasiAset(),
                            const Divider(thickness: 1)
                          ],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // kd
        ExpansionTileCard(
          elevation: 0,
          baseColor: const Color.fromARGB(223, 212, 221, 218),
          expandedTextColor: const Color(0xFF129575),
          title: const Text(
            'Spek Dasar komunikasi Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder(
              stream: AsetController()
                  .listAset(docPembangkitId, docPerangkatId, 'kd'),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data!.docs[index];
                        // final String mekanikId =
                        //     snapshot.data!.docs[index].id;
                        // String id = documentSnapshot['id'] ?? "-";
                        String spd31 = documentSnapshot['spd31'] ?? "-";
                        String spd32 = documentSnapshot['spd32'] ?? "-";
                        String spd33 = documentSnapshot['spd33'] ?? "-";
                        String spd34 = documentSnapshot['spd34'] ?? "-";
                        String spd35 = documentSnapshot['spd35'] ?? "-";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textAset('SPD 3.1: $spd31'),
                            textAset('SPD 3.2: $spd32'),
                            textAset('SPD 3.3: $spd33'),
                            textAset('SPD 3.4: $spd34'),
                            textAset('SPD 3.5: $spd35'),
                            kondisiAset(),
                            rekomendasiAset(),
                            const Divider(thickness: 1)
                          ],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // sensor
        ExpansionTileCard(
          elevation: 0,
          baseColor: const Color.fromARGB(223, 212, 221, 218),
          expandedTextColor: const Color(0xFF129575),
          title: const Text(
            'Spek Dasar Sensor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder(
              stream: AsetController()
                  .listAset(docPembangkitId, docPerangkatId, 'sensor'),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data!.docs[index];
                        // final String mekanikId =
                        //     snapshot.data!.docs[index].id;
                        // String id = documentSnapshot['id'] ?? "-";
                        String spd41 = documentSnapshot['spd41'] ?? "-";
                        String spd42 = documentSnapshot['spd42'] ?? "-";
                        String spd43 = documentSnapshot['spd43'] ?? "-";
                        String spd44 = documentSnapshot['spd44'] ?? "-";
                        String spd45 = documentSnapshot['spd45'] ?? "-";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textAset('SPD 4.1: $spd41'),
                            textAset('SPD 4.2: $spd42'),
                            textAset('SPD 4.3: $spd43'),
                            textAset('SPD 4.4: $spd44'),
                            textAset('SPD 4.5: $spd45'),
                            kondisiAset(),
                            rekomendasiAset(),
                            const Divider(thickness: 1)
                          ],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // it
        ExpansionTileCard(
          elevation: 0,
          baseColor: const Color.fromARGB(223, 212, 221, 218),
          expandedTextColor: const Color(0xFF129575),
          title: const Text(
            'Spek Dasar IT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder(
              stream: AsetController()
                  .listAset(docPembangkitId, docPerangkatId, 'it'),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data!.docs[index];
                        // final String mekanikId =
                        //     snapshot.data!.docs[index].id;
                        // String id = documentSnapshot['id'] ?? "-";
                        String spd51 = documentSnapshot['spd51'] ?? "-";
                        String spd52 = documentSnapshot['spd52'] ?? "-";
                        String spd53 = documentSnapshot['spd53'] ?? "-";
                        String spd54 = documentSnapshot['spd54'] ?? "-";
                        String spd55 = documentSnapshot['spd55'] ?? "-";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textAset('SPD 5.1: $spd51'),
                            textAset('SPD 5.2: $spd52'),
                            textAset('SPD 5.3: $spd53'),
                            textAset('SPD 5.4: $spd54'),
                            textAset('SPD 5.5: $spd55'),
                            kondisiAset(),
                            rekomendasiAset(),
                            const Divider(thickness: 1)
                          ],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // sipil
        ExpansionTileCard(
          elevation: 0,
          baseColor: const Color.fromARGB(223, 212, 221, 218),
          expandedTextColor: const Color(0xFF129575),
          title: const Text(
            'Spek Dasar Sipil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            StreamBuilder(
              stream: AsetController()
                  .listAset(docPembangkitId, docPerangkatId, 'sipil'),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data!.docs[index];
                        // final String mekanikId =
                        //     snapshot.data!.docs[index].id;
                        // String id = documentSnapshot['id'] ?? "-";
                        String spd61 = documentSnapshot['spd61'] ?? "-";
                        String spd62 = documentSnapshot['spd62'] ?? "-";
                        String spd63 = documentSnapshot['spd63'] ?? "-";
                        String spd64 = documentSnapshot['spd64'] ?? "-";
                        String spd65 = documentSnapshot['spd65'] ?? "-";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textAset('SPD 6.1: $spd61'),
                            textAset('SPD 6.2: $spd62'),
                            textAset('SPD 6.3: $spd63'),
                            textAset('SPD 6.4: $spd64'),
                            textAset('SPD 6.5: $spd65'),
                            kondisiAset(),
                            rekomendasiAset(),
                            const Divider(thickness: 1)
                          ],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        const SizedBox(height: 16),
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
                    MediaQuery.of(context).size.width * 0.20)),
            Tab(
              child: filter(
                  context, 'Bulanan', MediaQuery.of(context).size.width * 0.28),
            )
          ],
        ),

        // Tab View
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 1.4,
          child: TabBarView(
            controller: controller.tabController,
            children: [
              // harian
              Column(
                children: [
                  Obx(
                    () {
                      if (controller.isLoading.isTrue) {
                        return const SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            showDatePicker(controller, context),
                            const SizedBox(height: 16),
                            Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              border: TableBorder.all(
                                width: 1.5,
                                color: const Color(0xFF129575),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    rowTabel('Elemen'),
                                    rowTabel('Min'),
                                    rowTabel('Max'),
                                    rowTabel('Avg'),
                                  ],
                                ),

                                //power
                                TableRow(
                                  children: [
                                    rowTabel('Daya (W)'),
                                    rowTabel(controller.dataReport.value.minWatt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.maxWatt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.avgWatt
                                        .toString()),
                                  ],
                                ),

                                // Tegangan (Volt)
                                TableRow(
                                  children: [
                                    rowTabel('Tegangan (V)'),
                                    rowTabel(controller.dataReport.value.minVolt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.maxVolt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.avgVolt
                                        .toString()),
                                  ],
                                ),

                                // Arus Max (Ampere)
                                TableRow(
                                  children: [
                                    rowTabel('Arus (A)'),
                                    rowTabel(controller.dataReport.value.minArus
                                        .toString()),
                                    rowTabel(controller.dataReport.value.maxArus
                                        .toString()),
                                    rowTabel(controller.dataReport.value.avgArus
                                        .toString()),
                                  ],
                                ),
                              ],
                            )
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
                      if (controller.isLoading.isTrue) {
                        return const SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            showMonthPicker(controller, context),
                            const SizedBox(height: 16),
                            Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              border: TableBorder.all(
                                width: 1.5,
                                color: const Color(0xFF129575),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    rowTabel('Elemen'),
                                    rowTabel('Min'),
                                    rowTabel('Max'),
                                    rowTabel('Avg'),
                                  ],
                                ),

                                // prod kwh
                                TableRow(
                                  children: [
                                    rowTabel('Daya (W)'),
                                    rowTabel(controller.dataReport.value.minWatt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.maxWatt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.avgWatt
                                        .toString()),
                                  ],
                                ),

                                // Tegangan (Volt)
                                TableRow(
                                  children: [
                                    rowTabel('Tegangan(V)'),
                                    rowTabel(controller.dataReport.value.minVolt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.maxVolt
                                        .toString()),
                                    rowTabel(controller.dataReport.value.avgVolt
                                        .toString()),
                                  ],
                                ),

                                // Arus Max (Ampere)
                                TableRow(
                                  children: [
                                    rowTabel('Arus (A)'),
                                    rowTabel(controller.dataReport.value.minArus
                                        .toString()),
                                    rowTabel(controller.dataReport.value.maxArus
                                        .toString()),
                                    rowTabel(controller.dataReport.value.avgArus
                                        .toString()),
                                  ],
                                ),
                              ],
                            )
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
    );
  }

  Padding rekomendasiAset() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          const Text(
            "Rekomendasi: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Table(
            defaultColumnWidth: const FixedColumnWidth(20),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
              width: 1.0,
            ),
            children: const [
              TableRow(children: [
                Text(
                  " 0 ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }

  Padding kondisiAset() {
    return const Padding(
      padding: EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(
            "Kondisi Aset: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            Icons.square,
            color: Colors.green,
            size: 18,
          )
        ],
      ),
    );
  }

  Padding textAset(String spd11) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        spd11,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
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
      HistoryRumahEnergiC controller, BuildContext context) {
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
      HistoryRumahEnergiC controller, BuildContext context) {
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

  Padding rowTabel(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
