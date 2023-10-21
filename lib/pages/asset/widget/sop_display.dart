import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/widget/pdf_reader.dart';

class ManualOpText extends StatelessWidget {
  const ManualOpText({
    Key? key,
    required this.title,
    required this.fileName,
    required this.url,
  }) : super(key: key);

  final String title;
  final String fileName;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF797979)),
        ),
        GestureDetector(
          onTap: () {
            if (url.isEmpty || url == '-') {
              Get.snackbar('Peringatan', 'Tidak ada file $title');
            } else {
              // pdf view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfReader(title: title, pdfFile: url),
                ),
              );
            }
          },
          child: Row(
            children: [
              const Icon(Iconsax.document_text_1),
              const SizedBox(width: 8),
              Text(
                fileName.isEmpty || fileName == '-'
                    ? 'Tidak ada file SOP'
                    : fileName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: fileName.isEmpty || fileName == '-'
                      ? TextDecoration.none
                      : TextDecoration.underline,
                  color: fileName.isEmpty || fileName == '-'
                      ? Colors.grey
                      : const Color(0xFF129575),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
