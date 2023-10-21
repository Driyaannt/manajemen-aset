import 'package:flutter/material.dart';

import '../../../widget/button/small_button.dart';
import '../../../widget/submit_button.dart';

class BottomSheetHistory extends StatelessWidget {
  const BottomSheetHistory({
    Key? key,
    required this.ya,
    required this.tidak,
    required this.title,
  }) : super(key: key);

  final void Function() ya;
  final void Function() tidak;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(18)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Konfirmasi Tugas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 30,
                  color: Color.fromARGB(255, 128, 127, 127),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Image.asset(
            'img/question.png',
            height: 130,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOutline(
                title: 'Tidak',
                txtColor: const Color(0xFF129575),
                borderColor: const Color(0xFF129575),
                bgColor: Colors.transparent,
                onPressed: tidak,
              ),
              const SizedBox(width: 8),
              SubmitButton(
                title: "Ya",
                onPressed: ya,
              ),
            ],
          )
        ],
      ),
    );
  }
}
