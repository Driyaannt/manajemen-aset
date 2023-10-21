import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Terjadwal {
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference allHistoryCollection =
      FirebaseFirestore.instance.collection('history');

  // menampilkan daftar penugasan dg status terjadwal
  Stream<QuerySnapshot> listTerjadwal(
      String docPembangkit, String docJpp, String jenisAset, String docAset) {
    CollectionReference asetCollection = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset)
        .doc(docAset)
        .collection('history');
    return asetCollection.where('status', isEqualTo: 'Terjadwal').snapshots();
  }

  // menambahkan data penugasan
  Future<void> addPenjadwalan({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? spd1,
    String? namaPetugas,
    String? uidPetugas,
    String? jenisPekerjaan,
    String? agenda,
    String? jadwalMulai,
    String? jadwalSelesai,
    String? mulaiPengerjaan,
    String? selesaiPengerjaan,
    String? descPengerjaan,
    String? urlFoto1,
    String? urlFoto2,
    String? status,
    String? statusKonfirmasi,
    String? verifPengerjaan,
    String? alasan,
    String? urlSuratIzin,
  }) async {
    DocumentReference documentReferencer = pembangkitCollection
        .doc(docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docJpp)
        .collection(jenisAset!)
        .doc(docAset)
        .collection('history')
        .doc();

    Map<String, dynamic> data = <String, dynamic>{
      'namaPetugas': namaPetugas,
      'uidPetugas': uidPetugas,
      'jenisPekerjaan': jenisPekerjaan,
      'agenda': agenda,
      'jadwalMulai': jadwalMulai,
      'jadwalSelesai': jadwalSelesai,
      'mulaiPengerjaan': mulaiPengerjaan,
      'selesaiPengerjaan': selesaiPengerjaan,
      'descPengerjaan': descPengerjaan,
      'urlFoto1': urlFoto1,
      'urlFoto2': urlFoto2,
      'status': status,
      'statusKonfirmasi': statusKonfirmasi,
      'verifPengerjaan': verifPengerjaan,
      'alasan': alasan,
      'urlSuratIzin': urlSuratIzin,
    };

    await documentReferencer.set(data).whenComplete(() async {
      Get.snackbar(
        'Berhasil',
        'Jadwal berhasil ditambahkan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      String historyPath = documentReferencer.id;
      await addRekamJejaskSaya(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        docHistory: historyPath,
        spd1: spd1,
        namaPetugas: namaPetugas,
        uidPetugas: uidPetugas,
        jenisPekerjaan: jenisPekerjaan,
        agenda: agenda,
        jadwalMulai: jadwalMulai,
        jadwalSelesai: jadwalSelesai,
        mulaiPengerjaan: mulaiPengerjaan,
        selesaiPengerjaan: selesaiPengerjaan,
        descPengerjaan: descPengerjaan,
        urlFoto1: urlFoto1,
        urlFoto2: urlFoto2,
        status: status,
        statusKonfirmasi: statusKonfirmasi,
        verifPengerjaan: verifPengerjaan,
        alasan: alasan,
        urlSuratIzin: urlSuratIzin,
      );
      await addAllHistory(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        docHistory: historyPath,
        spd1: spd1,
        namaPetugas: namaPetugas,
        uidPetugas: uidPetugas,
        jenisPekerjaan: jenisPekerjaan,
        agenda: agenda,
        jadwalMulai: jadwalMulai,
        jadwalSelesai: jadwalSelesai,
        mulaiPengerjaan: mulaiPengerjaan,
        selesaiPengerjaan: selesaiPengerjaan,
        descPengerjaan: descPengerjaan,
        urlFoto1: urlFoto1,
        urlFoto2: urlFoto2,
        status: status,
        statusKonfirmasi: statusKonfirmasi,
        verifPengerjaan: verifPengerjaan,
        alasan: alasan,
        urlSuratIzin: urlSuratIzin,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // menambahkan data penugasan
  Future<void> addRekamJejaskSaya({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? docHistory,
    String? spd1,
    String? namaPetugas,
    String? uidPetugas,
    String? jenisPekerjaan,
    String? agenda,
    String? jadwalMulai,
    String? jadwalSelesai,
    String? mulaiPengerjaan,
    String? selesaiPengerjaan,
    String? descPengerjaan,
    String? urlFoto1,
    String? urlFoto2,
    String? status,
    String? statusKonfirmasi,
    String? verifPengerjaan,
    String? alasan,
    String? urlSuratIzin,
  }) async {
    DocumentReference documentReferencer = userCollection
        .doc(uidPetugas)
        .collection('rekam_jejak')
        .doc(docHistory);
    Map<String, dynamic> data = <String, dynamic>{
      'docJpp': docJpp,
      'kodeJpp': kodeJpp,
      'docPembangkit': docPembangkit,
      'docAset': docAset,
      'jenisAset': jenisAset,
      'docHistory': docHistory,
      'spd1': spd1,
      'namaPetugas': namaPetugas,
      'uidPetugas': uidPetugas,
      'jenisPekerjaan': jenisPekerjaan,
      'agenda': agenda,
      'jadwalMulai': jadwalMulai,
      'jadwalSelesai': jadwalSelesai,
      'mulaiPengerjaan': mulaiPengerjaan,
      'selesaiPengerjaan': selesaiPengerjaan,
      'descPengerjaan': descPengerjaan,
      'urlFoto1': urlFoto1,
      'urlFoto2': urlFoto2,
      'status': status,
      'statusKonfirmasi': statusKonfirmasi,
      'verifPengerjaan': verifPengerjaan,
      'alasan': alasan,
      'urlSuratIzin': urlSuratIzin,
    };
    await documentReferencer.set(data);
  }

  // menambahkan data penugasan
  Future<void> addAllHistory({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? docHistory,
    String? spd1,
    String? namaPetugas,
    String? uidPetugas,
    String? jenisPekerjaan,
    String? agenda,
    String? jadwalMulai,
    String? jadwalSelesai,
    String? mulaiPengerjaan,
    String? selesaiPengerjaan,
    String? descPengerjaan,
    String? urlFoto1,
    String? urlFoto2,
    String? status,
    String? statusKonfirmasi,
    String? verifPengerjaan,
    String? alasan,
    String? urlSuratIzin,
  }) async {
    DocumentReference documentReferencer = allHistoryCollection.doc(docHistory);
    Map<String, dynamic> data = <String, dynamic>{
      'docJpp': docJpp,
      'kodeJpp': kodeJpp,
      'docPembangkit': docPembangkit,
      'docAset': docAset,
      'jenisAset': jenisAset,
      'docHistory': docHistory,
      'spd1': spd1,
      'namaPetugas': namaPetugas,
      'uidPetugas': uidPetugas,
      'jenisPekerjaan': jenisPekerjaan,
      'agenda': agenda,
      'jadwalMulai': jadwalMulai,
      'jadwalSelesai': jadwalSelesai,
      'mulaiPengerjaan': mulaiPengerjaan,
      'selesaiPengerjaan': selesaiPengerjaan,
      'descPengerjaan': descPengerjaan,
      'urlFoto1': urlFoto1,
      'urlFoto2': urlFoto2,
      'status': status,
      'statusKonfirmasi': statusKonfirmasi,
      'verifPengerjaan': verifPengerjaan,
      'alasan': alasan,
      'urlSuratIzin': urlSuratIzin,
    };
    await documentReferencer.set(data);
  }

  // menolak penugasan
  Future<void> izinHistory({
    String? docJpp,
    String? kodeJpp,
    String? spd1,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? statusKonfirmasi,
    String? alasan,
    String? urlSuratIzin,
    File? imgSuratIzin,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'statusKonfirmasi': statusKonfirmasi,
      'alasan': alasan,
    };
    if (imgSuratIzin != null) {
      final ref = FirebaseStorage.instance.ref(
          '$jenisAset/$docPembangkit-$kodeJpp-$spd1/suratIzin-$docHistory.png');
      await ref.putFile(imgSuratIzin);
      urlSuratIzin = await ref.getDownloadURL();
      data.addAll({'urlSuratIzin': urlSuratIzin});
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
        'Surat Izin ditambahkan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      await izinRekamJejak(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        statusKonfirmasi: statusKonfirmasi,
        alasan: alasan,
        urlSuratIzin: urlSuratIzin,
      );
      await izinAllHistory(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        statusKonfirmasi: statusKonfirmasi,
        alasan: alasan,
        urlSuratIzin: urlSuratIzin,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // menolak penugasan
  Future<void> izinRekamJejak({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? statusKonfirmasi,
    String? alasan,
    String? urlSuratIzin,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'statusKonfirmasi': statusKonfirmasi,
      'alasan': alasan,
      'urlSuratIzin': urlSuratIzin,
    };
    DocumentReference documentReferencer = userCollection
        .doc(uidPetugas)
        .collection('rekam_jejak')
        .doc(docHistory);
    await documentReferencer.update(data);
  }

  // menolak penugasan
  Future<void> izinAllHistory({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? statusKonfirmasi,
    String? alasan,
    String? urlSuratIzin,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'statusKonfirmasi': statusKonfirmasi,
      'alasan': alasan,
      'urlSuratIzin': urlSuratIzin,
    };
    DocumentReference documentReferencer = allHistoryCollection.doc(docHistory);
    await documentReferencer.update(data);
  }

  // terima penugasan
  Future<void> konfirmasiHistory({
    String? docJpp,
    String? kodeJpp,
    String? spd1,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? statusKonfirmasi,
    String? jadwalMulai,
    String? jadwalSelesai,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'statusKonfirmasi': statusKonfirmasi,
      'jadwalMulai': jadwalMulai,
      'jadwalSelesai': jadwalSelesai,
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
        'Data Tersimpan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      await konfirmasiRekamJejak(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        statusKonfirmasi: statusKonfirmasi,
        jadwalMulai: jadwalMulai,
        jadwalSelesai: jadwalSelesai,
      );
      await konfirmasiAllHistory(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        statusKonfirmasi: statusKonfirmasi,
        jadwalMulai: jadwalMulai,
        jadwalSelesai: jadwalSelesai,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // terima penugasan
  Future<void> konfirmasiRekamJejak({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? statusKonfirmasi,
    String? jadwalMulai,
    String? jadwalSelesai,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'statusKonfirmasi': statusKonfirmasi,
      'jadwalMulai': jadwalMulai,
      'jadwalSelesai': jadwalSelesai,
    };
    DocumentReference documentReferencer = userCollection
        .doc(uidPetugas)
        .collection('rekam_jejak')
        .doc(docHistory);
    await documentReferencer.update(data);
  }

  // terima penugasan
  Future<void> konfirmasiAllHistory({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? statusKonfirmasi,
    String? jadwalMulai,
    String? jadwalSelesai,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'statusKonfirmasi': statusKonfirmasi,
      'jadwalMulai': jadwalMulai,
      'jadwalSelesai': jadwalSelesai,
    };
    DocumentReference documentReferencer = allHistoryCollection.doc(docHistory);
    await documentReferencer.update(data);
  }

  // mulai pengerjaan
  Future<void> mulaiPengerjaan({
    String? docJpp,
    String? kodeJpp,
    String? spd1,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? status,
    String? mulaiPengerjaan,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'mulaiPengerjaan': mulaiPengerjaan,
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
        'Data Tersimpan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      await mulaiRekamJejak(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        status: status,
        mulaiPengerjaan: mulaiPengerjaan,
      );
      await mulaiAllHistory(
        docJpp: docJpp,
        kodeJpp: kodeJpp,
        docPembangkit: docPembangkit,
        jenisAset: jenisAset,
        docAset: docAset,
        uidPetugas: uidPetugas,
        docHistory: docHistory,
        status: status,
        mulaiPengerjaan: mulaiPengerjaan,
      );
    }).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // mulai pengerjaan
  Future<void> mulaiRekamJejak({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? status,
    String? mulaiPengerjaan,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'mulaiPengerjaan': mulaiPengerjaan,
    };
    DocumentReference documentReferencer = userCollection
        .doc(uidPetugas)
        .collection('rekam_jejak')
        .doc(docHistory);
    await documentReferencer.update(data);
  }

  // mulai pengerjaan
  Future<void> mulaiAllHistory({
    String? docJpp,
    String? kodeJpp,
    String? docPembangkit,
    String? jenisAset,
    String? docAset,
    String? uidPetugas,
    String? docHistory,
    String? status,
    String? mulaiPengerjaan,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'mulaiPengerjaan': mulaiPengerjaan,
    };
    DocumentReference documentReferencer = allHistoryCollection.doc(docHistory);
    await documentReferencer.update(data);
  }
}
