import 'package:flutter/material.dart';
import 'package:manajemen_aset/widget/submit_button.dart';

import 'button/small_button.dart';

class BackVerification extends StatelessWidget {
  final String title;
  final String content;
  final String? buttonTitle;
  final String? buttonTitleCancel;
  const BackVerification({
    Key? key,
    required this.title,
    required this.content,
    this.buttonTitle,
    this.buttonTitleCancel,
  }) : super(key: key);

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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
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
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOutline(
                title: buttonTitleCancel ?? 'Tidak',
                txtColor: const Color(0xFF129575),
                borderColor: const Color(0xFF129575),
                bgColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 8),
              SubmitButton(
                title: buttonTitle ?? 'Ya, Batalkan',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
