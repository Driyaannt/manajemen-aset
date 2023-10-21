import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/pages/history_asset/pelaporan/lokasi_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../history_asset/rekam_jejak_saya.dart';
import '../profile/profile_screen.dart';
import 'home_controller.dart';

class HomeOperator extends StatelessWidget {
  const HomeOperator({Key? key, required this.isAnon, required this.user})
      : super(key: key);
  final bool isAnon;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController(isAnon, user));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<HomeController>();
    });

    final panelHeightOpen = MediaQuery.of(context).size.height * 1;
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    double fabHeightClosed = 100.0;
    double fabHeight = fabHeightClosed;
    PanelController pc = PanelController();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          SlidingUpPanel(
            color: const Color(0xFFF4F3F1),
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            backdropEnabled: true,
            controller: pc,
            body: Stack(
              children: [
                FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    minZoom: 5,
                    maxZoom: 18,
                    center: controller.currentLocation.value,
                    zoom: 4.4,
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  ),
                  children: [
                    TileLayer(
                      minZoom: 1,
                      maxZoom: 18,
                      backgroundColor: Colors.black,
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: controller.markers,
                    ),
                  ],
                ),
                Positioned(
                  top: 40,
                  right: 15,
                  left: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          splashColor: Colors.grey,
                          icon: const Icon(Iconsax.search_normal_1),
                          onPressed: () {},
                        ),
                        const Expanded(
                          child: TextField(
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                hintText: "Cari..."),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.black54,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage('img/polinema.png'),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            panelBuilder: (scrollC) => RekamJejakSaya(
              c: scrollC,
              onClosePanel: () {
                pc.close();
              },
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            onPanelSlide: (position) {
              final panelMaxScrollExtent = panelHeightOpen - panelHeightClosed;
              fabHeight = position * panelMaxScrollExtent + fabHeightClosed;
              controller.updateFabHeight(fabHeight);
            },
            collapsed: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF129575),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rekam Jejak Saya',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        pc.open();
                      },
                      color: Colors.white,
                      icon: const Icon(Iconsax.arrow_up_2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => Positioned(
              right: 20,
              bottom: controller.fabHeight.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // menu untuk pelaporan darurat
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LokasiPage(userModel: user),
                        ),
                      );
                    },
                    tooltip: 'Darurat',
                    backgroundColor: const Color(0xFFF4F3F1),
                    heroTag: null,
                    child: const Icon(
                      Iconsax.danger,
                      color: Color(0xFFDE2626),
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    onPressed: () {
                      controller.getCurrentLocation();
                    },
                    tooltip: 'Lokasi Terkini',
                    child: const Icon(
                      Iconsax.gps,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
