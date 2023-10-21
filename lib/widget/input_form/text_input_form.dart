import 'package:flutter/material.dart';

class TextInputForm extends StatelessWidget {
  const TextInputForm({
    Key? key,
    this.maxLine,
    this.title,
    this.controller,
    this.inputType,
    this.prefixIcon,
    this.helperTxt,
    this.hintTxt,
    this.readOnly,
  }) : super(key: key);

  final int? maxLine;
  final String? title;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final Icon? prefixIcon;
  final String? helperTxt;
  final String? hintTxt;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLine,
          controller: controller,
          readOnly: readOnly!,
          decoration: InputDecoration(
            helperText: helperTxt,
            hintText: hintTxt,
            prefixIcon: prefixIcon,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Wajib Diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}

class OpsionalTextInputForm extends StatelessWidget {
  const OpsionalTextInputForm({
    Key? key,
    this.maxLine,
    this.title,
    this.controller,
    this.inputType,
    this.prefixIcon,
    this.helperTxt,
    this.hintTxt,
    this.readOnly,
  }) : super(key: key);

  final int? maxLine;
  final String? title;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final Icon? prefixIcon;
  final String? helperTxt;
  final String? hintTxt;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLine,
          controller: controller,
          readOnly: readOnly!,
          decoration: InputDecoration(
            helperText: helperTxt,
            hintText: hintTxt,
            prefixIcon: prefixIcon,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
