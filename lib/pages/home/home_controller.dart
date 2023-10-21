// berisikan fungsi fungsi untuk mendapatkan lokasi pembangkit dan lokasi terkini user
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:manajemen_aset/pages/home/dashboard_info.dart';
import 'package:manajemen_aset/widget/alert_dialog.dart';

import '../../models/cluster.dart';
import '../../models/user.dart';
import '../../network/base_url_controller.dart';

class HomeController extends GetxController {
  final bool isAnon;
  final UserModel? user;
  var isLoading = false.obs;
  final currentLocation = LatLng(-0.789275, 113.921327).obs;
  final List<Cluster> clusters = <Cluster>[].obs;
  final List<Cluster> wilayah = <Cluster>[].obs;

  RxList<Marker> markers = <Marker>[].obs;
  late final MapController mapController;
  // double position = 0.0;
  // final fabHeightClosed = 0.0;
  static double fabHeightClosed = 100.0;
  RxDouble fabHeight = fabHeightClosed.obs;

  HomeController(this.isAnon, this.user);

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    getCurrentLocation();
    fetchCluster();
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<HomeController>();
    super.onClose();
  }

  void updateFabHeight(double newHeight) {
    fabHeight.value = newHeight;
  }

  Future<void> fetchCluster({int retryCount = 3}) async {
    try {
      isLoading(true);
      final baseURLController = Get.put(BaseURLController());
      String domain = baseURLController.apiModel.value.domain;

      Uri url = Uri.parse("$domain/api/cluster/list");
      var response = await http.post(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var json in jsonData['data']) {
          final dataCluster = Cluster(
            idCluster: json['cluster_id'],
            clusterName: json['cluster_name'],
            kecamatan: json['kecamatan'],
            area: json['area'],
            wilayah: json['wilayah'],
            longitude: json['cluster_longitude'],
            latitude: json['cluster_latitude'],
            isActive: json['is_active'],
            totalWt: json['total_wt'],
            totalSp: json['total_sp'],
            totalDs: json['total_diesel'],
            totalBt: json['total_battery'],
            totalInv: json['total_inverter'],
            kwhWtD: json['kwh_wt_day'],
            kwhSpD: json['kwh_sp_day'],
            kwhDsD: json['kwh_diesel_day'],
            kwhBtD: json['kwh_battery_day'],
            kwhIvD: json['kwh_inverter_day'],
            kwhWtM: json['kwh_wt_mon'],
            kwhSpM: json['kwh_sp_mon'],
            kwhDsM: json['kwh_diesel_mon'],
            kwhBtM: json['kwh_battery_mon'],
            kwhIvM: json['kwh_inverter_mon'],
          );

          Color colorAlarm = Colors.grey;
          if (dataCluster.isActive == "1") {
            colorAlarm = const Color(0xFF129575);
          } else if (dataCluster.isActive == "Perringatan 1") {
            colorAlarm = const Color(0xFFF4D810);
          } else if (dataCluster.isActive == "Perringatan 2") {
            colorAlarm = const Color(0xFFA35BDC);
          } else if (dataCluster.isActive == "Sedang Service") {
            colorAlarm = const Color(0xFFFFA71A);
          } else if (dataCluster.isActive == "Bahaya") {
            colorAlarm = const Color(0xFFDE2626);
          } else if (dataCluster.isActive == "Belum Terpasang") {
            colorAlarm = const Color(0xFFA9A9A9);
          }

          Color colorWT = Colors.grey;
          Color colorSP = Colors.grey;
          Color colorDS = Colors.grey;
          if (int.parse(dataCluster.totalWt) == 0) {
            colorWT = Colors.grey;
          } else {
            colorWT = colorAlarm;
          }

          if (int.parse(dataCluster.totalSp) == 0) {
            colorSP = Colors.grey;
          } else {
            colorSP = colorAlarm;
          }

          if (int.parse(dataCluster.totalDs) == 0) {
            colorDS = Colors.grey;
          } else {
            colorDS = colorAlarm;
          }
          if (user!.tingkatan == 'Wilayah' &&
              user!.wilayah == dataCluster.wilayah) {
            clusters.add(dataCluster);
            markers.add(
              addMarker(dataCluster, colorAlarm, colorWT, colorSP, colorDS),
            );
          } else if (user!.tingkatan == 'Area' &&
              user!.area == dataCluster.area) {
            clusters.add(dataCluster);
            markers.add(
                addMarker(dataCluster, colorAlarm, colorWT, colorSP, colorDS));
          } else if (user!.tingkatan != 'Wilayah' &&
              user?.tingkatan != 'Area') {
            clusters.add(dataCluster);
            markers.add(
              addMarker(dataCluster, colorAlarm, colorWT, colorSP, colorDS),
            );
          } else if (isAnon == true) {
            clusters.add(dataCluster);
            markers.add(
              addMarker(dataCluster, colorAlarm, colorWT, colorSP, colorDS),
            );
          }
        }
      } else {
        throw Exception('Failed to load power data');
      }
    } catch (e) {
      if (retryCount > 0) {
        // Retry fetching data
        await Future.delayed(
          const Duration(seconds: 1),
        ); // Menunggu 1 detik sebelum melakukan retry
        return fetchCluster(retryCount: retryCount - 1);
      }
    } finally {
      isLoading(false);
    }
  }

  Marker addMarker(Cluster dataCluster, Color colorAlarm, Color colorWT,
      Color colorSP, Color colorDS) {
    return Marker(
      height: 40,
      width: 40,
      point: LatLng(double.parse(dataCluster.longitude),
          double.parse(dataCluster.latitude)),
      builder: (context) => IconButton(
        icon: Icon(
          Icons.wind_power,
          color: colorAlarm,
        ),
        onPressed: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DashboardInfo(
                  namaPembangkit: dataCluster.clusterName,
                  idPembangkit: dataCluster.idCluster.toString(),
                  documentId: dataCluster.idCluster.toString(),
                  latPembangkit: double.parse(dataCluster.longitude),
                  lngPembangkit: double.parse(dataCluster.latitude),
                  colorAlarm: colorAlarm,
                  colorWT: colorWT,
                  colorSP: colorSP,
                  colorDS: colorDS,
                  isAnon: isAnon,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // fungsi untuk mendapatkan lokasi terkini
  Future<dynamic> getCurrentLocation() async {
    try {
      final permission = await geo.Geolocator.requestPermission();

      if (permission == geo.LocationPermission.denied) {
        await geo.Geolocator.openAppSettings();
        return;
      }

      final position = await geo.Geolocator.getCurrentPosition();

      mapController.move(
        LatLng(position.latitude, position.longitude),
        10,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      currentLocation.value = LatLng(position.latitude, position.longitude);

      markers.add(
        Marker(
          height: 40,
          width: 40,
          point: currentLocation.value,
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.person_pin_circle_rounded,
              color: Color.fromARGB(255, 18, 86, 149),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ShowAlertDialog(
                    prefixIcon: const Icon(Iconsax.location),
                    title: 'Lokasi Anda',
                    content:
                        '${placemarks[0].administrativeArea}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].locality}, ${placemarks[0].subLocality}',
                  );
                },
              );
            },
          ),
        ),
      );
    } catch (e) {
      Get.snackbar('Peringatan', 'Gagal mendapatkan lokasi terkini anda',
          colorText: Colors.white, backgroundColor: Colors.red[400]);
    }
  }
}
