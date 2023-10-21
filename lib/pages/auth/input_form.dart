import 'package:flutter/material.dart';

class AuthInputForm extends StatelessWidget {
  const AuthInputForm({
    Key? key,
    required this.controller,
    this.title,
    this.inputType,
    this.prefixIcon,
    this.hintTxt,
    this.validator,
  }) : super(key: key);

  final String? title;
  final TextEditingController controller;
  final TextInputType? inputType;
  final Icon? prefixIcon;
  final String? hintTxt;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hintTxt,
              prefixIcon: prefixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Color(0xFF129575), width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
