import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FileInputForm extends StatelessWidget {
  final File? pickedFile;
  final String? pickedFileName;
  final String currentFile;
  final String? title;
  final Function()? uploadFile;
  final String? desc;

  const FileInputForm({
    Key? key,
    this.pickedFile,
    required this.currentFile,
    this.title,
    this.uploadFile,
    this.desc,
    this.pickedFileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(desc!),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: uploadFile,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.19,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: pickedFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.document_upload),
                            const SizedBox(height: 4),
                            Text(currentFile == '-' || currentFile == ''
                                ? 'Unggah File'
                                : currentFile)
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.document_upload),
                            const SizedBox(height: 4),
                            Text(pickedFileName!)
                          ],
                        )),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
