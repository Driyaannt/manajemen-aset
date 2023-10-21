import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/history_asset/pelaporan/add_pelaporan.dart';
import 'package:manajemen_aset/widget/input_form/text_input_form.dart';

import '../../../models/user.dart';
import '../../../service/database.dart';
import '../../../widget/back_verif.dart';
import '../../asset/aset_controller.dart';
import '../widgets/dropdown_search_api.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDataSaved = false;

  // List _getWil = [];
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

  final jenisAsetList = [
    'Mekanik',
    'Elektrik',
    'Komunikasi Data',
    'Sensor',
    'Information Technology',
    'Sipil'
  ];
  String? selectedJenisAset = '';

  List<AsetData> _getAset = [];
  String? selectedSpd1 = '';
  String? selectedDocAset = '';

  Stream<QuerySnapshot>? stream;
  String? spd = '';
  String spd1 = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                title: 'Batalkan tambah pelaporan?',
                content: 'Data yang telah anda masukkan tidak akan disimpan',
              );
            },
          );
          // Kembalikan false agar halaman tidak ditutup secara otomatis
          return false;
        }
        // Kembalikan true jika data telah disimpan dan halaman dapat ditutup
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tambah Pelaporan",
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
                      title: 'Batalkan tambah pelaporan?',
                      content:
                          'Data yang telah anda masukkan tidak akan disimpan',
                    );
                  },
                );
              }
            },
            icon: const Icon(Iconsax.arrow_left_24),
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.userModel.tingkatan == 'Pusat')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              selectedJenisAset = '';

                              _getAset = [];
                              selectedSpd1 = '';
                              selectedDocAset = '';
                              spd1 = '';
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
                              Uri.parse(
                                  "http://ebt-polinema.site/api/wilayah/area"),
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
                              selectedJenisAset = '';
                              _getAset = [];
                              selectedSpd1 = '';
                              selectedDocAset = '';
                              spd1 = '';
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
                            var response = await http.post(Uri.parse(
                                "http://ebt-polinema.site/api/cluster/list"));
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
                              selectedPembangkitId =
                                  value['cluster_id'].toString();
                              _getJpp = [];
                              selectedKodeJpp = '';
                              selectedDocJpp = '';
                              selectedJenisAset = '';
                              _getAset = [];
                              selectedSpd1 = '';
                              selectedDocAset = '';
                              spd1 = '';
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
                              dropdownJenisAset(),
                              Text(selectedJenisAset!),
                              if (selectedWil != '' &&
                                  selectedArea != '' &&
                                  selectedPembangkit != '' &&
                                  selectedKodeJpp != '' &&
                                  selectedJenisAset != '')
                                dropdownAset(),
                            ],
                          ),

                        submitButton(context),
                      ],
                    ),
                  if (widget.userModel.tingkatan == 'Wilayah')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // wilayah
                        OpsionalTextInputForm(
                          title: 'Wilayah',
                          controller: TextEditingController(
                              text: widget.userModel.wilayah),
                          prefixIcon: const Icon(Iconsax.location),
                          readOnly: true,
                        ),

                        // area
                        DropDownSearchApi(
                          title: 'Area',
                          icon: Iconsax.location,
                          hintTxt: 'Pilih Area',
                          displayTxt: 'wilayah',
                          enabled: true,
                          selectedData: selectedArea!,
                          selectedDataId: selectedAreaId!,
                          onFind: (text) async {
                            var response = await http.post(
                              Uri.parse(
                                  "http://ebt-polinema.site/api/wilayah/area"),
                              body: {'id': widget.userModel.idWilayah},
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
                              selectedJenisAset = '';
                              _getAset = [];
                              selectedSpd1 = '';
                              selectedDocAset = '';
                              spd1 = '';
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
                            var response = await http.post(Uri.parse(
                                "http://ebt-polinema.site/api/cluster/list"));
                            if (response.statusCode == 200) {
                              _getPembangkit.clear();
                              final data = jsonDecode(response.body);
                              List<dynamic> dataJson = data['data'];

                              for (var item in dataJson) {
                                if (item['wilayah'] ==
                                        widget.userModel.wilayah &&
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
                              selectedPembangkitId =
                                  value['cluster_id'].toString();
                              _getJpp = [];
                              selectedKodeJpp = '';
                              selectedDocJpp = '';
                              selectedJenisAset = '';
                              _getAset = [];
                              selectedSpd1 = '';
                              selectedDocAset = '';
                              spd1 = '';
                            });
                          },
                        ),

                        // jpp
                        if (selectedArea != '' && selectedPembangkit != '')
                          dropdownJpp(),

                        //  aset
                        if (selectedArea != '' &&
                            selectedPembangkit != '' &&
                            selectedKodeJpp != '')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dropdownJenisAset(),
                              if (selectedKodeJpp != '' &&
                                  selectedJenisAset != '')
                                dropdownAset(),
                            ],
                          ),

                        submitButton(context),
                      ],
                    ),
                  if (widget.userModel.tingkatan == 'Area')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // wilayah
                        OpsionalTextInputForm(
                          title: 'Wilayah',
                          controller: TextEditingController(
                              text: widget.userModel.wilayah),
                          prefixIcon: const Icon(Iconsax.location),
                          readOnly: true,
                        ),

                        // area
                        OpsionalTextInputForm(
                          title: 'Area',
                          controller: TextEditingController(
                              text: widget.userModel.area),
                          prefixIcon: const Icon(Iconsax.location),
                          readOnly: true,
                        ),

                        // pembangkit
                        DropDownSearchApi(
                          title: 'Pembangkit',
                          icon: Iconsax.category,
                          hintTxt: 'Pilih Pembangkit',
                          displayTxt: 'cluster_name',
                          enabled: true,
                          selectedData: selectedPembangkit!,
                          selectedDataId: selectedPembangkitId!,
                          onFind: (text) async {
                            var response = await http.post(Uri.parse(
                                "http://ebt-polinema.site/api/cluster/list"));
                            if (response.statusCode == 200) {
                              _getPembangkit.clear();
                              final data = jsonDecode(response.body);
                              List<dynamic> dataJson = data['data'];

                              for (var item in dataJson) {
                                if (item['wilayah'] ==
                                        widget.userModel.wilayah &&
                                    item['area'] == widget.userModel.area) {
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
                              selectedPembangkitId =
                                  value['cluster_id'].toString();
                              _getJpp = [];
                              selectedKodeJpp = '';
                              selectedDocJpp = '';
                              selectedJenisAset = '';
                              _getAset = [];
                              selectedSpd1 = '';
                              selectedDocAset = '';
                              spd1 = '';
                            });
                          },
                        ),

                        // jpp
                        if (selectedPembangkit != '') dropdownJpp(),

                        //  aset
                        if (selectedPembangkit != '' && selectedKodeJpp != '')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dropdownJenisAset(),
                              if (selectedJenisAset != '') dropdownAset(),
                            ],
                          ),

                        submitButton(context),
                      ],
                    ),
                ],
              ),
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
                // onFind: (text) async {
                //   return _getJpp;
                // },
                // TODO: check for bug
                enabled: widget.userModel.tingkatan == 'Pusat'
                    ? selectedWil == ''
                        ? false
                        : true
                    : widget.userModel.tingkatan == 'Wilayah'
                        ? selectedArea == ''
                            ? false
                            : true
                        : selectedPembangkit == ''
                            ? false
                            : true,
                onChanged: (JppData? val) {
                  setState(() {
                    selectedDocJpp = val!.docIdJpp;
                    selectedKodeJpp = val.kodeJpp;

                    selectedJenisAset = '';
                    _getAset = [];
                    selectedSpd1 = '';
                    selectedDocAset = '';
                    spd1 = '';
                    stream = null;
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

  // dropdown jenis aset
  Column dropdownJenisAset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Jenis Aset',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField(
          items: jenisAsetList
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() {
              if (val == 'Mekanik') {
                selectedJenisAset = 'mekanik';
                stream = AsetController().listAset(
                    selectedPembangkitId, selectedDocJpp, selectedJenisAset);
                spd = 'spd11';
              } else if (val == 'Elektrik') {
                selectedJenisAset = 'elektrik';
                stream = AsetController().listAset(
                    selectedPembangkitId, selectedDocJpp, selectedJenisAset);
                spd = 'spd21';
              } else if (val == 'Komunikasi Data') {
                selectedJenisAset = 'kd';
                stream = AsetController().listAset(
                    selectedPembangkitId, selectedDocJpp, selectedJenisAset);
                spd = 'spd31';
              } else if (val == 'Sensor') {
                selectedJenisAset = 'sensor';
                stream = AsetController().listAset(
                    selectedPembangkitId, selectedDocJpp, selectedJenisAset);
                spd = 'spd41';
              } else if (val == 'Sipil') {
                selectedJenisAset = 'sipil';
                stream = AsetController().listAset(
                    selectedPembangkitId, selectedDocJpp, selectedJenisAset);
                spd = 'spd61';
              } else {
                selectedJenisAset = 'it';
                stream = AsetController().listAset(
                    selectedPembangkitId, selectedDocJpp, selectedJenisAset);
                spd = 'spd51';
              }
              _getAset = [];
              selectedSpd1 = '';
              selectedDocAset = '';
              spd1 = '';
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Iconsax.note),
            hintText: 'Pilih Jenis Aset',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: (value) {
            if (value == null) {
              return 'Pilih Jenis Aset';
            }
            return null;
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
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _getAset.clear();

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data!.docs[i];
                final String docAset = snapshot.data!.docs[i].id;
                spd1 =
                    snap.data().toString().contains(spd!) ? snap.get(spd!) : '';

                AsetData asetData = AsetData(docAset: docAset, spd1: spd1);
                _getAset.add(asetData);
              }

              // Render SearchableDropdown dengan items yang sudah didapatkan
              return DropdownSearch<AsetData>(
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
                // onFind: (text) async {
                //   return _getAset;
                // },
                // TODO: check for bug
                enabled: widget.userModel.tingkatan == 'Pusat'
                    ? selectedWil == ''
                        ? false
                        : true
                    : widget.userModel.tingkatan == 'Wilayah'
                        ? selectedArea == ''
                            ? false
                            : true
                        : selectedPembangkit == ''
                            ? false
                            : true,
                onChanged: (AsetData? val) {
                  setState(() {
                    selectedSpd1 = val!.spd1;
                    selectedDocAset = val.docAset;
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

  // submit button
  Container submitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedDocAset == null || selectedDocAset == ''
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPelaporan(
                        docJpp: selectedDocJpp!,
                        kodeJpp: selectedKodeJpp!,
                        spd1: selectedSpd1!,
                        docPembangkit: selectedPembangkitId!,
                        jenisAset: selectedJenisAset!,
                        docAset: selectedDocAset!,
                        currentUser: widget.userModel.nama,
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                        isDataSaved = true;
                      });
                    }
                  });
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

class AsetData {
  final String docAset;
  final String spd1;

  AsetData({
    required this.docAset,
    required this.spd1,
  });
}

class JppData {
  final String docIdJpp;
  final String kodeJpp;

  JppData({
    required this.docIdJpp,
    required this.kodeJpp,
  });
}
