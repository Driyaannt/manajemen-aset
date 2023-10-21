import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Selesai {
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference allHistoryCollection =
      FirebaseFirestore.instance.collection('history');
  //menampilkan data penugasan dg status selesai
  Stream<QuerySnapshot> listSelesai(
      String docPembangkit, String docJpp, String jenisAset, String docAset) {
    CollectionReference asetCollection = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset)
        .doc(docAset)
        .collection('history');
    return asetCollection.where('status', isEqualTo: 'Selesai').snapshots();
  }

  // verif penugasan oleh vendor
  Future<void> verifPengerjaan({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? verifPengerjaan,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'verifPengerjaan': verifPengerjaan,
    };
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
        'Penugasan Berhasil Diverifikasi ',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      await verifRekamJejak(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        verifPengerjaan: verifPengerjaan,
      );

      await verifAllHistory(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        verifPengerjaan: verifPengerjaan,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // verif penugasan oleh vendor
  Future<void> verifRekamJejak({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? verifPengerjaan,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'verifPengerjaan': verifPengerjaan,
    };
    DocumentReference documentReferencer = userCollection
        .doc(uidPetugas)
        .collection('rekam_jejak')
        .doc(docHistory);
    await documentReferencer.update(data);
  }

  // verif penugasan oleh vendor
  Future<void> verifAllHistory({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? verifPengerjaan,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'verifPengerjaan': verifPengerjaan,
    };
    DocumentReference documentReferencer = allHistoryCollection.doc(docHistory);
    await documentReferencer.update(data);
  }
}
