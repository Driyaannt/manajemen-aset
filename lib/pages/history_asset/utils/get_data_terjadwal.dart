import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/utils/terjadwal.dart';
import 'package:manajemen_aset/pages/history_asset/widgets/terjadwal_card.dart';

import '../../../service/database.dart';
import '../detail_history.dart';
import '../history_page.dart';

class GetDataTerjadwal extends StatelessWidget {
  const GetDataTerjadwal({
    Key? key,
    required this.docJpp,
    required this.kodeJpp,
    required this.spd1,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
  }) : super(key: key);

  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: StreamBuilder(
        stream: Terjadwal()
            .listTerjadwal(docPembangkit, docJpp, jenisAset, docAset),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data!.docs.isEmpty) {
              return const TidakAdaData();
            } else {
              List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;
              sortedDocs.sort((a, b) {
                String jadwalMulaiA = a['jadwalMulai'];
                String jadwalMulaiB = b['jadwalMulai'];
                return jadwalMulaiB.compareTo(jadwalMulaiA);
              });
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = sortedDocs[index];
                  final String docHistory = sortedDocs[index].id;
                  String agenda = documentSnapshot['agenda'];
                  String jadwalMulai = documentSnapshot['jadwalMulai'];
                  String jadwalSelesai = documentSnapshot['jadwalSelesai'];
                  String jenisPekerjaan = documentSnapshot['jenisPekerjaan'];
                  String namaPetugas = documentSnapshot['namaPetugas'];
                  String uidPetugas = documentSnapshot['uidPetugas'];
                  String alasan = documentSnapshot['alasan'] ?? "-";
                  String suratIzin = documentSnapshot['urlSuratIzin'] ?? "-";
                  String statusKonfirmasi =
                      documentSnapshot['statusKonfirmasi'];
                  String status = documentSnapshot['status'];
                  DateTime jmFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalMulai.toString());
                  String jadwalMulaiFormated =
                      DateFormat('dd MMM yyy HH:mm').format(jmFormated);
                  DateTime jsFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalSelesai.toString());
                  String jadwalSelesaiFormated =
                      DateFormat('dd MMM yyy HH:mm').format(jsFormated);
                  return GestureDetector(
                    onTap: () {
                      if (statusKonfirmasi == 'Ditolak') {
                        // ke halaman detail penugasan + alasan menolak
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailHistoryPage(
                              petugas: namaPetugas,
                              agenda: agenda,
                              jadwalMulai: jadwalMulaiFormated,
                              jadwalSelesai: jadwalSelesaiFormated,
                              alasan: alasan,
                              suratIzin: suratIzin,
                              statusKonfirmasi: statusKonfirmasi,
                              jenisPekerjaan: jenisPekerjaan,
                            ),
                          ),
                        );
                      } else {
                        // ke halaman detail penugasan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailHistoryPage(
                              petugas: namaPetugas,
                              agenda: agenda,
                              jadwalMulai: jadwalMulaiFormated,
                              jadwalSelesai: jadwalSelesaiFormated,
                              statusKonfirmasi: statusKonfirmasi,
                              status: status,
                              jenisPekerjaan: jenisPekerjaan,
                            ),
                          ),
                        );
                      }
                    },
                    child: TerjadwalCard(
                      jenisPekerjaan: jenisPekerjaan,
                      jadwalMulai: jadwalMulai,
                      jadwalMulaiFormated: jadwalMulaiFormated,
                      jadwalSelesai: jadwalSelesai,
                      jadwalSelesaiFormated: jadwalSelesaiFormated,
                      namaPetugas: namaPetugas,
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
                    ),
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RiwayatTerjadwal extends StatelessWidget {
  const RiwayatTerjadwal({Key? key, required this.controller})
      : super(key: key);
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder(
        stream: DatabaseService().historyUserTerjadwal(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data!.docs.isEmpty) {
              return const TidakAdaData();
            } else {
              List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;
              sortedDocs.sort((a, b) {
                String jadwalMulaiA = a['jadwalMulai'];
                String jadwalMulaiB = b['jadwalMulai'];
                return jadwalMulaiB.compareTo(jadwalMulaiA);
              });
              return ListView.builder(
                controller: controller,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = sortedDocs[index];
                  String agenda = documentSnapshot['agenda'];
                  String jadwalMulai = documentSnapshot['jadwalMulai'];
                  String jadwalSelesai = documentSnapshot['jadwalSelesai'];
                  String jenisPekerjaan = documentSnapshot['jenisPekerjaan'];
                  String namaPetugas = documentSnapshot['namaPetugas'];
                  String uidPetugas = documentSnapshot['uidPetugas'];
                  String alasan = documentSnapshot['alasan'] ?? "-";
                  String suratIzin = documentSnapshot['urlSuratIzin'] ?? "-";
                  String statusKonfirmasi =
                      documentSnapshot['statusKonfirmasi'];
                  String status = documentSnapshot['status'];
                  String docPembangkit = documentSnapshot['docPembangkit'];
                  String docJpp = documentSnapshot['docJpp'];
                  String kodeJpp = documentSnapshot['kodeJpp'];
                  String spd1 = documentSnapshot['spd1'];
                  String jenisAset = documentSnapshot['jenisAset'];
                  String docAset = documentSnapshot['docAset'];
                  String docHistory = documentSnapshot['docHistory'];
                  DateTime jmFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalMulai.toString());
                  String jadwalMulaiFormated =
                      DateFormat('dd MMM yyy HH:mm').format(jmFormated);
                  DateTime jsFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalSelesai.toString());
                  String jadwalSelesaiFormated =
                      DateFormat('dd MMM yyy HH:mm').format(jsFormated);
                  return GestureDetector(
                    onTap: () {
                      if (statusKonfirmasi == 'Ditolak') {
                        // ke halaman detail penugasan + alasan menolak
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailHistoryPage(
                              petugas: namaPetugas,
                              agenda: agenda,
                              jadwalMulai: jadwalMulai,
                              jadwalSelesai: jadwalSelesai,
                              alasan: alasan,
                              suratIzin: suratIzin,
                              statusKonfirmasi: statusKonfirmasi,
                              jenisPekerjaan: jenisPekerjaan,
                            ),
                          ),
                        );
                      } else {
                        // ke halaman detail penugasan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailHistoryPage(
                              petugas: namaPetugas,
                              agenda: agenda,
                              jadwalMulai: jadwalMulaiFormated,
                              jadwalSelesai: jadwalSelesaiFormated,
                              statusKonfirmasi: statusKonfirmasi,
                              status: status,
                              jenisPekerjaan: jenisPekerjaan,
                            ),
                          ),
                        );
                      }
                    },
                    child: TerjadwalCard(
                      jenisPekerjaan: jenisPekerjaan,
                      jadwalMulai: jadwalMulai,
                      jadwalMulaiFormated: jadwalMulaiFormated,
                      jadwalSelesai: jadwalSelesai,
                      jadwalSelesaiFormated: jadwalSelesaiFormated,
                      namaPetugas: namaPetugas,
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
                      isMyHistory: true,
                    ),
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
