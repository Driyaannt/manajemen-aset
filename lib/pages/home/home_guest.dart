import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/profile/profile_screen_guest.dart';

import 'home_controller.dart';

class HomeGuest extends StatelessWidget {
  const HomeGuest({Key? key, required this.isAnon}) : super(key: key);
  final bool isAnon;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController(isAnon, null));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<HomeController>();
    });
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              MarkerLayer(markers: controller.markers),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                            builder: (context) => const ProfileScreenGuest(),
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
