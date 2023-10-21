import 'package:flutter/material.dart';

class SpekDetail extends StatelessWidget {
  const SpekDetail({
    Key? key,
    required this.title,
    required this.spd,
  }) : super(key: key);

  final String title;
  final String spd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF797979)),
          ),
          Text(
            spd,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF129575)),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}