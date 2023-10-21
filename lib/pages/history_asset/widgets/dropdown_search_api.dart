import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownSearchApi extends StatefulWidget {
  final String title;
  final IconData icon;
  final String hintTxt;
  final String displayTxt;
  final String selectedData;
  final String selectedDataId;
  final Function onFind;
  final Function onChanged;
  final bool? enabled;

  const DropDownSearchApi({
    Key? key,
    required this.title,
    required this.icon,
    required this.hintTxt,
    required this.displayTxt,
    required this.selectedData,
    required this.selectedDataId,
    required this.onFind,
    required this.onChanged,
    this.enabled,
  }) : super(key: key);

  @override
  State<DropDownSearchApi> createState() => _DropDownSearchApiState();
}

class _DropDownSearchApiState extends State<DropDownSearchApi> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownSearch<dynamic>(
          // dropdownSearchDecoration: InputDecoration(
          //   hintText: widget.hintTxt,
          //   prefixIcon: Icon(widget.icon),
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          // ),
          // mode: Mode.DIALOG,
          // showSearchBox: true,
          // enabled: widget.enabled ?? true,
          // onFind: (text) async {
          //   return await widget.onFind(text);
          // },
          enabled: widget.enabled ?? true,
          popupProps: const PopupProps.dialog(
            showSearchBox: true,
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: widget.hintTxt,
            prefixIcon: Icon(widget.icon),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          // TODO: check for bug
          onChanged: (value) {
            setState(() {
              widget.onChanged(value);
            });
          },
          validator: (value) {
            if (value == '') {
              return 'Pilih ${widget.title}';
            }
            return null;
          },
          itemAsString: (item) => item[widget.displayTxt],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
