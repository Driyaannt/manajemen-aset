import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:manajemen_aset/pages/asset/widget/elektrik_expansion_card.dart';
import 'package:manajemen_aset/pages/asset/widget/it_expansion_card.dart';
import 'package:manajemen_aset/pages/asset/widget/kd_expansion_card.dart';
import 'package:manajemen_aset/pages/asset/widget/mekanik_expansion_card.dart';
import 'package:manajemen_aset/pages/asset/widget/sensor_expansion_card.dart';
import 'package:manajemen_aset/pages/asset/widget/sipil_expansion_card.dart';

class ExpansionTileCardDemo extends StatefulWidget {
  final String idCluster;
  final String idPerangkat;
  final String kodePerangkat;
  final double latCluster;
  final double lngCluster;
  final String status;
  final String alarm;
  final String imgAlarm;
  final String jenisPerangkat;

  const ExpansionTileCardDemo({
    Key? key,
    required this.idCluster,
    required this.idPerangkat,
    required this.kodePerangkat,
    required this.latCluster,
    required this.lngCluster,
    required this.status,
    required this.alarm,
    required this.imgAlarm,
    required this.jenisPerangkat,
  }) : super(key: key);

  @override
  State<ExpansionTileCardDemo> createState() => _ExpansionTileCardDemoState();
}

class _ExpansionTileCardDemoState extends State<ExpansionTileCardDemo> {
  final GlobalKey<ExpansionTileCardState> cardMekanik = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardElektrik = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardKd = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardSensor = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardIt = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardSipil = GlobalKey();
  double distance = 0;

  // fungsi untuk mendapatkan distance antara lokasi cluster dengan lokasi user
  _getDistance() async {
    final position = await geo.Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        distance = geo.Geolocator.distanceBetween(widget.latCluster,
            widget.lngCluster, position.latitude, position.longitude);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDistance();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // mekanik
        MekanikExpansionCard(
          imageIcon: "img/mekanik.png",
          cardKey: cardMekanik,
          idCluster: widget.idCluster,
          idPerangkat: widget.idPerangkat,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          distance: distance,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),

        // elektrik
        ElektrikExpansionCard(
          imageIcon: "img/elektrik.png",
          cardKey: cardElektrik,
          idCluster: widget.idCluster,
          idPerangkat: widget.idPerangkat,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          distance: distance,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),

        // komunikasi data
        KdExpansionCard(
          imageIcon: "img/lan.png",
          cardKey: cardKd,
          idCluster: widget.idCluster,
          idPerangkat: widget.idPerangkat,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          distance: distance,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),

        // sensor
        SensorExpansionCard(
          imageIcon: "img/sensor.png",
          cardKey: cardSensor,
          idCluster: widget.idCluster,
          idPerangkat: widget.idPerangkat,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          distance: distance,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),

        // IT
        ItExpansionCard(
          imageIcon: "img/jaringan.png",
          cardKey: cardIt,
          idCluster: widget.idCluster,
          idPerangkat: widget.idPerangkat,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          distance: distance,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),

        // sipil
        SipilExpansionCard(
          imageIcon: "img/sipil.png",
          cardKey: cardSipil,
          idCluster: widget.idCluster,
          idPerangkat: widget.idPerangkat,
          kodePerangkat: widget.kodePerangkat,
          latCluster: widget.latCluster,
          lngCluster: widget.lngCluster,
          distance: distance,
          imgAlarm: widget.imgAlarm,
          jenisPerangkat: widget.jenisPerangkat,
        ),
      ],
    );
  }
}
