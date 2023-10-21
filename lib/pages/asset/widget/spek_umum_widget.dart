import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/asset/widget/sop_display.dart';
import 'package:manajemen_aset/widget/spek_detail.dart';

class SpekUmumWidget extends StatelessWidget {
  const SpekUmumWidget({
    Key? key,
    required this.tglPasang,
    required this.spu1,
    required this.spu2,
    required this.spu3,
    required this.sopFileName,
    required this.spu4,
    required this.garansiFileName,
    required this.umurAset,
    required this.vendorPemasangan,
    required this.vendorPengadaan,
    required this.commisioning,
    required this.lokasi,
  }) : super(key: key);

  final String tglPasang;
  final String spu1;
  final String spu2;
  final String spu3;
  final String sopFileName;
  final String spu4;
  final String garansiFileName;
  final String umurAset;
  final String vendorPemasangan;
  final String vendorPengadaan;
  final String commisioning;
  final String lokasi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 6,
              color: const Color(0xff000000).withOpacity(0.06),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // judul
            const Text(
              'Spek Umum',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tanggal Dipasang
                SpekDetail(title: 'Tgl Dipasang', spd: tglPasang),
                // Tanggal Beroperasi
                SpekDetail(title: 'Tgl Beroperasi', spd: tglPasang),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Umur Aset
                SpekDetail(
                    title: 'Umur Aset', spd: umurAset.isEmpty ? '-' : umurAset),
                // Lokasi
                SpekDetail(title: 'Lokasi', spd: lokasi.isEmpty ? '-' : lokasi),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Vendor Pengadaan
                SpekDetail(
                    title: 'Vendor \nPengadaan',
                    spd: vendorPengadaan.isEmpty ? '-' : vendorPengadaan),
                // vendor pemasangan
                SpekDetail(
                    title: 'Vendor Pemasangan',
                    spd: vendorPemasangan.isEmpty ? '-' : vendorPemasangan),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Commisioning
                SpekDetail(
                    title: 'Commisioning',
                    spd: commisioning.isEmpty ? '-' : commisioning),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Manual Operation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            ManualOpText(
              title: 'SOP',
              fileName: sopFileName,
              url: spu3,
            ),

            ManualOpText(
              title: 'Garansi',
              fileName: garansiFileName,
              url: spu4,
            ),

            const Text(
              'Contact Person',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // nama
                SpekDetail(title: 'Nama', spd: spu1.isEmpty ? '-' : spu1),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // No Whatsapp
                SpekDetail(
                    title: 'No Whatsapp', spd: spu2.isEmpty ? '-' : spu2),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
