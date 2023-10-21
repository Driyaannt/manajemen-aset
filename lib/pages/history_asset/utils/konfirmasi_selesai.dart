import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/history_asset/utils/selesai.dart';

import '../../../service/database.dart';
import '../../../widget/button/small_button.dart';
import '../widgets/bottom_sheet_history.dart';

class KonfirmasiSelesai extends StatelessWidget {
  const KonfirmasiSelesai({
    Key? key,
    required this.verifPengerjaan,
    required this.namaPetugas,
    required this.docJpp,
    required this.kodeJpp,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
    required this.docHistory,
    required this.uidPetugas,
  }) : super(key: key);

  final String verifPengerjaan;
  final String namaPetugas;
  final String docJpp;
  final String kodeJpp;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docHistory;
  final String uidPetugas;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: DatabaseService().userRole(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String role = snapshot.data!.data()!['role'];
          if (role == "Vendor" && verifPengerjaan == 'Belum Verifikasi') {
            return SmallButton(
              title: 'Konfirmasi',
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return BottomSheetHistory(
                      title:
                          'Apakah pekerjaan dari petugas $namaPetugas sudah sesuai?',
                      ya: () async {
                        await Selesai().verifPengerjaan(
                          docJpp: docJpp,
                          kodeJpp: kodeJpp,
                          docPembangkit: docPembangkit,
                          jenisAset: jenisAset,
                          docAset: docAset,
                          docHistory: docHistory,
                          uidPetugas: uidPetugas,
                          verifPengerjaan: 'Diterima',
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      tidak: () async {
                        await Selesai().verifPengerjaan(
                          docJpp: docJpp,
                          kodeJpp: kodeJpp,
                          docPembangkit: docPembangkit,
                          jenisAset: jenisAset,
                          docAset: docAset,
                          docHistory: docHistory,
                          uidPetugas: uidPetugas,
                          verifPengerjaan: 'Ditolak',
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                );
              },
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
