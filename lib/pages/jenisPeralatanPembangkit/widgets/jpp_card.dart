import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/monitoring_guest.dart';
import '../../bottom_nav/bottom_nav.dart';

class JppCard extends StatelessWidget {
  const JppCard({
    Key? key,
    required this.docPembangkitId,
    required this.docJppId,
    required this.id,
    required this.idPembangkit,
    required this.kode,
    required this.status,
    required this.colorStatus,
    required this.alarm,
    required this.img,
    required this.jenis,
    required this.colorAlarm,
    required this.fetchData,
    required this.latPembangkit,
    required this.lngPembangkit,
    required this.imgAlarm,
    required this.isAnon,
    required this.namaPembangkit,
  }) : super(key: key);

  final String docPembangkitId;
  final String docJppId;
  final String id;
  final String idPembangkit;
  final String kode;
  final String status;
  final Color colorStatus;
  final String alarm;
  final String img;
  final String jenis;
  final Color colorAlarm;
  final Future fetchData;
  final double latPembangkit;
  final double lngPembangkit;
  final String imgAlarm;
  final bool isAnon;
  final String namaPembangkit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isAnon) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MonitoringGuest(
                    perangkatId: id,
                    jenisPerangkat: jenis,
                    kodePerangkat: kode)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(
                docPembangkitId: docPembangkitId,
                docJppId: docJppId,
                perangkatId: id,
                jenisPerangkat: jenis,
                kodePerangkat: kode,
                latCluster: latPembangkit,
                lngCluster: lngPembangkit,
                status: status,
                alarm: alarm,
                imgAlarm: imgAlarm,
                pembangkitId: idPembangkit,
                namaPembangkit: namaPembangkit,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                blurRadius: 6,
                color: const Color(0xff000000).withOpacity(0.06),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage(img),
                width: 50,
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // kode
                    Text(
                      kode,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF129575),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // status
                    Row(
                      children: [
                        Text(
                          'Status: $status',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Iconsax.danger,
                          color: colorStatus,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // alarm
                    Row(
                      children: [
                        Text(
                          'Alarm: $alarm',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Iconsax.tick_circle,
                          color: colorAlarm,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // prod energi
                    FutureBuilder<dynamic>(
                      future: fetchData,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final dailyProd = snapshot.data;
                          return Text(
                            "Prod Energi: ${dailyProd!.powerKwh} kWh",
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              // color: Colors.black54,
                            ),
                          );
                        } else {
                          return const Center();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
