import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../service/database.dart';
import '../../../widget/button/small_button.dart';
import '../history_page.dart';
import '../utils/konfirmasi_selesai.dart';
import '../utils/selesai.dart';
import 'bottom_sheet_history.dart';

class SelesaiCard extends StatelessWidget {
  const SelesaiCard({
    Key? key,
    required this.jenisPekerjaan,
    required this.mulaiPengerjaan,
    required this.selesaiPengerjaan,
    required this.mulaiPengerjaanF,
    required this.selesaiPengerjaanF,
    required this.namaPetugas,
    required this.uidPetugas,
    required this.verifPengerjaan,
    required this.docJpp,
    required this.kodeJpp,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
    required this.docHistory,
    this.isMyHistory,
    this.spd1,
  }) : super(key: key);

  final String jenisPekerjaan;
  final String mulaiPengerjaan;
  final String selesaiPengerjaan;
  final String mulaiPengerjaanF;
  final String selesaiPengerjaanF;
  final String namaPetugas;
  final String uidPetugas;
  final String verifPengerjaan;
  final String docJpp;
  final String kodeJpp;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docHistory;
  final bool? isMyHistory;
  final String? spd1;

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
                    spd1!,
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
              //jadwal mulai
              ShowText(
                title: 'Mulai Pengerjaan',
                prefixIcon: Iconsax.calendar_1,
                content: mulaiPengerjaanF,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // jadwal selesai
                  ShowText(
                    title: 'Selesai Pengerjaan',
                    prefixIcon: Iconsax.calendar_1,
                    content: selesaiPengerjaanF,
                  ),
                  // tombol konfirmasi
                  KonfirmasiSelesai(
                    verifPengerjaan: verifPengerjaan,
                    namaPetugas: namaPetugas,
                    docJpp: docJpp,
                    kodeJpp: kodeJpp,
                    docPembangkit: docPembangkit,
                    jenisAset: jenisAset,
                    docAset: docAset,
                    docHistory: docHistory,
                    uidPetugas: uidPetugas,
                  ),
                ],
              ),
              // verif pengerjaan
              Text(
                verifPengerjaan == 'Belum Verifikasi'
                    ? 'Menunggu Konfirmasi'
                    : verifPengerjaan == 'Ditolak'
                        ? 'Pekerjaan Tidak Sesuai'
                        : 'Pekerjaan Telah Sesuai',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: verifPengerjaan == 'Belum Verifikasi'
                      ? const Color(0xFFFFA71A)
                      : verifPengerjaan == 'Ditolak'
                          ? const Color(0xFFDE2626)
                          : const Color(0xFF129575),
                ),
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
                //jadwal mulai
                ShowText(
                  title: 'Mulai Pengerjaan',
                  prefixIcon: Iconsax.calendar_1,
                  content: mulaiPengerjaanF,
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
              title: 'Selesai Pengerjaan',
              prefixIcon: Iconsax.calendar_1,
              content: selesaiPengerjaanF,
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
                      if (role == "Vendor" &&
                          verifPengerjaan == 'Belum Verifikasi') {
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
                ),
              ],
            ),
            // verif pengerjaan
            Text(
              verifPengerjaan == 'Belum Verifikasi'
                  ? 'Menunggu Konfirmasi'
                  : verifPengerjaan == 'Ditolak'
                      ? 'Pekerjaan Tidak Sesuai'
                      : 'Pekerjaan Telah Sesuai',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: verifPengerjaan == 'Belum Verifikasi'
                    ? const Color(0xFFFFA71A)
                    : verifPengerjaan == 'Ditolak'
                        ? const Color(0xFFDE2626)
                        : const Color(0xFF129575),
              ),
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
