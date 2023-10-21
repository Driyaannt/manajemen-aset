import 'dart:io';

class UserModel {
  final String nama;
  final String email;
  final String noHp;
  final String role;
  final String tingkatan;
  final String wilayah;
  final String idWilayah;
  final String area;
  final String idArea;
  String? urlImg;
  File? img;

  final String? uid;

  UserModel(
    this.nama,
    this.email,
    this.noHp,
    this.role,
    this.tingkatan,
    this.wilayah,
    this.idWilayah,
    this.area,
    this.idArea,
    this.urlImg,
    this.uid,
  );
}

class Pelaporan {
  final String wilayah;
  final String idWilayah;
  final String area;
  final String idArea;
  final String pembangkit;
  final String pembangkitId;
  final String kodeJpp;
  final String docJpp;
  final String jenisAset;
  final String spd1;
  final String docAset;
  final String user;
  final String waktuPelaporan;
  final String descPelaporan;
  final File? img1;
  final File? img2;
  final File? img3;

  Pelaporan(
      this.wilayah,
      this.idWilayah,
      this.area,
      this.idArea,
      this.pembangkit,
      this.pembangkitId,
      this.kodeJpp,
      this.docJpp,
      this.jenisAset,
      this.spd1,
      this.docAset,
      this.user,
      this.waktuPelaporan,
      this.descPelaporan,
      this.img1,
      this.img2,
      this.img3);
}
