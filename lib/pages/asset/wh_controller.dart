import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manajemen_aset/pages/asset/add_warehouse.dart';

class WHController {
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');
  Future<void> addWH({
    AsetWH? asetWH,
    String? idPembangkit,
    String? idJpp,
    String? selectedIdPembangkit,
    String? selectedIdJPP,
    String? jenisAset,
  }) async {
    DocumentReference documentReferencer = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(idJpp);

    Map<String, dynamic> data = <String, dynamic>{
      'id': asetWH!.id,
      'lokasi': 'Warehouse',
      'tglPasang': asetWH.tglPasang,
      'img1': asetWH.urlImg1,
      'img2': asetWH.urlImg2,
      'status': 'Tidak Aktif',
      'alarm': asetWH.alarm,
      'spu1': asetWH.spu1,
      'spu2': asetWH.spu2,
      'spu3': asetWH.spu3,
      'sopFileName': asetWH.sopFileName,
      'spu4': asetWH.spu4,
      'garansiFileName': asetWH.garansiFileName,
      'umurAset': asetWH.umurAset,
      'vendorPemasangan': asetWH.vendorPemasangan,
      'vendorPengadaan': asetWH.vendorPengadaan,
      'commisioning': asetWH.commisioning,
      'garansi': asetWH.garansi,
      'cratedAt': DateTime.now().toIso8601String(),
      'tglMasukWH': DateTime.now().toIso8601String(),
    };
    if (jenisAset == 'mekanik') {
      data.addAll({
        'spd11': asetWH.spd1,
        'spd12': asetWH.spd2,
        'spd13': asetWH.spd3,
        'spd14': asetWH.spd4,
        'spd15': asetWH.spd5,
      });
    } else if (jenisAset == 'elektrik') {
      data.addAll({
        'spd21': asetWH.spd1,
        'spd22': asetWH.spd2,
        'spd23': asetWH.spd3,
        'spd24': asetWH.spd4,
        'spd25': asetWH.spd5,
      });
    } else if (jenisAset == 'kd') {
      data.addAll({
        'spd31': asetWH.spd1,
        'spd32': asetWH.spd2,
        'spd33': asetWH.spd3,
        'spd34': asetWH.spd4,
        'spd35': asetWH.spd5,
      });
    } else if (jenisAset == 'sensor') {
      data.addAll({
        'spd41': asetWH.spd1,
        'spd42': asetWH.spd2,
        'spd43': asetWH.spd3,
        'spd44': asetWH.spd4,
        'spd45': asetWH.spd5,
      });
    } else if (jenisAset == 'it') {
      data.addAll({
        'spd51': asetWH.spd1,
        'spd52': asetWH.spd2,
        'spd53': asetWH.spd3,
        'spd54': asetWH.spd4,
        'spd55': asetWH.spd5,
      });
    } else {
      data.addAll({
        'spd61': asetWH.spd1,
        'spd62': asetWH.spd2,
        'spd63': asetWH.spd3,
        'spd64': asetWH.spd4,
        'spd65': asetWH.spd5,
      });
    }
    await documentReferencer
        .collection(jenisAset!)
        .doc()
        .set(data)
        .whenComplete(() => Get.snackbar(
            'Berhasil', 'Aset berhasil ditambahkan',
            backgroundColor: Colors.green[400], colorText: Colors.white));
    await delete(
      docIdPembangkit: selectedIdPembangkit,
      docIdJpp: selectedIdJPP,
      docIdAset: asetWH.docAset,
      jenisAset: jenisAset,
    ).catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
        backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  Future<void> delete({
    String? docIdPembangkit,
    String? docIdJpp,
    String? docIdAset,
    String? jenisAset,
  }) async {
    DocumentReference documentReferencer = pembangkitCollection
        .doc(docIdPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(docIdJpp)
        .collection(jenisAset!)
        .doc(docIdAset);
    await documentReferencer.delete();
  }
}
