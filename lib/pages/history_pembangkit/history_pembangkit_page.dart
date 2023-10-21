import 'package:flutter/cupertino.dart';
import 'package:manajemen_aset/pages/history_pembangkit/baterai/history_bt_page.dart';
import 'package:manajemen_aset/pages/history_pembangkit/diesel/history_ds_page.dart';
import 'package:manajemen_aset/pages/history_pembangkit/rumah_energi/history_re_page.dart';
import 'package:manajemen_aset/pages/history_pembangkit/solar_panel/history_sp_page.dart';
import 'package:manajemen_aset/pages/history_pembangkit/weather_station/history_ws_page.dart';
import 'package:manajemen_aset/pages/history_pembangkit/wind_turbine/history_wt_page.dart';

class HistoryPembangkit extends StatelessWidget {
  final String idPembangkit;
  final String docPerangkatId;
  final String docPembangkitId;
  final String jenisPerangkat;
  final String idPerangkat;

  const HistoryPembangkit(
      {Key? key,
      required this.idPembangkit,
      required this.docPerangkatId,
      required this.docPembangkitId,
      required this.jenisPerangkat,
      required this.idPerangkat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (jenisPerangkat == 'PLTB')
                HistoryWtPage(
                  docPerangkatId: docPerangkatId,
                  docPembangkitId: docPembangkitId,
                  idPembangkit: idPembangkit,
                  idPerangkat: idPerangkat,
                )
              else if (jenisPerangkat == 'PLTS')
                HistorySpPage(
                  docPerangkatId: docPerangkatId,
                  docPembangkitId: docPembangkitId,
                  idPembangkit: idPembangkit,
                  idPerangkat: idPerangkat,
                )
              else if (jenisPerangkat == 'Diesel')
                HistoryDsPage(
                  docPerangkatId: docPerangkatId,
                  idPembangkit: idPembangkit,
                  idPerangkat: idPerangkat,
                  docPembangkitId: docPembangkitId,
                )
              else if (jenisPerangkat == 'Baterai')
                HistoryBtPage(
                  docPerangkatId: docPerangkatId,
                  idPembangkit: idPembangkit,
                  idPerangkat: idPerangkat,
                  docPembangkitId: docPembangkitId,
                )
              else if (jenisPerangkat == 'Weather Station')
                HistoryWsPage(
                  docPerangkatId: docPerangkatId,
                  idPembangkit: idPembangkit,
                  idPerangkat: idPerangkat,
                  docPembangkitId: docPembangkitId,
                )
              else if (jenisPerangkat == 'Rumah Energi')
                HistoryRumahEnergi(
                  docPerangkatId: docPerangkatId,
                  idPembangkit: idPembangkit,
                  idPerangkat: idPerangkat,
                  docPembangkitId: docPembangkitId,
                )
            ],
          ),
        ),
      ),
    );
  }
}
