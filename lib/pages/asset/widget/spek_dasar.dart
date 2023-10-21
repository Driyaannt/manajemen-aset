import 'package:flutter/material.dart';
import 'package:manajemen_aset/widget/spek_detail.dart';

class SpekDasarWidget extends StatelessWidget {
  const SpekDasarWidget({
    Key? key,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    required this.spd1,
    required this.spd2,
    required this.spd3,
    required this.spd4,
    required this.spd5,
  }) : super(key: key);

  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final String title5;
  final String spd1;
  final String spd2;
  final String spd3;
  final String spd4;
  final String spd5;

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
              'Spek Dasar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SPD 1
                SpekDetail(title: title1, spd: spd1),
                // SPD 4
                SpekDetail(
                  title: title4,
                  spd: spd4.isEmpty ? '-' : spd4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SPD 2
                SpekDetail(
                  title: title2,
                  spd: spd2.isEmpty ? '-' : spd2,
                ),
                // SPD 5
                SpekDetail(
                  title: title5,
                  spd: spd5.isEmpty ? '-' : spd5,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SPD 3
                SpekDetail(
                  title: title3,
                  spd: spd3.isEmpty ? '-' : spd3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
