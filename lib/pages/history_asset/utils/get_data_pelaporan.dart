import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/detail_pelaporan.dart';
import 'package:manajemen_aset/pages/history_asset/utils/pelaporan.dart';

import '../history_page.dart';
import '../widgets/pelaporan_card.dart';

class GetDataPelaporan extends StatelessWidget {
  const GetDataPelaporan({
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
        stream: Pelaporan()
            .listPelaporan(docPembangkit, docJpp, jenisAset, docAset),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data!.docs.isEmpty) {
              return const TidakAdaData();
            } else {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = snapshot.data!.docs[index];
                  final String docPelaporan = snapshot.data!.docs[index].id;
                  String namaPetugas = documentSnapshot['namaPetugas'];
                  String waktuPelaporan = documentSnapshot['waktuPelaporan'];
                  String descPelaporan = documentSnapshot['descPelaporan'];
                  String urlFoto1 = documentSnapshot['urlFoto1'] ?? '-';
                  String urlFoto2 = documentSnapshot['urlFoto2'] ?? '-';
                  String urlFoto3 = documentSnapshot['urlFoto3'] ?? '-';
                  DateTime dtFormated = DateFormat('yyyy-MM-dd HH:mm')
                      .parse(waktuPelaporan.toString());
                  String waktuFormated =
                      DateFormat('dd MMM yyy HH:mm').format(dtFormated);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPelaporan(
                            petugas: namaPetugas,
                            waktuPelaporan: waktuFormated,
                            descPelaporan: descPelaporan,
                            urlFoto1: urlFoto1,
                            urlFoto2: urlFoto2,
                            urlFoto3: urlFoto3,
                          ),
                        ),
                      );
                    },
                    child: PelaporanCard(
                      docJpp: docJpp,
                      kodeJpp: kodeJpp,
                      spd1: spd1,
                      docPembangkit: docPembangkit,
                      jenisAset: jenisAset,
                      docAset: docAset,
                      docPelaporan: docPelaporan,
                      namaPetugas: namaPetugas,
                      waktuPelaporan: waktuFormated,
                      descPelaporan: descPelaporan,
                      urlFoto1: urlFoto1,
                      urlFoto2: urlFoto2,
                      urlFoto3: urlFoto3,
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
