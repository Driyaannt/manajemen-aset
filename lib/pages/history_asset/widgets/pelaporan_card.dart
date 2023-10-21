import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../history_page.dart';

class PelaporanCard extends StatelessWidget {
  const PelaporanCard(
      {Key? key,
      required this.docJpp,
      required this.kodeJpp,
      required this.spd1,
      required this.docPembangkit,
      required this.jenisAset,
      required this.docAset,
      required this.docPelaporan,
      required this.namaPetugas,
      required this.waktuPelaporan,
      required this.descPelaporan,
      required this.urlFoto1,
      required this.urlFoto2,
      required this.urlFoto3})
      : super(key: key);

  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docPelaporan;
  final String namaPetugas;
  final String waktuPelaporan;
  final String descPelaporan;
  final String urlFoto1;
  final String urlFoto2;
  final String urlFoto3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 6,
              color: const Color(0xff000000).withOpacity(0.06),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //waktu pelaporan
                ShowText(
                  title: 'Waktu Pelaporan',
                  prefixIcon: Iconsax.calendar_1,
                  content: waktuPelaporan,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFDE2626),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: const Text(
                    'Pelaporan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            // pelapor
            ShowText(
              title: 'Pelapor',
              prefixIcon: Iconsax.user,
              content: namaPetugas,
            ),
          ],
        ),
      ),
    );
  }
}
