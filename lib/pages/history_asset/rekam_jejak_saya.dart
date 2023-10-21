import 'package:flutter/material.dart';
import 'utils/get_data_dalam_proses.dart';
import 'utils/get_data_selesai.dart';
import 'utils/get_data_terjadwal.dart';

class RekamJejakSaya extends StatefulWidget {
  final ScrollController c;
  final VoidCallback onClosePanel;

  const RekamJejakSaya({
    Key? key,
    required this.c,
    required this.onClosePanel,
  }) : super(key: key);

  @override
  State<RekamJejakSaya> createState() => _RekamJejakSayaState();
}

class _RekamJejakSayaState extends State<RekamJejakSaya> {
  late ScrollController _controller;
  late VoidCallback _onClosePanel;

  @override
  void initState() {
    super.initState();
    _controller = widget.c;
    _onClosePanel = widget.onClosePanel;
  }

  var idSelected = 0;
  late final chipBarList = <ItemChipBar>[
    ItemChipBar(0, 'Dalam Proses', RiwayatDalamProses(controller: _controller)),
    ItemChipBar(1, 'Terjadwal', RiwayatTerjadwal(controller: _controller)),
    ItemChipBar(2, 'Selesai', RiwayatSelesai(controller: _controller))
  ];
  Widget currentTab() {
    return chipBarList[idSelected].bodyWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rekam Jejak Saya',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                    onPressed: _onClosePanel, icon: const Icon(Icons.close))
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: listChip(),
          ),
        ),
        Expanded(
          child: Center(child: currentTab()),
        ),
      ],
    );
  }

  Row listChip() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chipBarList
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ChoiceChip(
                label: Text(item.title),
                selected: idSelected == item.id,
                labelStyle: TextStyle(
                  color: idSelected == item.id ? Colors.white : Colors.black,
                ),
                selectedColor: const Color(0xFF129575),
                onSelected: (_) => setState(() => idSelected = item.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ItemChipBar {
  final int id;
  final String title;
  final Widget bodyWidget;

  ItemChipBar(this.id, this.title, this.bodyWidget);
}
