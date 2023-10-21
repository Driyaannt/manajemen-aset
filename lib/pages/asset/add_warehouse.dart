import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/asset/wh_controller.dart';

import '../../service/database.dart';
import '../../widget/back_verif.dart';
import '../../widget/input_form/text_input_form.dart';
import '../history_asset/pelaporan/lokasi_page.dart';
import '../history_asset/widgets/dropdown_search_api.dart';
import 'aset_controller.dart';

class AddWarehouse extends StatefulWidget {
  final String jppId;
  final String kodeJpp;
  final String pembangkitId;
  final String jenisAset;
  const AddWarehouse({
    Key? key,
    required this.jppId,
    required this.kodeJpp,
    required this.pembangkitId,
    required this.jenisAset,
  }) : super(key: key);

  @override
  State<AddWarehouse> createState() => _AddWarehouseState();
}

class _AddWarehouseState extends State<AddWarehouse> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDataSaved = false;

  String? selectedWil = '';
  String? selectedWilId = '';

  String? selectedArea = '';
  String? selectedAreaId = '';

  final List _getPembangkit = [];
  String? selectedPembangkit = '';
  String? selectedPembangkitId = '';

  List<JppData> _getJpp = [];
  String? selectedKodeJpp = '';
  String? selectedDocJpp = '';

  // String? selectedJenisAset = widget.jenisAset;

  List<AsetWH> _getAset = [];
  String? selectedSpd1 = '';
  String? selectedDocAset = '';

  String? spd = '';
  String? spd2 = '';
  String? spd3 = '';
  String? spd4 = '';
  String? spd5 = '';

  String spd1 = '';
  AsetWH? selectedAsetWH;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Warehouse',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () async {
            if (!isDataSaved) {
              // Tampilkan bottom sheet untuk mengonfirmasi keluar dari halaman edit data
              await showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return const BackVerification(
                    title: 'Batalkan tambah data warehouse?',
                    content:
                        'Data yang telah anda masukkan tidak akan disimpan',
                  );
                },
              );
            }
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // wilayah
                DropDownSearchApi(
                  title: 'Wilayah',
                  icon: Iconsax.location,
                  hintTxt: "Pilih Wilayah",
                  displayTxt: 'wilayah',
                  selectedData: selectedWil!,
                  selectedDataId: selectedWilId!,
                  onFind: (text) async {
                    var response = await http.post(Uri.parse(
                        "http://ebt-polinema.site/api/wilayah/provinsi"));
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      return data['data'];
                    }
                    return [];
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedWil = value['wilayah'];
                      selectedWilId = value['wilayah_id'];
                      selectedAreaId = '';
                      selectedArea = '';
                      selectedPembangkit = '';
                      selectedPembangkitId = '';
                      _getJpp = [];
                      selectedKodeJpp = '';
                      selectedDocJpp = '';

                      _getAset = [];
                      selectedSpd1 = '';
                      selectedDocAset = '';
                      spd1 = '';
                      selectedAsetWH = null;
                    });
                  },
                ),

                // area
                DropDownSearchApi(
                  title: 'Area',
                  icon: Iconsax.location,
                  hintTxt: "Pilih Area",
                  displayTxt: 'wilayah',
                  enabled: selectedWil == '' ? false : true,
                  selectedData: selectedArea!,
                  selectedDataId: selectedAreaId!,
                  onFind: (text) async {
                    var response = await http.post(
                      Uri.parse("http://ebt-polinema.site/api/wilayah/area"),
                      body: {'id': selectedWilId},
                    );
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      return data['data'];
                    }
                    return [];
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedArea = value['wilayah'];
                      selectedAreaId = value['wilayah_id'];
                      selectedPembangkit = '';
                      selectedPembangkitId = '';
                      _getJpp = [];
                      selectedKodeJpp = '';
                      selectedDocJpp = '';
                      _getAset = [];
                      selectedSpd1 = '';
                      selectedDocAset = '';
                      spd1 = '';
                      selectedAsetWH = null;
                    });
                  },
                ),

                // pembangkit
                DropDownSearchApi(
                  title: 'Pembangkit',
                  icon: Iconsax.category,
                  hintTxt: 'Pilih Pembangkit',
                  displayTxt: 'cluster_name',
                  enabled: selectedArea == '' ? false : true,
                  selectedData: selectedPembangkit!,
                  selectedDataId: selectedPembangkitId!,
                  onFind: (text) async {
                    var response = await http.post(
                        Uri.parse("http://ebt-polinema.site/api/cluster/list"));
                    if (response.statusCode == 200) {
                      _getPembangkit.clear();
                      final data = jsonDecode(response.body);
                      List<dynamic> dataJson = data['data'];

                      for (var item in dataJson) {
                        if (item['wilayah'] == selectedWil &&
                            item['area'] == selectedArea) {
                          _getPembangkit.add(item);
                        }
                      }
                      return _getPembangkit;
                    }
                    return [];
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedPembangkit = value['cluster_name'];
                      selectedPembangkitId = value['cluster_id'].toString();
                      _getJpp = [];
                      selectedKodeJpp = '';
                      selectedDocJpp = '';
                      _getAset = [];
                      selectedSpd1 = '';
                      selectedDocAset = '';
                      spd1 = '';
                      selectedAsetWH = null;
                    });
                  },
                ),

                // jpp
                if (selectedWil != '' &&
                    selectedArea != '' &&
                    selectedPembangkit != '')
                  dropdownJpp(),

                //  aset
                if (selectedWil != '' &&
                    selectedArea != '' &&
                    selectedPembangkit != '' &&
                    selectedKodeJpp != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OpsionalTextInputForm(
                        title: 'Jenis Aset',
                        controller:
                            TextEditingController(text: widget.jenisAset),
                        prefixIcon: const Icon(Iconsax.location),
                        readOnly: true,
                      ),
                      // Text(selectedJenisAset!),
                      if (selectedWil != '' &&
                          selectedArea != '' &&
                          selectedPembangkit != '' &&
                          selectedKodeJpp != '')
                        dropdownAset(),
                    ],
                  ),

                submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // dropdown jpp
  Column dropdownJpp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Jenis Peralatan Pembangkit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().listJPP(selectedPembangkitId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _getJpp.clear();
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data!.docs[i];
                final String docJpp = snapshot.data!.docs[i].id;
                String kodeJpp = snap['kode'];

                JppData dataJpp = JppData(docIdJpp: docJpp, kodeJpp: kodeJpp);
                _getJpp.add(dataJpp);
              }

              // Render SearchableDropdown dengan items yang sudah didapatkan
              return DropdownSearch<JppData>(
                // dropdownSearchDecoration: InputDecoration(
                //   hintText: "Pilih Jenis Peralatan Pembangkit",
                //   prefixIcon: const Icon(Iconsax.category),
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                // ),
                // mode: Mode.DIALOG,
                // showSearchBox: true,
                popupProps: const PopupProps.dialog(
                  showSearchBox: true,
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Pilih Jenis Peralatan Pembangkit",
                    prefixIcon: const Icon(Iconsax.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                // TODO: check for bug
                asyncItems: (text) async {
                  return _getJpp;
                },
                enabled: selectedPembangkit == '' ? false : true,
                onChanged: (JppData? val) {
                  setState(() {
                    selectedDocJpp = val!.docIdJpp;
                    selectedKodeJpp = val.kodeJpp;

                    _getAset = [];
                    selectedSpd1 = '';
                    selectedDocAset = '';
                    spd1 = '';
                    selectedAsetWH = null;
                    if (widget.jenisAset == 'mekanik') {
                      spd = 'spd11';
                      spd2 = 'spd12';
                      spd3 = 'spd13';
                      spd4 = 'spd14';
                      spd5 = 'spd15';
                    } else if (widget.jenisAset == 'elektrik') {
                      spd = 'spd21';
                      spd2 = 'spd22';
                      spd3 = 'spd23';
                      spd4 = 'spd24';
                      spd5 = 'spd25';
                    } else if (widget.jenisAset == 'kd') {
                      spd = 'spd31';
                      spd2 = 'spd32';
                      spd3 = 'spd33';
                      spd4 = 'spd34';
                      spd5 = 'spd35';
                    } else if (widget.jenisAset == 'sensor') {
                      spd = 'spd41';
                      spd2 = 'spd42';
                      spd3 = 'spd43';
                      spd4 = 'spd44';
                      spd5 = 'spd45';
                    } else if (widget.jenisAset == 'sipil') {
                      spd = 'spd61';
                      spd2 = 'spd62';
                      spd3 = 'spd63';
                      spd4 = 'spd64';
                      spd5 = 'spd65';
                    } else {
                      spd = 'spd51';
                      spd2 = 'spd52';
                      spd3 = 'spd53';
                      spd4 = 'spd54';
                      spd5 = 'spd55';
                    }
                  });
                },
                validator: (value) {
                  if (value!.docIdJpp == '') {
                    return 'Pilih Jenis Peralatan Pembangkit';
                  }
                  return null;
                },
                itemAsString: (item) => item.kodeJpp,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // dropdown aset
  Column dropdownAset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Aset',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: AsetController()
              .listAset(selectedPembangkitId, selectedDocJpp, widget.jenisAset),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _getAset.clear();

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data!.docs[i];
                final String docAset = snapshot.data!.docs[i].id;
                spd1 =
                    snap.data().toString().contains(spd!) ? snap.get(spd!) : '';
                String spd2Data = snap.data().toString().contains(spd2!)
                    ? snap.get(spd2!)
                    : '';
                String spd3Data = snap.data().toString().contains(spd3!)
                    ? snap.get(spd3!)
                    : '';
                String spd4Data = snap.data().toString().contains(spd4!)
                    ? snap.get(spd4!)
                    : '';
                String spd5Data = snap.data().toString().contains(spd5!)
                    ? snap.get(spd5!)
                    : '';
                String id = snap['id'] ?? "-";

                String lokasi = snap['lokasi'] ?? "-";
                String tglPasang = snap['tglPasang'] ?? "-";
                String img1 = snap['img1'] ?? "-";
                String img2 = snap['img2'] ?? "-";
                String alarm = snap['alarm'];
                String status = snap['status'];
                String spu1 = snap['spu1'] ?? "-";
                String spu2 = snap['spu2'] ?? "-";
                String spu3 = snap['spu3'] ?? "-";
                String sopFileName = snap['sopFileName'] ?? "-";
                String spu4 = snap['spu4'] ?? "-";
                String garansiFileName = snap['garansiFileName'] ?? "-";
                String umurAset = snap['umurAset'] ?? "-";
                String vendorPemasangan = snap['vendorPemasangan'] ?? "-";
                String vendorPengadaan = snap['vendorPengadaan'] ?? "-";
                String commisioning = snap['commisioning'] ?? "-";
                String garansi = snap['garansi'] ?? "-";

                AsetWH asetData = AsetWH(
                    id: id,
                    docAset: docAset,
                    spd1: spd1,
                    spd2: spd2Data,
                    spd3: spd3Data,
                    spd4: spd4Data,
                    spd5: spd5Data,
                    lokasi: lokasi,
                    tglPasang: tglPasang,
                    tglBerhentiOperasi: '',
                    urlImg1: img1,
                    urlImg2: img2,
                    status: status,
                    alarm: alarm,
                    spu1: spu1,
                    spu2: spu2,
                    spu3: spu3,
                    sopFileName: sopFileName,
                    spu4: spu4,
                    garansiFileName: garansiFileName,
                    umurAset: umurAset,
                    vendorPemasangan: vendorPemasangan,
                    vendorPengadaan: vendorPengadaan,
                    commisioning: commisioning,
                    garansi: garansi);
                _getAset.add(asetData);
              }

              // Render SearchableDropdown dengan items yang sudah didapatkan
              return DropdownSearch<AsetWH>(
                // dropdownSearchDecoration: InputDecoration(
                //   hintText: "Pilih Aset",
                //   prefixIcon: const Icon(Iconsax.category),
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                // ),
                // mode: Mode.DIALOG,
                // showSearchBox: true,
                popupProps: const PopupProps.dialog(
                  showSearchBox: true,
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Pilih Aset",
                    prefixIcon: const Icon(Iconsax.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                // TODO: check for bug
                asyncItems: (text) async {
                  return _getAset;
                },
                enabled: selectedPembangkit == '' ? false : true,
                onChanged: (AsetWH? val) {
                  setState(() {
                    selectedSpd1 = val!.spd1;
                    selectedDocAset = val.docAset;
                    selectedAsetWH = val;
                  });
                },
                validator: (value) {
                  if (value!.docAset == '') {
                    return 'Pilih Jenis Peralatan Pembangkit';
                  }
                  return null;
                },
                itemAsString: (item) => item.spd1,
              );
            } else if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Container submitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedDocAset == null || selectedDocAset == ''
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  await WHController()
                      .addWH(
                    asetWH: selectedAsetWH,
                    idPembangkit: widget.pembangkitId,
                    idJpp: widget.jppId,
                    selectedIdPembangkit: selectedPembangkitId,
                    selectedIdJPP: selectedDocJpp,
                    jenisAset: widget.jenisAset,
                  )
                      .then((_) {
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                        isDataSaved = true;
                      });
                    }
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Selanjutnya",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedDocAset == null || selectedDocAset == ''
                            ? Colors.black54
                            : Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Iconsax.arrow_right_3),
                  ],
                ),
              ),
      ),
    );
  }
}

class AsetWH {
  final String id;
  final String docAset;
  final String spd1;
  final String spd2;
  final String spd3;
  final String spd4;
  final String spd5;
  final String lokasi;
  final String tglPasang;
  final String tglBerhentiOperasi;
  final String urlImg1;
  final String urlImg2;
  final String status;
  final String alarm;
  final String spu1;
  final String spu2;
  final String spu3;
  final String sopFileName;
  final String spu4;
  final String garansiFileName;
  final String umurAset;
  final String vendorPemasangan;
  final String vendorPengadaan;
  final String commisioning;
  final String garansi;
  AsetWH({
    required this.id,
    required this.docAset,
    required this.spd1,
    required this.spd2,
    required this.spd3,
    required this.spd4,
    required this.spd5,
    required this.lokasi,
    required this.tglPasang,
    required this.tglBerhentiOperasi,
    required this.urlImg1,
    required this.urlImg2,
    required this.status,
    required this.alarm,
    required this.spu1,
    required this.spu2,
    required this.spu3,
    required this.sopFileName,
    required this.spu4,
    required this.garansiFileName,
    required this.umurAset,
    required this.vendorPemasangan,
    required this.vendorPengadaan,
    required this.commisioning,
    required this.garansi,
  });
}
