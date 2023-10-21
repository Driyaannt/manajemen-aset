import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/widget/card/info_alarm.dart';

class InfoAlarm extends StatelessWidget {
  const InfoAlarm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keterangan Alarm Aset',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoAlarmCard(image: 'img/alarm/aman.png', title: 'Aman'),
            // bahaya
            InfoAlarmCard(image: 'img/alarm/bahaya.png', title: 'Bahaya'),
            // peringatan 1
            InfoAlarmCard(
                image: 'img/alarm/peringatan1.png',
                title: 'Service dalam waktu 2 x 24 jam'),
            // peringatan 2
            InfoAlarmCard(
                image: 'img/alarm/peringatan2.png',
                title: 'Service dalam waktu 3 x 24 jam'),
            // sedang dilakukan service
            InfoAlarmCard(
                image: 'img/alarm/service.png',
                title: 'Sedang dilakukan service'),
            // belum  terpasang
            InfoAlarmCard(
                image: 'img/alarm/kosong.png',
                title: 'Pembangkit belum terpasang')
          ],
        ),
      ),
    );
  }

  buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
