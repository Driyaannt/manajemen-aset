import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/monitoring/monitoring_screen.dart';

import '../../widget/bottom_sheet/info_alarm.dart';

class MonitoringGuest extends StatefulWidget {
  final String perangkatId;
  final String jenisPerangkat;
  final String kodePerangkat;

  const MonitoringGuest(
      {Key? key,
      required this.perangkatId,
      required this.jenisPerangkat,
      required this.kodePerangkat})
      : super(key: key);

  @override
  State<MonitoringGuest> createState() => _MonitoringGuestState();
}

class _MonitoringGuestState extends State<MonitoringGuest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.kodePerangkat,
          style: const TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return const SingleChildScrollView(
                      scrollDirection: Axis.vertical, child: InfoAlarm());
                },
              );
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: MonitoringScreen(
        jenisPerangkat: widget.jenisPerangkat,
        idPerangkat: widget.perangkatId,
      ),
    );
  }
}
