import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DalamProses {
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference allHistoryCollection =
      FirebaseFirestore.instance.collection('history');

  // menampilkan daftar penugasan dg status dalam proses
  Stream<QuerySnapshot> listDalamProses(
      String docPembangkit, String docJpp, String jenisAset, String docAset) {
    CollectionReference asetCollection = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset)
        .doc(docAset)
        .collection('history');
    return asetCollection
        .where('status', isEqualTo: 'Dalam Proses')
        .snapshots();
  }

  // selesai melakukan penugasan
  Future<void> selesaiPengerjaan({
    String? docJpp,
    String? kodeJpp,
    String? spd1,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? status,
    String? selesaiPengerjaan,
    String? verifPengerjaan,
    String? descPengerjaan,
    String? urlSuratIzin,
    File? imgFoto1,
    File? imgFoto2,
    String? urlFoto1,
    String? urlFoto2,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'descPengerjaan': descPengerjaan,
      'verifPengerjaan': verifPengerjaan,
      'selesaiPengerjaan': selesaiPengerjaan,
    };
    if (imgFoto1 != null) {
      final ref = FirebaseStorage.instance.ref(
          '$jenisAset/$docPembangkit-$kodeJpp-$spd1/bukti-pengerjaan1-$docHistory.png');
      await ref.putFile(imgFoto1);
      urlFoto1 = await ref.getDownloadURL();
      data.addAll({'urlFoto1': urlFoto1});
    }
    if (imgFoto2 != null) {
      final ref = FirebaseStorage.instance.ref(
          '$jenisAset/$docPembangkit-$kodeJpp-$spd1/bukti-pengerjaan2-$docHistory.png');
      await ref.putFile(imgFoto2);
      urlFoto2 = await ref.getDownloadURL();
      data.addAll({'urlFoto2': urlFoto2});
    }

    DocumentReference documentReferencer = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset!)
        .doc(docAset)
        .collection('history')
        .doc(docHistory);

    await documentReferencer.update(data).whenComplete(() async {
      Get.snackbar(
        'Berhasil',
        'Data Tersimpan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      await selesaiRekamJejak(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        status: status,
        selesaiPengerjaan: selesaiPengerjaan,
        verifPengerjaan: verifPengerjaan,
        descPengerjaan: descPengerjaan,
        urlFoto1: urlFoto1,
        urlFoto2: urlFoto2,
      );
      await selesaiAllHistory(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        status: status,
        selesaiPengerjaan: selesaiPengerjaan,
        verifPengerjaan: verifPengerjaan,
        descPengerjaan: descPengerjaan,
        urlFoto1: urlFoto1,
        urlFoto2: urlFoto2,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // selesai melakukan penugasan
  Future<void> selesaiRekamJejak({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? status,
    String? selesaiPengerjaan,
    String? verifPengerjaan,
    String? descPengerjaan,
    String? urlFoto1,
    String? urlFoto2,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'selesaiPengerjaan': selesaiPengerjaan,
      'verifPengerjaan': verifPengerjaan,
      'descPengerjaan': descPengerjaan,
      'urlFoto1': urlFoto1,
      'urlFoto2': urlFoto2,
    };
    DocumentReference documentReferencer = userCollection
        .doc(uidPetugas)
        .collection('rekam_jejak')
        .doc(docHistory);
    await documentReferencer.update(data);
  }

  // selesai melakukan penugasan
  Future<void> selesaiAllHistory({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? status,
    String? selesaiPengerjaan,
    String? verifPengerjaan,
    String? descPengerjaan,
    String? urlFoto1,
    String? urlFoto2,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'selesaiPengerjaan': selesaiPengerjaan,
      'verifPengerjaan': verifPengerjaan,
      'descPengerjaan': descPengerjaan,
      'urlFoto1': urlFoto1,
      'urlFoto2': urlFoto2,
    };
    DocumentReference documentReferencer = allHistoryCollection.doc(docHistory);
    await documentReferencer.update(data);
  }
}
