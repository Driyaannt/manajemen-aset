import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/asset/widget/expansion_tile_card.dart';
import 'package:manajemen_aset/pages/history_pembangkit/history_pembangkit_page.dart';
import 'package:manajemen_aset/pages/monitoring/monitoring_screen.dart';
import 'package:manajemen_aset/pages/report/report_page.dart';
import 'package:manajemen_aset/widget/bottom_sheet/info_alarm.dart';

import '../control/control_page.dart';

class BottomNav extends StatefulWidget {
  final String docPembangkitId;
  final String docJppId;
  final String pembangkitId;
  final String perangkatId;
  final String jenisPerangkat;
  final String kodePerangkat;
  final double latCluster;
  final double lngCluster;
  final String status;
  final String alarm;
  final String imgAlarm;
  final String namaPembangkit;

  const BottomNav({
    Key? key,
    required this.docPembangkitId,
    required this.docJppId,
    required this.pembangkitId,
    required this.perangkatId,
    required this.jenisPerangkat,
    required this.kodePerangkat,
    required this.latCluster,
    required this.lngCluster,
    required this.status,
    required this.alarm,
    required this.imgAlarm,
    required this.namaPembangkit,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      ExpansionTileCardDemo(
        idCluster: widget.docPembangkitId,
        idPerangkat: widget.docJppId,
        kodePerangkat: widget.kodePerangkat,
        latCluster: widget.latCluster,
        lngCluster: widget.lngCluster,
        status: widget.status,
        alarm: widget.alarm,
        imgAlarm: widget.imgAlarm,
        jenisPerangkat: widget.jenisPerangkat,
      ),
      // pindah ke halaman untuk cek jenis aset
      MonitoringScreen(
        jenisPerangkat: widget.jenisPerangkat,
        idPerangkat: widget.perangkatId,
      ),
      // halaman control
      ControlPage(
        jenisPerangkat: widget.jenisPerangkat,
        docPerangkatId: widget.docJppId,
        idPembangkit: widget.pembangkitId,
        idPerangkat: widget.perangkatId,
        docPembangkitId: widget.docPembangkitId,
      ),
      // halaman history
      HistoryPembangkit(
        jenisPerangkat: widget.jenisPerangkat,
        docPerangkatId: widget.docJppId,
        idPembangkit: widget.pembangkitId,
        idPerangkat: widget.perangkatId,
        docPembangkitId: widget.docPembangkitId,
      ),
      // halaman report
      ReportPage(
        jenisPerangkat: widget.jenisPerangkat,
        docPerangkatId: widget.docJppId,
        idPembangkit: widget.pembangkitId,
        idPerangkat: widget.perangkatId,
        docPembangkitId: widget.docPembangkitId,
        namaPembangkit: widget.namaPembangkit,
        kodePerangkat: widget.kodePerangkat,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jenisPerangkat == 'Warehouse') {
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
        body: ExpansionTileCardDemo(
          idCluster: widget.docPembangkitId,
          idPerangkat: widget.docJppId,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          status: widget.status,
          alarm: widget.alarm,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),
      );
    }
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
      body: SizedBox(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              kBottomNavigationBarHeight,
          child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: const Color(0xFF129575),
        unselectedItemColor: Colors.black38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.box),
            label: 'Aset',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.diagram),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.toggle_off_circle),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.clock),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.note_2),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
