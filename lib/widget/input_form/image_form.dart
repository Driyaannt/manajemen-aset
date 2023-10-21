import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ImageForm extends StatelessWidget {
  const ImageForm({
    Key? key,
    required File? pickedImage,
    this.title,
    this.openCamera,
    this.deleteImage,
    this.desc,
  })  : _pickedImage = pickedImage,
        super(key: key);

  final File? _pickedImage;
  final String? title;
  final Function()? openCamera;
  final Function()? deleteImage;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(width: 8),
            Text(desc ?? ''),
            GestureDetector(
              onTap: openCamera,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _pickedImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.camera),
                              Text('Tambah Foto')
                            ],
                          )
                        : ClipRect(
                            child: Image(
                              image: FileImage(_pickedImage!),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                color: Colors.amber[600],
                icon: const Icon(Iconsax.edit),
                // Tindakan ketika tombol edit ditekan
                onPressed: openCamera,
              ),
              IconButton(
                color: Colors.red[600],
                icon: const Icon(Iconsax.trash),
                // Tindakan ketika tombol hapus ditekan
                onPressed: deleteImage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OptionalImageForm extends StatelessWidget {
  const OptionalImageForm({
    Key? key,
    required File? pickedImage,
    this.title,
    this.openCamera,
    this.deleteImage,
    this.desc,
  })  : _pickedImage = pickedImage,
        super(key: key);

  final File? _pickedImage;
  final String? title;
  final Function()? openCamera;
  final Function()? deleteImage;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(desc ?? ''),
            GestureDetector(
              onTap: openCamera,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _pickedImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.camera),
                              Text('Tambah Foto')
                            ],
                          )
                        : ClipRect(
                            child: Image(
                              image: FileImage(_pickedImage!),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                color: Colors.amber[600],
                icon: const Icon(Iconsax.edit),
                // Tindakan ketika tombol edit ditekan
                onPressed: openCamera,
              ),
              IconButton(
                color: Colors.red[600],
                icon: const Icon(Iconsax.trash),
                // Tindakan ketika tombol hapus ditekan
                onPressed: deleteImage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditImageForm extends StatelessWidget {
  final File? pickedImage;
  final String currentImage;
  final String? title;
  final Function()? openCamera;
  final Function()? deleteImage;
  final String? desc;

  const EditImageForm(
      {Key? key,
      this.pickedImage,
      required this.currentImage,
      this.title,
      this.openCamera,
      this.deleteImage,
      this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(width: 8),
            Text(desc ?? ''),
            GestureDetector(
              onTap: openCamera,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: pickedImage == null
                        ? ClipRect(
                            child: Image(
                              image: NetworkImage(currentImage),
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : ClipRect(
                            child: Image(
                              image: FileImage(pickedImage!),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                color: Colors.amber[600],
                icon: const Icon(Iconsax.edit),
                // Tindakan ketika tombol edit ditekan
                onPressed: openCamera,
              ),
              IconButton(
                color: Colors.red[600],
                icon: const Icon(Iconsax.trash),
                // Tindakan ketika tombol hapus ditekan
                onPressed: deleteImage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
