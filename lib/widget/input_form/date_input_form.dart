import 'package:flutter/material.dart';

class DateInputForm extends StatelessWidget {
  const DateInputForm({
    Key? key,
    this.title,
    required this.controller,
    required this.readOnly,
    this.prefixIcon,
    this.showCalendar,
  }) : super(key: key);

  final String? title;
  final TextEditingController controller;
  final bool readOnly;
  final Icon? prefixIcon;
  final Function()? showCalendar;

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
          // enabled: true,
          // autofocus: true,
          readOnly: readOnly,
          controller: controller,
          decoration: InputDecoration(
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
            hintText: 'Pilih Tanggal',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Wajib Diisi';
            }
            return null;
          },
          onTap: showCalendar,
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}