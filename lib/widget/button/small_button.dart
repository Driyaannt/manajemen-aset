import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    required this.title,
    this.color,
    required this.onPressed,
  }) : super(key: key);
  final String title;
  final Color? color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), backgroundColor: color,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ButtonIconOutline extends StatelessWidget {
  const ButtonIconOutline({
    Key? key,
    required this.title,
    this.bgColor,
    this.txtColor,
    this.borderColor,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? bgColor;
  final Color? txtColor;
  final Color? borderColor;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        label: Text(
          title,
          style: TextStyle(color: txtColor ?? Colors.white),
        ),
        icon: Icon(icon, size: 15, color: txtColor),
        style: OutlinedButton.styleFrom(
          foregroundColor: bgColor ?? const Color(0xFF129575), fixedSize: const Size(double.infinity, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.transparent,
          side: BorderSide(width: 1.5, color: borderColor!),
        ),
      ),
    );
  }
}

class ButtonOutline extends StatelessWidget {
  const ButtonOutline({
    Key? key,
    required this.title,
    this.bgColor,
    this.txtColor,
    this.borderColor,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? bgColor;
  final Color? txtColor;
  final Color? borderColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF129575), fixedSize: const Size(double.infinity, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.transparent,
        side: BorderSide(width: 1.5, color: borderColor!),
      ),
      child: Text(
        title,
        style: TextStyle(color: txtColor ?? Colors.white),
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key? key,
    required this.title,
    this.bgColor,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? bgColor;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(
        title,
      ),
      icon: Icon(icon, size: 15),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.infinity, 10), backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
