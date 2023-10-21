import 'package:flutter/material.dart';
import 'package:manajemen_aset/models/api.dart';
import 'package:manajemen_aset/pages/jenisPeralatanPembangkit/builder_jpp.dart';
import 'package:manajemen_aset/pages/jenisPeralatanPembangkit/widgets/button_add_jpp.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:manajemen_aset/widget/chip_bar.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:easy_search_bar/easy_search_bar.dart';

class ListJpp extends StatefulWidget {
  final String docPembangkitId;
  final String namaPembangkit;
  final double latPembangkit;
  final double lngPembangkit;
  final String idPembangkit;
  final bool isAnon;

  const ListJpp({
    Key? key,
    required this.docPembangkitId,
    required this.latPembangkit,
    required this.lngPembangkit,
    required this.idPembangkit,
    required this.isAnon,
    required this.namaPembangkit,
  }) : super(key: key);

  @override
  State<ListJpp> createState() => _ListJppState();
}

class _ListJppState extends State<ListJpp> {
  String searchValue = '';
  ApiModel? apiModel;

  late String _docPembangkitId;
  late double _latPembangkit;
  late double _lngPembangkit;
  late String _idPembangkit;
  late String _namaPembangkit;

  var idSelected = 0;

  late final List<ItemChipBar> // list untuk choice chip
      _chipBarList = [
    ItemChipBar(
      0,
      'PLTB',
      'img/selectedPLTB.png',
      'img/unSelectedPLTB.png',
      BuilderJpp(
        stream: DatabaseService().listJppWT(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      1,
      'PLTS',
      'img/selectedPLTS.png',
      'img/unSelectedPLTS.png',
      BuilderJpp(
        stream: DatabaseService().listJppSP(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      2,
      'PLTD',
      'img/selectedPLTD.png',
      'img/unSelectedPLTD.png',
      BuilderJpp(
        stream: DatabaseService().listJppDS(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      3,
      'Baterai',
      'img/selectedBattery.png',
      'img/unSelectedBattery.png',
      BuilderJpp(
        stream: DatabaseService().listJppBT(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      4,
      'Weather Station',
      'img/selectedWS.png',
      'img/unSelectedWS.png',
      BuilderJpp(
        stream: DatabaseService().listJppWS(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      5,
      'Rumah Energi',
      'img/selectedRE.png',
      'img/unSelectedRE.png',
      BuilderJpp(
        stream: DatabaseService().listJppRE(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      6,
      'Warehouse',
      'img/selectedWH.png',
      'img/unSelectedWH.png',
      BuilderJpp(
        stream: DatabaseService().listJppWH(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
      // DropdownButton(items: items, onChanged: onChanged)
    ),
  ];

  late final List<ItemChipBar> // list untuk choice chip
      _chipBarListGuest = [
    ItemChipBar(
      0,
      'PLTB',
      'img/selectedPLTB.png',
      'img/unSelectedPLTB.png',
      BuilderJpp(
        stream: DatabaseService().listJppWT(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
    ItemChipBar(
      1,
      'Rumah Energi',
      'img/selectedRE.png',
      'img/unSelectedRE.png',
      BuilderJpp(
        stream: DatabaseService().listJppRE(_docPembangkitId),
        docPembangkitId: _docPembangkitId,
        latPembangkit: _latPembangkit,
        lngPembangkit: _lngPembangkit,
        idPembangkit: _idPembangkit,
        isAnon: widget.isAnon,
        namaPembangkit: _namaPembangkit,
      ),
    ),
  ];

  Widget currentTab() {
    if (widget.isAnon) {
      return _chipBarListGuest[idSelected].bodyWidget;
    } else {
      return _chipBarList[idSelected].bodyWidget;
    }
  }

  double distance = 0;

  // fungsi untuk mendapatkan distance antara lokasi Pembangkit dengan lokasi user
  _getDistance() async {
    final position = await geo.Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        distance = geo.Geolocator.distanceBetween(widget.latPembangkit,
            widget.lngPembangkit, position.latitude, position.longitude);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _docPembangkitId = widget.docPembangkitId;
    _latPembangkit = widget.latPembangkit;
    _lngPembangkit = widget.lngPembangkit;
    _idPembangkit = widget.idPembangkit;
    _namaPembangkit = widget.namaPembangkit;
    _getDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: const Text(
          'Peralatan Pembangkit',
          style: TextStyle(fontSize: 20),
        ),
        searchHintText: 'Cari...',
        onSearch: (value) => setState(() => searchValue = value),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
      floatingActionButton: buttonAdd(),
    );
  }

  buttonAdd() {
    if (widget.isAnon) {
      return const SizedBox();
    } else {
      return ButtonAddJpp(
        distance: distance,
        docPembangkitId: _docPembangkitId,
      );
    }
  }

  listChip() {
    if (widget.isAnon) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _chipBarListGuest
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 0),
                child: ChoiceChip(
                  avatar: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Image(
                      image: AssetImage(idSelected == item.id
                          ? item.selectedImg
                          : item.unSelectedImg),
                    ),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 29,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
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
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _chipBarList
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 0),
                child: ChoiceChip(
                  avatar: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Image(
                      image: AssetImage(idSelected == item.id
                          ? item.selectedImg
                          : item.unSelectedImg),
                    ),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 29,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
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
}
