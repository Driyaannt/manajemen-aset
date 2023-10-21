import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/utils/terjadwal.dart';

import '../../../service/database.dart';
import '../../../widget/button/small_button.dart';
import '../izin_page.dart';
import '../konfirmasi_form.dart';
import '../widgets/bottom_sheet_history.dart';

class KonfirmasiTerjadwal extends StatelessWidget {
  const KonfirmasiTerjadwal({
    Key? key,
    required this.uidPetugas,
    required this.statusKonfirmasi,
    required this.jenisPekerjaan,
    required this.spd1,
    required this.jadwalMulai,
    required this.jadwalMulaiFormated,
    required this.jadwalSelesai,
    required this.docJpp,
    required this.kodeJpp,
    required this.agenda,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
    required this.docHistory,
    required this.namaPetugas,
  }) : super(key: key);

  final String uidPetugas;
  final String statusKonfirmasi;
  final String jenisPekerjaan;
  final String spd1;
  final String jadwalMulai;
  final String jadwalMulaiFormated;
  final String jadwalSelesai;
  final String docJpp;
  final String kodeJpp;
  final String agenda;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docHistory;
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
              title: statusKonfirmasi == 'Belum Terkonfirmasi'
                  ? 'Konfirmasi'
                  : statusKonfirmasi == 'Diterima'
                      ? 'Mulai'
                      : 'Ditolak',
              color: statusKonfirmasi == 'Belum Terkonfirmasi'
                  ? const Color.fromARGB(255, 203, 149, 128)
                  : statusKonfirmasi == 'Diterima'
                      ? const Color(0xFFFFA71A)
                      : const Color(0xFFC23E3E),
              onPressed: () {
                if (statusKonfirmasi == 'Belum Terkonfirmasi') {
                  //menampilkan pop up dialog untuk konfirmasi melakuakn pekerjaan
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
                            'Apakah anda dapat melakukan $jenisPekerjaan aset $spd1 pada tanggal \n$jadwalMulaiFormated?',
                        ya: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KonfirmasiForm(
                                jadwalMulai: jadwalMulai,
                                jadwalSelesai: jadwalSelesai,
                                statusKonfirmasi: statusKonfirmasi,
                                docJpp: docJpp,
                                kodeJpp: kodeJpp,
                                spd1: spd1,
                                jenisPekerjaan: jenisPekerjaan,
                                agenda: agenda,
                                docPembangkit: docPembangkit,
                                jenisAset: jenisAset,
                                docAset: docAset,
                                docHistory: docHistory,
                                uidPetugas: uidPetugas,
                                namaPetugas: namaPetugas,
                              ),
                            ),
                          );
                        },
                        tidak: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IzinPage(
                                currentStatusKonfirmasi: statusKonfirmasi,
                                docJpp: docJpp,
                                kodeJpp: kodeJpp,
                                spd1: spd1,
                                docPembangkit: docPembangkit,
                                jenisAset: jenisAset,
                                docAset: docAset,
                                docHistory: docHistory,
                                uidPetugas: uidPetugas,
                                namaPetugas: namaPetugas,
                                jadwalMulai: jadwalMulai,
                                jenisPekerjaan: jenisPekerjaan,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (statusKonfirmasi == 'Diterima') {
                  // menampilkan pop up dialog untuk memulai pekerjaan
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
                        title: 'Mulai $jenisPekerjaan sekarang?',
                        ya: () async {
                          await Terjadwal().mulaiPengerjaan(
                            docJpp: docJpp,
                            kodeJpp: kodeJpp,
                            spd1: spd1,
                            docPembangkit: docPembangkit,
                            jenisAset: jenisAset,
                            docAset: docAset,
                            docHistory: docHistory,
                            uidPetugas: uidPetugas,
                            status: 'Dalam Proses',
                            mulaiPengerjaan: DateFormat('yyyy-MM-dd HH:mm')
                                .format(DateTime.now()),
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        tidak: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
