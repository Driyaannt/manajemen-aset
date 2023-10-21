import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/aset.dart';

class AsetController {
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');

  Stream<QuerySnapshot> listAset(
      String? idPembangkit, String? idJpp, String? jenisAset) {
    CollectionReference asetCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(idJpp)
        .collection(jenisAset!);
    return asetCollection.snapshots();
  }

  Future<void> addAset({
    String? id,
    String? spd1,
    String? spd2,
    String? spd3,
    String? spd4,
    String? spd5,
    String? lokasi,
    String? tglPasang,
    String? idJpp,
    String? kodeJpp,
    String? idPembangkit,
    String? url1,
    String? url2,
    File? img1,
    File? img2,
    String? status,
    String? alarm,
    String? spu1,
    String? spu2,
    String? spu3,
    String? sopFileName,
    String? spu4,
    String? garansiFileName,
    String? umurAset,
    String? vendorPemasangan,
    String? vendorPengadaan,
    String? commisioning,
    String? garansi,
    String? jenisAset,
  }) async {
    DocumentReference documentReferencer = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(idJpp);

    final ref = FirebaseStorage.instance
        .ref('$jenisAset/$idPembangkit-$kodeJpp-$spd1/1.png');
    final ref2 = FirebaseStorage.instance
        .ref('$jenisAset/$idPembangkit-$kodeJpp-$spd1/2.png');
    await ref.putFile(img1!);
    await ref2.putFile(img2!);
    url1 = await ref.getDownloadURL();
    url2 = await ref2.getDownloadURL();

    Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'lokasi': lokasi,
      'tglPasang': tglPasang,
      'img1': url1,
      'img2': url2,
      'status': status,
      'alarm': alarm,
      'spu1': spu1,
      'spu2': spu2,
      'spu3': spu3,
      'sopFileName': sopFileName,
      'spu4': spu4,
      'garansiFileName': garansiFileName,
      'umurAset': umurAset,
      'vendorPemasangan': vendorPemasangan,
      'vendorPengadaan': vendorPengadaan,
      'commisioning': commisioning,
      'garansi': garansi,
      'cratedAt': DateTime.now().toIso8601String(),
    };
    if (jenisAset == 'mekanik') {
      data.addAll({
        'spd11': spd1,
        'spd12': spd2,
        'spd13': spd3,
        'spd14': spd4,
        'spd15': spd5
      });
    } else if (jenisAset == 'elektrik') {
      data.addAll({
        'spd21': spd1,
        'spd22': spd2,
        'spd23': spd3,
        'spd24': spd4,
        'spd25': spd5
      });
    } else if (jenisAset == 'kd') {
      data.addAll({
        'spd31': spd1,
        'spd32': spd2,
        'spd33': spd3,
        'spd34': spd4,
        'spd35': spd5
      });
    } else if (jenisAset == 'sensor') {
      data.addAll({
        'spd41': spd1,
        'spd42': spd2,
        'spd43': spd3,
        'spd44': spd4,
        'spd45': spd5
      });
    } else if (jenisAset == 'it') {
      data.addAll({
        'spd51': spd1,
        'spd52': spd2,
        'spd53': spd3,
        'spd54': spd4,
        'spd55': spd5
      });
    } else if (jenisAset == 'sipil') {
      data.addAll({
        'spd61': spd1,
        'spd62': spd2,
        'spd63': spd3,
        'spd64': spd4,
        'spd65': spd5
      });
    }

    await documentReferencer
        .collection('$jenisAset')
        .doc()
        .set(data)
        .whenComplete(() => Get.snackbar(
            'Berhasil', 'Aset berhasil ditambahkan',
            backgroundColor: Colors.green[400], colorText: Colors.white))
        .catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
            backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  Future<void> editAset({
    String? id,
    String? spd1,
    String? spd2,
    String? spd3,
    String? spd4,
    String? spd5,
    String? lokasi,
    String? tglPasang,
    String? idJpp,
    String? kodeJpp,
    String? idPembangkit,
    String? url1,
    String? url2,
    File? img1,
    File? img2,
    String? docAset,
    String? status,
    String? alarm,
    String? spu1,
    String? spu2,
    File? spu3,
    String? sopFileName,
    String? sopFileUrl,
    File? spu4,
    String? garansiFileName,
    String? garansiFileUrl,
    String? umurAset,
    String? vendorPemasangan,
    String? vendorPengadaan,
    String? commisioning,
    String? garansi,
    String? jenisAset,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      'lokasi': lokasi,
      'tglPasang': tglPasang,
      'status': status,
      'alarm': alarm,
      'spu1': spu1,
      'spu2': spu2,
      'umurAset': umurAset,
      'vendorPemasangan': vendorPemasangan,
      'vendorPengadaan': vendorPengadaan,
      'commisioning': commisioning,
      'garansi': garansi,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (jenisAset == 'mekanik') {
      data.addAll({
        'spd11': spd1,
        'spd12': spd2,
        'spd13': spd3,
        'spd14': spd4,
        'spd15': spd5
      });
    } else if (jenisAset == 'elektrik') {
      data.addAll({
        'spd21': spd1,
        'spd22': spd2,
        'spd23': spd3,
        'spd24': spd4,
        'spd25': spd5
      });
    } else if (jenisAset == 'kd') {
      data.addAll({
        'spd31': spd1,
        'spd32': spd2,
        'spd33': spd3,
        'spd34': spd4,
        'spd35': spd5
      });
    } else if (jenisAset == 'sensor') {
      data.addAll({
        'spd41': spd1,
        'spd42': spd2,
        'spd43': spd3,
        'spd44': spd4,
        'spd45': spd5
      });
    } else if (jenisAset == 'it') {
      data.addAll({
        'spd51': spd1,
        'spd52': spd2,
        'spd53': spd3,
        'spd54': spd4,
        'spd55': spd5
      });
    } else if (jenisAset == 'sipil') {
      data.addAll({
        'spd61': spd1,
        'spd62': spd2,
        'spd63': spd3,
        'spd64': spd4,
        'spd65': spd5
      });
    }

    if (img1 != null) {
      final ref = FirebaseStorage.instance
          .ref('$jenisAset/$idPembangkit-$kodeJpp-$spd1/1.png');
      await ref.putFile(img1);
      url1 = await ref.getDownloadURL();
      data.addAll({'img1': url1});
    }
    if (img2 != null) {
      final ref2 = FirebaseStorage.instance
          .ref('$jenisAset/$idPembangkit-$kodeJpp-$spd1/2.png');
      await ref2.putFile(img2);
      url2 = await ref2.getDownloadURL();
      data.addAll({'img2': url2});
    }
    if (spu3 != null) {
      final ref3 = FirebaseStorage.instance
          .ref('$jenisAset/$idPembangkit-$kodeJpp-$spd1/$sopFileName');
      await ref3.putFile(spu3);
      sopFileUrl = await ref3.getDownloadURL();
      data.addAll({'spu3': sopFileUrl, 'sopFileName': sopFileName});
    }
    if (spu4 != null) {
      final ref4 = FirebaseStorage.instance
          .ref('$jenisAset/$idPembangkit-$kodeJpp-$spd1/$garansiFileName');
      await ref4.putFile(spu4);
      garansiFileUrl = await ref4.getDownloadURL();
      data.addAll({'spu4': garansiFileUrl, 'garansiFileName': garansiFileName});
    }
    DocumentReference documentReferencer = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(idJpp)
        .collection('$jenisAset')
        .doc(docAset);
    await documentReferencer
        .update(data)
        .whenComplete(
          () => Get.snackbar('Berhasil', 'Aset berhasil edit',
              backgroundColor: Colors.green[400], colorText: Colors.white),
        )
        .catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
            backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  Future<void> deleteAset({
    Aset? aset,
    String? jenisAset,
  }) async {
    DocumentReference documentReferencer = pembangkitCollection
        .doc(aset!.docPembangkit)
        .collection('jenis_peralatan_pembangkit')
        .doc(aset.docJpp)
        .collection('$jenisAset')
        .doc(aset.docAsetId);
    // final ref = FirebaseStorage.instance.ref(
    //     '$jenisAset/${aset.docPembangkit}-${aset.kodeJpp}-${aset.spd1}/1.png');
    // final ref2 = FirebaseStorage.instance.ref(
    //     '$jenisAset/${aset.docPembangkit}-${aset.kodeJpp}-${aset.spd1}/2.png');
    // if (aset.sopFileName != '-' && aset.sopFileName != '') {
    //   final ref3 = FirebaseStorage.instance.ref(
    //       '$jenisAset/${aset.docPembangkit}-${aset.kodeJpp}-${aset.spd1}/${aset.sopFileName}');
    //   await ref3.delete();
    // }
    // if (aset.garansiFileName != '-' && aset.garansiFileName != '') {
    //   final ref4 = FirebaseStorage.instance.ref(
    //       '$jenisAset/${aset.docPembangkit}-${aset.kodeJpp}-${aset.spd1}/${aset.garansiFileName}');
    //   await ref4.delete();
    // }
    // await ref.delete();
    // await ref2.delete();

    await documentReferencer
        .delete()
        .whenComplete(() => Get.snackbar('Berhasil', 'Aset berhasil dihapus',
            backgroundColor: Colors.green[400], colorText: Colors.white))
        .catchError((e) => Get.snackbar('Terjadi Kesalahan', '$e',
            backgroundColor: Colors.red[400], colorText: Colors.white));
  }
}
