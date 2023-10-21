import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/asset/add_aset.dart';
import 'package:manajemen_aset/pages/asset/list_aset.dart';
import 'package:manajemen_aset/pages/asset/widget/button_add_komponen.dart';

import '../add_warehouse.dart';

class SensorExpansionCard extends StatelessWidget {
  const SensorExpansionCard({
    Key? key,
    required this.cardKey,
    required this.imageIcon,
    required this.idCluster,
    required this.idPerangkat,
    required this.kodePerangkat,
    required this.latCluster,
    required this.lngCluster,
    required this.distance,
    required this.imgAlarm,
    required this.jenisPerangkat,
  }) : super(key: key);

  final GlobalKey<ExpansionTileCardState> cardKey;
  final String imageIcon;
  final String idCluster;
  final String idPerangkat;
  final String kodePerangkat;
  final double latCluster;
  final double lngCluster;
  final double distance;
  final String imgAlarm;
  final String jenisPerangkat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: ExpansionTileCard(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFDBEBE7),
          child: Image.asset(imageIcon),
        ),
        baseColor: const Color.fromARGB(223, 212, 221, 218),
        expandedTextColor: const Color(0xFF129575),
        key: cardKey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sensor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 24,
              child: Image(
                image: AssetImage(imgAlarm),
              ),
            ),
          ],
        ),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          ListAset(
            idCluster: idCluster,
            idPerangkat: idPerangkat,
            kodePerangkat: kodePerangkat,
            jenisAset: 'sensor',
            jenisPerangkat: jenisPerangkat,

          ),
          // tombol tambah komponen
          ButtonAddKomponen(
            latCluster: latCluster,
            lngCluster: lngCluster,
            distance: distance,
            nextPage: () {
              if (jenisPerangkat == 'Warehouse') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddWarehouse(
                      pembangkitId: idCluster,
                      jppId: idPerangkat,
                      kodeJpp: kodePerangkat,
                      jenisAset: 'sensor',
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAset(
                      pembangkitId: idCluster,
                      jppId: idPerangkat,
                      kodeJpp: kodePerangkat,
                      jenisAset: 'sensor',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
