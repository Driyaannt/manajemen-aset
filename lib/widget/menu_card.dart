import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MenuCard extends StatelessWidget {
  final IconData? leadingIcon;
  final String titleText;
  final void Function()? nextPage;
  const MenuCard({
    Key? key,
    this.leadingIcon,
    required this.titleText,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: Icon(
              leadingIcon,
              color: Colors.black,
            ),
            title: Text(
              titleText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Iconsax.arrow_right_3,
              color: Colors.black,
            ),
            onTap: nextPage,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
