import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/history_asset/history_page.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final String tglAwal;
  final String tglAkhir;
  final String idPembangkit;
  final String namaPembangkit;
  final String docPembangkitId;
  final String idPerangkat;
  final String docPerangkatId;
  final String jenisPerangkat;
  final String kodePerangkat;

  const PdfPreviewPage({
    Key? key,
    required this.tglAwal,
    required this.tglAkhir,
    required this.idPembangkit,
    required this.namaPembangkit,
    required this.docPembangkitId,
    required this.idPerangkat,
    required this.docPerangkatId,
    required this.jenisPerangkat,
    required this.kodePerangkat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        backgroundColor: const Color(0xFF129575),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Iconsax.arrow_left_24,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: DatabaseService()
            .allHistory(idPembangkit, docPerangkatId, tglAwal, tglAkhir),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const TidakAdaData();
          }
          final documents = snapshot.data!.docs;
          return PdfPreview(
            build: (context) => makePdf(documents),
          );
        },
      ),
    );
  }

  Future<Uint8List> makePdf(
      List<QueryDocumentSnapshot<Object?>> documents) async {
    final pdf = pw.Document();
    // final ByteData bytes = await rootBundle.load('img/pltb.png');
    // final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(24),
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Header(text: "Laporan Pemeliharaan Aset", level: 1),
                // pw.Image(pw.MemoryImage(byteList),
                //     fit: pw.BoxFit.fitHeight, height: 100, width: 100)
              ]),
              pw.Divider(
                  borderStyle: pw.BorderStyle.solid, thickness: 3, height: 8),
              pw.Divider(
                  borderStyle: pw.BorderStyle.solid, thickness: 1, height: 8),
              pw.SizedBox(height: 4),
              headingText("Nama Pembangkit:$namaPembangkit"),
              headingText("Kode Pembangkit: $kodePerangkat"),
              headingText("Jenis Pembangkit: $jenisPerangkat"),
              headingText("Periode: $tglAwal s/d $tglAkhir"),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1.5),
                children: [
                  // header row
                  pw.TableRow(
                    children: [
                      headingText('Nama Aset'),
                      headingText('Jenis Aset'),
                      headingText('Jenis Penugasan'),
                      headingText('Petugas'),
                      headingText('Mulai Pengerjaan'),
                      headingText('Selesai Pengerjaan'),
                      headingText('Keterangan'),
                    ],
                  ),
                  // isi tabel
                  for (var document in documents)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['spd1']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['jenisAset']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['jenisPekerjaan']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['namaPetugas']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['mulaiPengerjaan']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['selesaiPengerjaan']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(document['descPengerjaan']),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        }));
    return pdf.save();
  }

  pw.Padding headingText(String textContent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        textContent,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}
