import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final Color? bgColor;
  const SubmitButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), backgroundColor: bgColor,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
