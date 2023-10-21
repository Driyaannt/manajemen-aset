import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pelaporan {
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  // menampilkan data pelaporan
  Stream<QuerySnapshot> listPelaporan(
      String docPembangkit, String docJpp, String jenisAset, String docAset) {
    CollectionReference asetCollection = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset)
        .doc(docAset)
        .collection('pelaporan');
    return asetCollection
        .orderBy('waktuPelaporan', descending: true)
        .snapshots();
  }

  // menambahkan data pelaporan
  Future<void> addPelaporan({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? spd1,
    String? namaPetugas,
    String? waktuPelaporan,
    String? descPelaporan,
    File? imgFoto1,
    File? imgFoto2,
    File? imgFoto3,
    String? urlFoto1,
    String? urlFoto2,
    String? urlFoto3,
  }) async {
    DocumentReference documentReferencer = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset!)
        .doc(docAset)
        .collection('pelaporan')
        .doc();

    Map<String, dynamic> data = <String, dynamic>{
      'namaPetugas': namaPetugas,
      'waktuPelaporan': waktuPelaporan,
      'descPelaporan': descPelaporan,
      'urlFoto2': urlFoto2,
      'urlFoto3': urlFoto3,
      'createdAt': DateTime.now().toIso8601String(),
    };
    String pelaporanPath = documentReferencer.id;

    if (imgFoto1 != null) {
      final ref = FirebaseStorage.instance.ref(
          '$jenisAset/$docPembangkit-$kodeJpp-$spd1/pelaporan1-$pelaporanPath.png');
      await ref.putFile(imgFoto1);
      urlFoto1 = await ref.getDownloadURL();
      data.addAll({'urlFoto1': urlFoto1});
    }
    if (imgFoto2 != null) {
      final ref = FirebaseStorage.instance.ref(
          '$jenisAset/$docPembangkit-$kodeJpp-$spd1/pelaporan2-$pelaporanPath.png');
      await ref.putFile(imgFoto2);
      urlFoto2 = await ref.getDownloadURL();
      data.addAll({'urlFoto2': urlFoto2});
    }
    if (imgFoto3 != null) {
      final ref = FirebaseStorage.instance.ref(
          '$jenisAset/$docPembangkit-$kodeJpp-$spd1/pelaporan3-$pelaporanPath.png');
      await ref.putFile(imgFoto3);
      urlFoto3 = await ref.getDownloadURL();
      data.addAll({'urlFoto3': urlFoto3});
    }

    await documentReferencer.set(data).whenComplete(() async {
      Get.snackbar(
        'Berhasil',
        'Pelaporan berhasil ditambahkan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }
}
