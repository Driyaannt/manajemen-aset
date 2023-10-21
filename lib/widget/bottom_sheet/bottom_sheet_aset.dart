import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomSheetAset extends StatelessWidget {
  const BottomSheetAset({
    Key? key,
    required this.edit,
    required this.delete,
  }) : super(key: key);

  final void Function() edit;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(18)),
              ),
            ),
            ListTile(
              leading: Icon(Iconsax.edit, color: Colors.amber[600]),
              title: Text(
                'Edit Aset',
                style: TextStyle(
                    color: Colors.amber[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              horizontalTitleGap: 4,
              onTap: edit,
            ),
            ListTile(
              leading: Icon(Iconsax.trash, color: Colors.red[600]),
              title: Text(
                'Hapus Aset',
                style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              horizontalTitleGap: 4,
              onTap: delete,
            ),
          ],
        ),
      ),
    );
  }
}
