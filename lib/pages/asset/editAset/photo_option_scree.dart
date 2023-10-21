import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class SelectedPhotoOptionsScreen extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const SelectedPhotoOptionsScreen({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildDragHandle(),
        ListTile(
          onTap: () => onTap(ImageSource.gallery),
          leading: const Icon(Iconsax.image5),
          title: const Text('Browse Gallery'),
        ),
        ListTile(
          onTap: () => onTap(ImageSource.camera),
          leading: const Icon(Iconsax.camera5),
          title: const Text('Use a Camera'),
        ),
      ],
    );
  }

  buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
