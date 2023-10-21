import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class DatabaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference pembangkitCollection =
      FirebaseFirestore.instance.collection('pembangkit');
  final CollectionReference allHistoryCollection =
      FirebaseFirestore.instance.collection('history');
// USER
  // menambahkan user
  Future<void> addUser({UserModel? user}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: user!.email, password: "12345678");
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        await firestore.collection("user").doc(uid).set({
          "nama": user.nama,
          "email": user.email,
          "noHp": user.noHp,
          "role": user.role,
          "tingkatan": user.tingkatan,
          "wilayah": user.wilayah,
          "wilayahId": user.idWilayah,
          "area": user.area,
          "areaId": user.idArea,
          "uid": uid,
          "urlImg": user.urlImg,
          "createdAt": DateTime.now().toIso8601String(),
        });
        // await userCredential.user!.sendEmailVerification();
      }
      Get.snackbar(
        'Berhasil',
        'User Berhasil Disimpan',
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
      FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          'Berhasil',
          'Password yang digunakan terlalu singkat',
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Gagal',
          'Email sudah terdaftar!',
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat menambahkan pengguna',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }

  Future<void> editUser({UserModel? user, File? img}) async {
    Map<String, dynamic> data = <String, dynamic>{
      "nama": user!.nama,
      "noHp": user.noHp,
      "role": user.role,
      "tingkatan": user.tingkatan,
      "wilayah": user.wilayah,
      "wilayahId": user.idWilayah,
      "area": user.area,
      "areaId": user.idArea,
      "updatedAt": DateTime.now().toIso8601String(),
    };
    if (img != null) {
      final ref = FirebaseStorage.instance.ref('user/${user.email}/.png');
      await ref.putFile(img);
      user.urlImg = await ref.getDownloadURL();
      data.addAll({"urlImg": user.urlImg});
    }
    firestore
        .collection("user")
        .doc(user.uid)
        .update(data)
        .whenComplete(() => Get.snackbar(
            'Berhasil', 'Berhasil edit data profil',
            backgroundColor: Colors.green[400], colorText: Colors.white))
        .catchError((e) => Get.snackbar(
            'Terjadi Kesalahan', 'Gagal edit data profil',
            backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  Stream<QuerySnapshot> listPembangkit() {
    return pembangkitCollection.snapshots();
  }

  // menampilkan list user
  Stream<QuerySnapshot> listUser() {
    return userCollection.orderBy('nama').snapshots();
  }

  Stream<QuerySnapshot> listUserWilayah() {
    return userCollection
        .where('tingkatan', isEqualTo: 'Wilayah')
        .orderBy('nama')
        .snapshots();
  }

  Stream<QuerySnapshot> listUserArea() {
    return userCollection
        .where('tingkatan', isEqualTo: 'Area')
        .orderBy('nama')
        .snapshots();
  }

  Stream<QuerySnapshot> listUserOperator() {
    return userCollection.where('role', isEqualTo: 'Operator').snapshots();
  }

  // user role
  Stream<DocumentSnapshot<Map<String, dynamic>>> userRole() async* {
    String? uid = auth.currentUser?.uid;
    yield* firestore.collection("user").doc(uid).snapshots();
  }

  // current user
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("user").doc(uid).snapshots();
  }

  // rekam jejak user proses
  Stream<QuerySnapshot> historyUserProses() {
    String? uid = auth.currentUser?.uid;
    CollectionReference historyUserCollection =
        userCollection.doc(uid).collection('rekam_jejak');
    return historyUserCollection
        .where('status', isEqualTo: 'Dalam Proses')
        .snapshots();
  }

  // semua history
  Stream<QuerySnapshot> allHistory(
    String docPembangkit,
    String docJpp,
    String tglAwal,
    String tglAkhir,
  ) {
    return allHistoryCollection
        .where('docPembangkit', isEqualTo: docPembangkit)
        .where('docJpp', isEqualTo: docJpp)
        .where('mulaiPengerjaan', isGreaterThan: tglAwal)
        .where('mulaiPengerjaan', isLessThan: tglAkhir)
        .snapshots();
  }

  // rekam jejak user terjadwal
  Stream<QuerySnapshot> historyUserTerjadwal() {
    String? uid = auth.currentUser?.uid;
    CollectionReference historyUserCollection =
        userCollection.doc(uid).collection('rekam_jejak');
    return historyUserCollection
        .where('status', isEqualTo: 'Terjadwal')
        .snapshots();
  }

  // rekam jejak user selesai
  Stream<QuerySnapshot> historyUserSelesai() {
    String? uid = auth.currentUser?.uid;
    CollectionReference historyUserCollection =
        userCollection.doc(uid).collection('rekam_jejak');
    return historyUserCollection
        .where('status', isEqualTo: 'Selesai')
        .snapshots();
  }

// PEMBANGKIT
  // menampilkan list pembangkit
  Stream<QuerySnapshot> listpembangkit() {
    return pembangkitCollection.snapshots();
  }

// JENIS PERALATAN PEMBANGKIT
  // menambahkan jenis peralatan Pembangkit
  Future<void> addJPP({
    String? documentId,
    String? idJPP,
    String? kodeJPP,
    String? jenisJPP,
    String? statusJPP,
    String? alarmJPP,
  }) async {
    DocumentReference docReferencer = pembangkitCollection
        .doc(documentId)
        .collection('jenis_peralatan_pembangkit')
        .doc();
    Map<String, dynamic> data = <String, dynamic>{
      "id": idJPP,
      "kode": kodeJPP,
      "jenis": jenisJPP,
      "status": statusJPP,
      "alarm": alarmJPP,
      "createdAt": DateTime.now().toIso8601String()
    };
    await docReferencer
        .set(data)
        .whenComplete(() => Get.snackbar(
            'Berhasil', 'Data jenis peralatan pembangkit berhasil ditambahkan',
            backgroundColor: Colors.green[400], colorText: Colors.white))
        .catchError((e) => Get.snackbar('Terjadi Kesalahan',
            'Data jenis peralatan pembangkit gagal ditambahkan',
            backgroundColor: Colors.red[400], colorText: Colors.white));
  }

  // menampilkan list jenis peralatan pembangkit
  Stream<QuerySnapshot> listJPP(String? idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.snapshots();
  }

  // menampilkan list jenis peralatan pembangkit pltb
  Stream<QuerySnapshot> listJppWT(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.where('jenis', isEqualTo: 'PLTB').snapshots();
  }

  // menampilkan list jenis peralatan pembangkit plts
  Stream<QuerySnapshot> listJppSP(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.where('jenis', isEqualTo: 'PLTS').snapshots();
  }

  // menampilkan list jenis peralatan pembangkit diesel
  Stream<QuerySnapshot> listJppDS(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.where('jenis', isEqualTo: 'Diesel').snapshots();
  }

  // menampilkan list jenis peralatan pembangkit baterai
  Stream<QuerySnapshot> listJppBT(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.where('jenis', isEqualTo: 'Baterai').snapshots();
  }

  // menampilkan list jenis peralatan pembangkit weather station
  Stream<QuerySnapshot> listJppWS(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection
        .where('jenis', isEqualTo: 'Weather Station')
        .snapshots();
  }

  // menampilkan list jenis peralatan pembangkit rumah energi
  Stream<QuerySnapshot> listJppRE(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.where('jenis', isEqualTo: 'Rumah Energi').snapshots();
  }

  // menampilkan list warehouse
  Stream<QuerySnapshot> listJppWH(String idPembangkit) {
    CollectionReference jppCollection = pembangkitCollection
        .doc(idPembangkit)
        .collection('jenis_peralatan_pembangkit');
    return jppCollection.where('jenis', isEqualTo: 'Warehouse').snapshots();
  }
}
