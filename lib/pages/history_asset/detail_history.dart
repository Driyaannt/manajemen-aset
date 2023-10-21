import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widget/carousel_image_card.dart';
import 'history_page.dart';

class DetailHistoryPage extends StatelessWidget {
  final String? petugas;
  final String? agenda;
  final String? jadwalMulai;
  final String? jadwalSelesai;
  final String? alasan;
  final String? suratIzin;
  final String? statusKonfirmasi;
  final String? status;
  final String? mulaiPengerjaan;
  final String? selesaiPengerjaan;
  final String? descPengerjaan;
  final String? urlFoto1;
  final String? urlFoto2;
  final String? jenisPekerjaan;
  final String? verifPengerjaan;

  const DetailHistoryPage({
    Key? key,
    this.petugas,
    this.agenda,
    this.jadwalMulai,
    this.jadwalSelesai,
    this.alasan,
    this.suratIzin,
    this.statusKonfirmasi,
    this.status,
    this.mulaiPengerjaan,
    this.selesaiPengerjaan,
    this.descPengerjaan,
    this.urlFoto1,
    this.urlFoto2,
    this.jenisPekerjaan,
    this.verifPengerjaan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (statusKonfirmasi == 'Ditolak') {
      return detailPenugasanDitolak(context);
    } else if (status == 'Selesai') {
      return detailPenugasanSelesai(context);
    } else if (statusKonfirmasi == 'Diterima' && status == 'Dalam Proses') {
      return detailPenugasanDalamProses(context);
    } else {
      return detailPenugasanDiterima(context);
    }
  }

  // detail penugasan ditolak
  Scaffold detailPenugasanDitolak(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Penugasan",
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // petugas
                    ShowText(
                      title: 'Petugas',
                      prefixIcon: Iconsax.user,
                      content: petugas,
                    ),
                    // jenis pekerjaan
                    Container(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Text(
                        jenisPekerjaan!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                // agenda
                ShowText(
                  title: 'Agenda',
                  prefixIcon: Iconsax.document_text,
                  content: agenda,
                ),
                // jadwal mulai
                ShowText(
                  title: 'Jadwal Mulai',
                  prefixIcon: Iconsax.calendar_1,
                  content: jadwalMulai,
                ),
                // jadwal selesai
                ShowText(
                  title: 'Jadwal Selesai',
                  prefixIcon: Iconsax.calendar_1,
                  content: jadwalSelesai,
                ),
                // alasan
                ShowText(
                  title: 'Alasan',
                  prefixIcon: Iconsax.document_text,
                  content: alasan,
                ),
                // surat izin(foto)
                const Text(
                  'Surat Izin',
                  style: TextStyle(
                    color: Color(0xFF797979),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        child: Image(
                          image: NetworkImage(suratIzin!),
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImage(image: suratIzin!)));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // detail penugasan selesai
  Scaffold detailPenugasanSelesai(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Penugasan",
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
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
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          verifPengerjaan == 'Belum Verifikasi'
                              ? 'Menunggu Konfirmasi'
                              : verifPengerjaan == 'Ditolak'
                                  ? 'Pekerjaan Tidak Sesuai'
                                  : 'Pekerjaan Telah Sesuai',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: verifPengerjaan == 'Belum Verifikasi'
                                ? const Color(0xFFFFA71A)
                                : verifPengerjaan == 'Ditolak'
                                    ? const Color(0xFFDE2626)
                                    : const Color(0xFF129575),
                          ),
                        ),
                        // jenis pekerjaan
                        Container(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Text(
                            jenisPekerjaan!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // petugas
                    ShowText(
                      title: 'Petugas',
                      prefixIcon: Iconsax.user,
                      content: petugas,
                    ),
                    // agenda
                    ShowText(
                      title: 'Agenda',
                      prefixIcon: Iconsax.document_text,
                      content: agenda,
                    ),
                    // jadwal mulai
                    ShowText(
                      title: 'Jadwal Mulai',
                      prefixIcon: Iconsax.calendar_1,
                      content: jadwalMulai,
                    ),
                    // jadwal selesai
                    ShowText(
                      title: 'Jadwal Selesai',
                      prefixIcon: Iconsax.calendar_1,
                      content: jadwalSelesai,
                    ),
                    // mulai pengerjaan
                    ShowText(
                      title: 'Mulai Pengerjaan',
                      prefixIcon: Iconsax.calendar_1,
                      content: mulaiPengerjaan,
                    ),
                    // selesai pengerjaan
                    ShowText(
                      title: 'Selesai Pengerjaan',
                      prefixIcon: Iconsax.calendar_1,
                      content: selesaiPengerjaan,
                    ),
                    // desc
                    ShowText(
                      title: 'Deksripsi Pengerjaan',
                      prefixIcon: Iconsax.document_text,
                      content: descPengerjaan,
                    ),
                    // foto
                    const Text(
                      'Foto Bukti Pengerjaan',
                      style: TextStyle(
                        color: Color(0xFF797979),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                child: Image(
                                  image: NetworkImage(urlFoto1!),
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              image: urlFoto1!)));
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                child: Image(
                                  image: NetworkImage(urlFoto2!),
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              image: urlFoto2!)));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// detail penugasan dalam proses
  Scaffold detailPenugasanDalamProses(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Penugasan",
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // petugas
                  ShowText(
                    title: 'Petugas',
                    prefixIcon: Iconsax.user,
                    content: petugas,
                  ),
                  // jenis pekerjaan
                  Container(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      jenisPekerjaan!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              // agenda
              ShowText(
                title: 'Agenda',
                prefixIcon: Iconsax.document_text,
                content: agenda,
              ),
              // jadwal mulai
              ShowText(
                title: 'Jadwal Mulai',
                prefixIcon: Iconsax.calendar_1,
                content: jadwalMulai,
              ),
              // jadwal selesai
              ShowText(
                title: 'Jadwal Selesai',
                prefixIcon: Iconsax.calendar_1,
                content: jadwalSelesai,
              ),
              // mulai pengerjaan
              ShowText(
                title: 'Mulai Pengerjaan',
                prefixIcon: Iconsax.calendar_1,
                content: mulaiPengerjaan,
              )
            ],
          ),
        ),
      ),
    );
  }

  // detail penugasan diterima
  Scaffold detailPenugasanDiterima(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Penugasan",
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // petugas
                    ShowText(
                      title: 'Petugas',
                      prefixIcon: Iconsax.user,
                      content: petugas,
                    ),
                    // jenis pekerjaan
                    Container(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Text(
                        jenisPekerjaan!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                // agenda
                ShowText(
                  title: 'Agenda',
                  prefixIcon: Iconsax.document_text,
                  content: agenda,
                ),
                // jadwal mulai
                ShowText(
                  title: 'Jadwal Mulai',
                  prefixIcon: Iconsax.calendar_1,
                  content: jadwalMulai,
                ),
                // jadwal selesai
                ShowText(
                  title: 'Jadwal Selesai',
                  prefixIcon: Iconsax.calendar_1,
                  content: jadwalSelesai,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
