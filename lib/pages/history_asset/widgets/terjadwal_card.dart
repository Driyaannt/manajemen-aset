import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../history_page.dart';
import '../utils/konfirmasi_terjadwal.dart';

class TerjadwalCard extends StatelessWidget {
  const TerjadwalCard({
    Key? key,
    required this.jenisPekerjaan,
    required this.jadwalMulai,
    required this.jadwalMulaiFormated,
    required this.jadwalSelesai,
    required this.jadwalSelesaiFormated,
    required this.namaPetugas,
    required this.statusKonfirmasi,
    required this.docJpp,
    required this.kodeJpp,
    required this.spd1,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
    required this.docHistory,
    required this.uidPetugas,
    required this.agenda,
    this.isMyHistory,
  }) : super(key: key);

  final String jenisPekerjaan;
  final String jadwalMulai;
  final String jadwalMulaiFormated;
  final String jadwalSelesaiFormated;
  final String jadwalSelesai;
  final String namaPetugas;
  final String statusKonfirmasi;
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String agenda;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docHistory;
  final String uidPetugas;
  final bool? isMyHistory;

  @override
  Widget build(BuildContext context) {
    if (isMyHistory == true) {
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
              // kode aset
              Text(
                kodeJpp,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF129575),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // nama aset (spd 1)
                  Text(
                    spd1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => DetailA(
                  //           jadwalMulai: jadwalMulai,
                  //           jadwalSelesai: jadwalSelesai,
                  //           statusKonfirmasi: statusKonfirmasi,
                  //           docJpp: docJpp,
                  //           kodeJpp: kodeJpp,
                  //           spd1: spd1,
                  //           jenisPekerjaan: jenisPekerjaan,
                  //           agenda: agenda,
                  //           docPembangkit: docPembangkit,
                  //           jenisAset: jenisAset,
                  //           docAset: docAset,
                  //           docHistory: docHistory,
                  //           uidPetugas: uidPetugas,
                  //           namaPetugas: namaPetugas,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: Text(
                  //     spd1,
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  // jenis pekerjaan
                  pekerjaan(),
                ],
              ),

              // jadwal mulai
              ShowText(
                title: 'Jadwal Mulai',
                prefixIcon: Iconsax.calendar_1,
                content: jadwalMulaiFormated,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // jadwal selesai
                  ShowText(
                    title: 'Jadwal Selesai',
                    prefixIcon: Iconsax.calendar_1,
                    content: jadwalSelesaiFormated,
                  ),
                  // tombol konfirmasi
                  KonfirmasiTerjadwal(
                    uidPetugas: uidPetugas,
                    statusKonfirmasi: statusKonfirmasi,
                    jenisPekerjaan: jenisPekerjaan,
                    spd1: spd1,
                    jadwalMulai: jadwalMulai,
                    jadwalMulaiFormated: jadwalMulaiFormated,
                    jadwalSelesai: jadwalSelesai,
                    docJpp: docJpp,
                    kodeJpp: kodeJpp,
                    agenda: agenda,
                    docPembangkit: docPembangkit,
                    jenisAset: jenisAset,
                    docAset: docAset,
                    docHistory: docHistory,
                    namaPetugas: namaPetugas,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
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
                // jadwal mulai
                ShowText(
                  title: 'Jadwal Mulai',
                  prefixIcon: Iconsax.calendar_1,
                  content: jadwalMulaiFormated,
                ),
                // jenis pekerjaan
                pekerjaan(),
              ],
            ),
            // jadwal selesai
            ShowText(
              title: 'Jadwal Selesai',
              prefixIcon: Iconsax.calendar_1,
              content: jadwalSelesaiFormated,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // petugas
                ShowText(
                  title: 'Petugas',
                  prefixIcon: Iconsax.user,
                  content: namaPetugas,
                ),
                // tombol konfirmasi
                KonfirmasiTerjadwal(
                  uidPetugas: uidPetugas,
                  statusKonfirmasi: statusKonfirmasi,
                  jenisPekerjaan: jenisPekerjaan,
                  spd1: spd1,
                  jadwalMulai: jadwalMulai,
                  jadwalMulaiFormated: jadwalMulaiFormated,
                  jadwalSelesai: jadwalSelesai,
                  docJpp: docJpp,
                  kodeJpp: kodeJpp,
                  agenda: agenda,
                  docPembangkit: docPembangkit,
                  jenisAset: jenisAset,
                  docAset: docAset,
                  docHistory: docHistory,
                  namaPetugas: namaPetugas,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container pekerjaan() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: jenisPekerjaan == 'Perawatan'
              ? const Color(0xFFFFA71A)
              : jenisPekerjaan == 'Perbaikan'
                  ? const Color(0xFFDE2626)
                  : const Color(0xFFF4D810),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        jenisPekerjaan,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
