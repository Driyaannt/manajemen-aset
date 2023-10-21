import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';

import 'tren_analitik_item.dart';

class TrenAnalitik extends StatelessWidget {
  TrenAnalitik({Key? key}) : super(key: key);

  final List<TrenAnalitikData> trenAnalitik = [
    TrenAnalitikData(
      'Anomaly Detection',
      'Menemukan dan mengatasi masalah yang membutuhkan perhatian segera sebelum menjadi masalah,',
      'img/anomalies-screen.png',
    ),
    TrenAnalitikData(
        'Forecasting',
        'Merencanakan dan mengoptimalkan operasi dengan wawasan tentang peristiwa masa depan dan perilaku sistem.',
        'img/forecasting.png'),
    TrenAnalitikData(
        'Predictive Maintenance',
        'Mengidentifikasi kapan pembangkit kemungkinan mengalami kegagalan, dan mengambil langkah-langkah pencegahan untuk menghindari waktu henti.',
        'img/Maintenance.png'),
    TrenAnalitikData(
        'Self-service Analytics',
        'Memberikan pengguna alat sederhana untuk menjawab pertanyaan mereka sendiri dalam hitungan menit.',
        'img/analytics.png')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tren dan Analitik',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDBEBE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.info_circle5,
                      color: Color(0xFFFFBA4D),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Fitur ini menggunakan Kecerdasan Buatan (AI) yang akan dikembangkan selanjutnya',
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            MasonryGridView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: trenAnalitik.length,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (_, index) => TreanAnalitikItem(
                title: trenAnalitik[index].title,
                content: trenAnalitik[index].content,
                img: trenAnalitik[index].img,
                // imgSize: ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrenAnalitikData {
  final String? title;
  final String? content;
  final String? img;

  TrenAnalitikData(this.title, this.content, this.img);
}
