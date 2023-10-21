import 'package:flutter/material.dart';
import 'package:manajemen_aset/widget/submit_button.dart';

class FailedAddAset extends StatelessWidget {
  const FailedAddAset({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 45,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Jarak Terlalu Jauh",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(
            'img/denied.png',
            width: MediaQuery.of(context).size.width / 1.5,
          ),
          const Text(
            'Anda berada terlalu jauh dari lokasi Pembangkit, jarak maksimum untuk menambahkan data aset adalah 1 km dari lokasi aset.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SubmitButton(
                title: "OK",
                onPressed: () {
                  Navigator.pop(context);
                },
                bgColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
