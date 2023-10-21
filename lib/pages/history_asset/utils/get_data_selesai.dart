import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/detail_history.dart';
import 'package:manajemen_aset/pages/history_asset/utils/selesai.dart';
import 'package:manajemen_aset/pages/history_asset/widgets/selesai_card.dart';
import 'package:manajemen_aset/service/database.dart';

import '../history_page.dart';

class GetDataSelesai extends StatelessWidget {
  const GetDataSelesai({
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
        stream:
            Selesai().listSelesai(docPembangkit, docJpp, jenisAset, docAset),
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
                  String descPengerjaan = documentSnapshot['descPengerjaan'];
                  String statusKonfirmasi =
                      documentSnapshot['statusKonfirmasi'];
                  String status = documentSnapshot['status'];
                  String mulaiPengerjaan =
                      documentSnapshot['mulaiPengerjaan'] ?? '-';
                  String selesaiPengerjaan =
                      documentSnapshot['selesaiPengerjaan'] ?? '-';
                  String urlFoto1 = documentSnapshot['urlFoto1'] ?? '-';
                  String urlFoto2 = documentSnapshot['urlFoto2'] ?? '-';
                  String verifPengerjaan = documentSnapshot['verifPengerjaan'];
                  DateTime jmFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalMulai.toString());
                  String jadwalMulaiF =
                      DateFormat('dd MMM yyy HH:mm').format(jmFormated);
                  DateTime jsFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalSelesai.toString());
                  String jadwalSelesaiF =
                      DateFormat('dd MMM yyy HH:mm').format(jsFormated);
                  DateTime mpFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(mulaiPengerjaan.toString());
                  String mulaiPengerjaanF =
                      DateFormat('dd MMM yyy HH:mm').format(mpFormated);
                  DateTime spFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(selesaiPengerjaan.toString());
                  String selesaiPengerjaanF =
                      DateFormat('dd MMM yyy HH:mm').format(spFormated);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailHistoryPage(
                            petugas: namaPetugas,
                            agenda: agenda,
                            jadwalMulai: jadwalMulaiF,
                            jadwalSelesai: jadwalSelesaiF,
                            mulaiPengerjaan: mulaiPengerjaanF,
                            selesaiPengerjaan: selesaiPengerjaanF,
                            statusKonfirmasi: statusKonfirmasi,
                            descPengerjaan: descPengerjaan,
                            status: status,
                            urlFoto1: urlFoto1,
                            urlFoto2: urlFoto2,
                            jenisPekerjaan: jenisPekerjaan,
                            verifPengerjaan: verifPengerjaan,
                          ),
                        ),
                      );
                    },
                    child: SelesaiCard(
                      jenisPekerjaan: jenisPekerjaan,
                      mulaiPengerjaan: mulaiPengerjaan,
                      selesaiPengerjaan: selesaiPengerjaan,
                      mulaiPengerjaanF: mulaiPengerjaanF,
                      selesaiPengerjaanF: selesaiPengerjaanF,
                      namaPetugas: namaPetugas,
                      uidPetugas: uidPetugas,
                      verifPengerjaan: verifPengerjaan,
                      docJpp: docJpp,
                      kodeJpp: kodeJpp,
                      docPembangkit: docPembangkit,
                      jenisAset: jenisAset,
                      docAset: docAset,
                      docHistory: docHistory,
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

class RiwayatSelesai extends StatelessWidget {
  const RiwayatSelesai({Key? key, required this.controller}) : super(key: key);
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder(
        stream: DatabaseService().historyUserSelesai(),
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
                  String descPengerjaan = documentSnapshot['descPengerjaan'];
                  String statusKonfirmasi =
                      documentSnapshot['statusKonfirmasi'];
                  String status = documentSnapshot['status'];
                  String mulaiPengerjaan =
                      documentSnapshot['mulaiPengerjaan'] ?? '-';
                  String selesaiPengerjaan =
                      documentSnapshot['selesaiPengerjaan'] ?? '-';
                  String urlFoto1 = documentSnapshot['urlFoto1'] ?? '-';
                  String urlFoto2 = documentSnapshot['urlFoto2'] ?? '-';
                  String verifPengerjaan = documentSnapshot['verifPengerjaan'];
                  String docPembangkit = documentSnapshot['docPembangkit'];
                  String docJpp = documentSnapshot['docJpp'];
                  String kodeJpp = documentSnapshot['kodeJpp'];
                  String spd1 = documentSnapshot['spd1'];
                  String jenisAset = documentSnapshot['jenisAset'];
                  String docAset = documentSnapshot['docAset'];
                  String docHistory = documentSnapshot['docHistory'];
                  DateTime jmFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalMulai.toString());
                  String jadwalMulaiF =
                      DateFormat('dd MMM yyy HH:mm').format(jmFormated);
                  DateTime jsFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(jadwalSelesai.toString());
                  String jadwalSelesaiF =
                      DateFormat('dd MMM yyy HH:mm').format(jsFormated);
                  DateTime mpFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(mulaiPengerjaan.toString());
                  String mulaiPengerjaanF =
                      DateFormat('dd MMM yyy HH:mm').format(mpFormated);
                  DateTime spFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(selesaiPengerjaan.toString());
                  String selesaiPengerjaanF =
                      DateFormat('dd MMM yyy HH:mm').format(spFormated);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailHistoryPage(
                            petugas: namaPetugas,
                            agenda: agenda,
                            jadwalMulai: jadwalMulaiF,
                            jadwalSelesai: jadwalSelesaiF,
                            mulaiPengerjaan: mulaiPengerjaanF,
                            selesaiPengerjaan: selesaiPengerjaanF,
                            statusKonfirmasi: statusKonfirmasi,
                            descPengerjaan: descPengerjaan,
                            status: status,
                            urlFoto1: urlFoto1,
                            urlFoto2: urlFoto2,
                            jenisPekerjaan: jenisPekerjaan,
                            verifPengerjaan: verifPengerjaan,
                          ),
                        ),
                      );
                    },
                    child: SelesaiCard(
                      jenisPekerjaan: jenisPekerjaan,
                      mulaiPengerjaan: mulaiPengerjaan,
                      selesaiPengerjaan: selesaiPengerjaan,
                      mulaiPengerjaanF: mulaiPengerjaanF,
                      selesaiPengerjaanF: selesaiPengerjaanF,
                      namaPetugas: namaPetugas,
                      uidPetugas: uidPetugas,
                      verifPengerjaan: verifPengerjaan,
                      docJpp: docJpp,
                      kodeJpp: kodeJpp,
                      docPembangkit: docPembangkit,
                      jenisAset: jenisAset,
                      docAset: docAset,
                      docHistory: docHistory,
                      isMyHistory: true,
                      spd1: spd1,
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
