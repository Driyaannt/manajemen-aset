import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../service/database.dart';
import '../../../widget/button/small_button.dart';
import '../selesai_form.dart';
import '../widgets/bottom_sheet_history.dart';

class KonfirmasiDalamProses extends StatelessWidget {
  const KonfirmasiDalamProses({
    Key? key,
    required this.uidPetugas,
    required this.jenisPekerjaan,
    required this.jadwalMulai,
    required this.jadwalSelesai,
    required this.statusKonfirmasi,
    required this.docJpp,
    required this.kodeJpp,
    required this.spd1,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
    required this.docHistory,
    required this.agenda,
    required this.mulaiPengerjaan,
    required this.namaPetugas,
  }) : super(key: key);

  final String uidPetugas;
  final String jenisPekerjaan;
  final String jadwalMulai;
  final String jadwalSelesai;
  final String statusKonfirmasi;
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docHistory;
  final String agenda;
  final String mulaiPengerjaan;
  final String namaPetugas;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: DatabaseService().userRole(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String role = snapshot.data!.data()!['role'];
          String uid = snapshot.data!.data()!['uid'];
          if (role == "Operator" && uid == uidPetugas) {
            return SmallButton(
              title: 'Selesai',
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
                          'Apakah anda sudah selesai melakukan $jenisPekerjaan?',
                      ya: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelesaiForm(
                              jadwalMulai: jadwalMulai,
                              jadwalSelesai: jadwalSelesai,
                              statusKonfirmasi: statusKonfirmasi,
                              docJpp: docJpp,
                              kodeJpp: kodeJpp,
                              spd1: spd1,
                              docPembangkit: docPembangkit,
                              jenisAset: jenisAset,
                              docAset: docAset,
                              docHistory: docHistory,
                              uidPetugas: uidPetugas,
                              agenda: agenda,
                              jenisPekerjaan: jenisPekerjaan,
                              mulaiPengerjaan: mulaiPengerjaan,
                              namaPetugas: namaPetugas,
                            ),
                          ),
                        );
                      },
                      tidak: () {
                        Navigator.pop(context);
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
