import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/history_asset/utils/get_data_pelaporan.dart';
import 'package:manajemen_aset/pages/history_asset/widgets/buttton_add_history.dart';
import 'utils/get_data_dalam_proses.dart';
import 'utils/get_data_selesai.dart';
import 'utils/get_data_terjadwal.dart';

class HistoryPage extends StatefulWidget {
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  const HistoryPage(
      {Key? key,
      required this.docJpp,
      required this.kodeJpp,
      required this.spd1,
      required this.docPembangkit,
      required this.jenisAset,
      required this.docAset})
      : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var idSelected = 0;
  late final chipBarList = <ItemChipBar>[
    ItemChipBar(
      0,
      'Dalam Proses',
      GetDataDalamProses(
        docJpp: widget.docJpp,
        kodeJpp: widget.kodeJpp,
        spd1: widget.spd1,
        docPembangkit: widget.docPembangkit,
        jenisAset: widget.jenisAset,
        docAset: widget.docAset,
      ),
    ),
    ItemChipBar(
      1,
      'Terjadwal',
      GetDataTerjadwal(
        docJpp: widget.docJpp,
        kodeJpp: widget.kodeJpp,
        spd1: widget.spd1,
        docPembangkit: widget.docPembangkit,
        jenisAset: widget.jenisAset,
        docAset: widget.docAset,
      ),
    ),
    ItemChipBar(
      2,
      'Selesai',
      GetDataSelesai(
        docJpp: widget.docJpp,
        kodeJpp: widget.kodeJpp,
        spd1: widget.spd1,
        docPembangkit: widget.docPembangkit,
        jenisAset: widget.jenisAset,
        docAset: widget.docAset,
      ),
    ),
    ItemChipBar(
      3,
      'Darurat',
      GetDataPelaporan(
        docJpp: widget.docJpp,
        kodeJpp: widget.kodeJpp,
        spd1: widget.spd1,
        docPembangkit: widget.docPembangkit,
        jenisAset: widget.jenisAset,
        docAset: widget.docAset,
      ),
    ),
  ];
  Widget currentTab() {
    return chipBarList[idSelected].bodyWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // choice chip
              SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: listChip(),
                ),
              ),
              // content
              Center(
                child: currentTab(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buttonAdd(),
    );
  }

  buttonAdd() {
    return ButtonAddHistory(
      docJpp: widget.docJpp,
      kodeJpp: widget.kodeJpp,
      spd1: widget.spd1,
      docPembangkit: widget.docPembangkit,
      jenisAset: widget.jenisAset,
      docAset: widget.docAset,
    );
  }

  Row listChip() {
    return Row(
      children: chipBarList
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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

class TidakAdaData extends StatelessWidget {
  const TidakAdaData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('img/no_data.png')),
          Text(
            'Tidak Ada Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class ShowText extends StatelessWidget {
  const ShowText({
    Key? key,
    required this.title,
    required this.prefixIcon,
    this.content,
  }) : super(key: key);

  final String title;
  final IconData prefixIcon;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF797979),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Icon(
              prefixIcon,
              size: 18,
              color: const Color(0xFF129575),
            ),
            const SizedBox(width: 4),
            Text(
              content!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF129575),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class ItemChipBar {
  final int id;
  final String title;
  final Widget bodyWidget;

  ItemChipBar(this.id, this.title, this.bodyWidget);
}
