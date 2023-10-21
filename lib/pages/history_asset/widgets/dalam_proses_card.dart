import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../service/database.dart';
import '../../../widget/button/small_button.dart';
import '../history_page.dart';
import '../selesai_form.dart';
import '../utils/konfirmasi_dalam_proses.dart';
import 'bottom_sheet_history.dart';

class DalamProsesCard extends StatelessWidget {
  const DalamProsesCard({
    Key? key,
    required this.jenisPekerjaan,
    required this.jadwalMulai,
    required this.jadwalMulaiFormated,
    required this.jadwalSelesai,
    required this.statusKonfirmasi,
    required this.jadwalSelesaiFormated,
    required this.docJpp,
    required this.kodeJpp,
    required this.docPembangkit,
    required this.jenisAset,
    required this.spd1,
    required this.uidPetugas,
    required this.namaPetugas,
    required this.docAset,
    required this.docHistory,
    required this.agenda,
    required this.mulaiPengerjaan,
    this.isMyHistory,
  }) : super(key: key);

  final String jenisPekerjaan;
  final String jadwalMulai;
  final String jadwalSelesai;
  final String jadwalMulaiFormated;
  final String jadwalSelesaiFormated;
  final String statusKonfirmasi;
  final String docJpp;
  final String kodeJpp;
  final String docPembangkit;
  final String jenisAset;
  final String spd1;
  final String uidPetugas;
  final String namaPetugas;
  final String docAset;
  final String docHistory;
  final String agenda;
  final String mulaiPengerjaan;
  final bool? isMyHistory;

  @override
  Widget build(BuildContext context) {
    if (isMyHistory == true) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                blurRadius: 6,
                color: const Color(0xff000000).withOpacity(0.06),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // kode aset
              Text(
                kodeJpp,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF129575),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // nama aset (spd 1)
                  Text(
                    spd1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // jenis pekerjaan
                  pekerjaan(),
                ],
              ),
              // jadwal mulai
              ShowText(
                title: 'Jadwal Mulai',
                prefixIcon: Iconsax.calendar_1,
                content: jadwalMulaiFormated,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // jadwal selesai
                  ShowText(
                    title: 'Jadwal Selesai',
                    prefixIcon: Iconsax.calendar_1,
                    content: jadwalSelesaiFormated,
                  ),
                  // tombol konfirmasi
                  KonfirmasiDalamProses(
                    uidPetugas: uidPetugas,
                    jenisPekerjaan: jenisPekerjaan,
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
                    agenda: agenda,
                    mulaiPengerjaan: mulaiPengerjaan,
                    namaPetugas: namaPetugas,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 6,
              color: const Color(0xff000000).withOpacity(0.06),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // jadwal mulai
                ShowText(
                  title: 'Jadwal Mulai',
                  prefixIcon: Iconsax.calendar_1,
                  content: jadwalMulaiFormated,
                ),
                // jenis pekerjaan
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: jenisPekerjaan == 'Perawatan'
                          ? const Color(0xFFFFA71A)
                          : jenisPekerjaan == 'Perbaikan'
                              ? const Color(0xFFDE2626)
                              : const Color(0xFFF4D810),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    jenisPekerjaan,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            // jadwal selesai
            ShowText(
              title: 'Jadwal Selesai',
              prefixIcon: Iconsax.calendar_1,
              content: jadwalSelesaiFormated,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // petugas
                ShowText(
                  title: 'Petugas',
                  prefixIcon: Iconsax.user,
                  content: namaPetugas,
                ),
                // tombol konfirmasi
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container pekerjaan() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: jenisPekerjaan == 'Perawatan'
              ? const Color(0xFFFFA71A)
              : jenisPekerjaan == 'Perbaikan'
                  ? const Color(0xFFDE2626)
                  : const Color(0xFFF4D810),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        jenisPekerjaan,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
