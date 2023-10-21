import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/history_asset/pelaporan/lokasi_page.dart';

import '../../models/user.dart';
import '../profile/profile_screen.dart';
import 'home_controller.dart';

class HomePln extends StatelessWidget {
  const HomePln({Key? key, required this.isAnon, required this.user}) : super(key: key);
  final bool isAnon;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController(isAnon, user));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<HomeController>();
    });
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.isTrue) {
              return const SizedBox(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return FlutterMap(
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
                  MarkerLayer(markers: controller.markers),
                ],
              );
            }
          }),
          Positioned(
            right: 20,
            bottom: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                  tooltip: 'Current Location',
                  child: const Icon(
                    Iconsax.gps,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
    );
  }
}
