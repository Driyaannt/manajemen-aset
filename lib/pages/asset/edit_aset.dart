import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/models/aset.dart';
import 'package:manajemen_aset/pages/asset/editAset/photo_option_scree.dart';
import 'package:manajemen_aset/widget/button/big_button.dart';
import 'package:manajemen_aset/widget/input_form/file_input_form.dart';

import '../../widget/back_verif.dart';
import '../../widget/button/small_button.dart';
import '../../widget/input_form/date_input_form.dart';
import '../../widget/input_form/image_form.dart';
import '../../widget/input_form/text_input_form.dart';
import 'aset_controller.dart';

class EditAset extends StatefulWidget {
  final Aset aset;
  final String jenisAset;

  const EditAset({
    Key? key,
    required this.aset,
    required this.jenisAset,
  }) : super(key: key);

  @override
  State<EditAset> createState() => _EditAsetState();
}

class _EditAsetState extends State<EditAset> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // SPD
  TextEditingController spd1C = TextEditingController();
  TextEditingController spd2C = TextEditingController();
  TextEditingController spd3C = TextEditingController();
  TextEditingController spd4C = TextEditingController();
  TextEditingController spd5C = TextEditingController();

  TextEditingController lokasiC = TextEditingController();
  TextEditingController tglPasangC = TextEditingController();
  TextEditingController status = TextEditingController();

  TextEditingController spu1C = TextEditingController();
  TextEditingController spu2C = TextEditingController();
  TextEditingController spu3C = TextEditingController();
  TextEditingController spu4C = TextEditingController();
  TextEditingController umurAsetC = TextEditingController();
  TextEditingController venPemasanganC = TextEditingController();
  TextEditingController venPengadaanC = TextEditingController();
  TextEditingController commisioningC = TextEditingController();
  TextEditingController garansiC = TextEditingController();

  DateTime? _dateTimeP;
  List allTextField = [];
  List displayTextField = [];
  File? _pickedImage1;
  File? _pickedImage2;
  File? _pickedFileSop;
  File? _pickedFileGaransi;
  bool isDataSaved = false;

  @override
  void initState() {
    spd1C = TextEditingController(text: widget.aset.spd1);
    spd2C = TextEditingController(text: widget.aset.spd2);
    spd3C = TextEditingController(text: widget.aset.spd3);
    spd4C = TextEditingController(text: widget.aset.spd4);
    spd5C = TextEditingController(text: widget.aset.spd5);

    lokasiC = TextEditingController(text: widget.aset.lokasi);
    tglPasangC = TextEditingController(text: widget.aset.tglPasang);
    status = TextEditingController(text: widget.aset.status);

    spu1C = TextEditingController(
        text: widget.aset.spu1 == '-' ? '' : widget.aset.spu1);
    spu2C = TextEditingController(
        text: widget.aset.spu2 == '-' ? '' : widget.aset.spu2);
    spu3C = TextEditingController(
        text: widget.aset.spu3 == '-' ? '' : widget.aset.spu3);
    spu4C = TextEditingController(
        text: widget.aset.spu4 == '-' ? '' : widget.aset.spu4);
    umurAsetC = TextEditingController(
        text: widget.aset.umurAset == '-' ? '' : widget.aset.umurAset);
    venPemasanganC = TextEditingController(
        text: widget.aset.vendorPemasangan == '-'
            ? ''
            : widget.aset.vendorPemasangan);
    venPengadaanC = TextEditingController(
        text: widget.aset.vendorPengadaan == '-'
            ? ''
            : widget.aset.vendorPengadaan);
    commisioningC = TextEditingController(
        text: widget.aset.commisioning == '-' ? '' : widget.aset.commisioning);
    garansiC = TextEditingController(
        text: widget.aset.garansi == '-' ? '' : widget.aset.garansi);

    if (widget.jenisAset == 'mekanik') {
      formMekanikOps();
    } else if (widget.jenisAset == 'elektrik') {
      formElektrikOps();
    } else if (widget.jenisAset == 'kd') {
      formKdOps();
    } else if (widget.jenisAset == 'sensor') {
      formSensorOps();
    } else if (widget.jenisAset == 'it') {
      formItOps();
    } else if (widget.jenisAset == 'sipil') {
      formSipilOps();
    }
    super.initState();
  }

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
                title: 'Batalkan edit aset?',
                content: 'Data yang telah anda ubah tidak akan disimpan',
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
          title: titleAppBar(),
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
                      title: 'Batalkan edit aset?',
                      content: 'Data yang telah anda ubah tidak akan disimpan',
                    );
                  },
                );
              }
            },
            icon: const Icon(Iconsax.arrow_left_24),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [editForm(context), submitButton(context)],
            ),
          ),
        ),
      ),
    );
  }

  Text titleAppBar() {
    return Text(
      widget.jenisAset == 'mekanik'
          ? "Edit SPD 1 (Mekanik)"
          : widget.jenisAset == 'elektrik'
              ? "Edit SPD 2 (Elektrik)"
              : widget.jenisAset == 'kd'
                  ? "Edit SPD 3 (Komunikasi Data)"
                  : widget.jenisAset == 'sensor'
                      ? "Edit SPD 4 (Sensor)"
                      : widget.jenisAset == 'it'
                          ? "Edit SPD 5 (IT)"
                          : "Edit SPD 6 (Sipil)",
      overflow: TextOverflow.fade,
      style: const TextStyle(
        color: Colors.black87,
      ),
    );
  }

  void _showDatePickerP() {
    showDatePicker(
      context: context,
      initialDate: DateFormat('dd MMM yyyy').parse(widget.aset.tglPasang),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _dateTimeP = value!;
        tglPasangC.text = DateFormat('dd MMM yyyy').format(_dateTimeP!);
      });
    });
  }

  Future _pickImage1(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 30);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _pickedImage1 = img;
        Navigator.of(context).pop();
      });
    } on PlatformException {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future _pickImage2(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 30);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _pickedImage2 = img;
        Navigator.of(context).pop();
      });
    } on PlatformException {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        child: SelectedPhotoOptionsScreen(
          onTap: _pickImage1,
        ),
      ),
    );
  }

  void _showSelectPhotoOptions2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        child: SelectedPhotoOptionsScreen(
          onTap: _pickImage2,
        ),
      ),
    );
  }

  void uploadFile() async {
    FilePickerResult? sopResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (sopResult != null) {
      File file = File(sopResult.files.single.path!);
      String fileName = sopResult.files.single.name;
      setState(() {
        _pickedFileSop = file;
        spu3C.text = fileName;
      });
    } else if (sopResult == null) {
      return;
    }
  }

  void uploadFile2() async {
    FilePickerResult? sopResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (sopResult != null) {
      File file = File(sopResult.files.single.path!);
      String fileName = sopResult.files.single.name;
      setState(() {
        _pickedFileGaransi = file;
        spu4C.text = fileName;
      });
    } else if (sopResult == null) {
      return;
    }
  }

  // form edit
  Widget editForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (widget.jenisAset == 'mekanik') mekanikForm(),
          if (widget.jenisAset == 'elektrik') elektrikForm(),
          if (widget.jenisAset == 'kd') kdForm(),
          if (widget.jenisAset == 'sensor') sensorForm(),
          if (widget.jenisAset == 'it') itForm(),
          if (widget.jenisAset == 'sipil') sipilForm(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SPD \nTambahan :',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.start,
              ),
              const SizedBox(width: 8),
              ButtonIcon(
                title: 'Tambah',
                icon: Icons.add,
                onPressed: allTextField.length == displayTextField.length
                    ? null
                    : () {
                        setState(() {
                          displayTextField
                              .add(allTextField[displayTextField.length]);
                        });
                      },
              ),
              const SizedBox(width: 8),
              ButtonIconOutline(
                title: 'Hapus',
                icon: Icons.remove,
                txtColor: const Color.fromRGBO(211, 47, 47, 1),
                borderColor: const Color.fromRGBO(211, 47, 47, 1),
                bgColor: Colors.transparent,
                onPressed: displayTextField.isNotEmpty
                    ? () {
                        setState(() {
                          displayTextField.removeLast();
                        });
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),

          ...displayTextField
              .map(
                (e) => Column(
                  children: [
                    e['text_field'],
                  ],
                ),
              )
              .toList(),

          // Tanggal dipasang
          DateInputForm(
            controller: tglPasangC,
            readOnly: false,
            title: 'Tanggal Dipasang',
            prefixIcon: const Icon(Iconsax.calendar_1),
            showCalendar: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showDatePickerP();
            },
          ),

          // foto 1
          EditImageForm(
            pickedImage: _pickedImage1,
            currentImage: widget.aset.img1,
            title: 'Foto 1',
            desc: "(aset barang terlihat keseluruhan)",
            openCamera: () {
              _showSelectPhotoOptions(context);
            },
            deleteImage: () {
              setState(() {
                _pickedImage1 = null;
              });
            },
          ),

          // foto 2
          EditImageForm(
            pickedImage: _pickedImage2,
            currentImage: widget.aset.img2,
            title: 'Foto 2',
            desc: '(dimensi barang nampak dg alat ukur)',
            openCamera: () {
              _showSelectPhotoOptions2(context);
            },
            deleteImage: () {
              setState(() {
                _pickedImage2 = null;
              });
            },
          ),

          // umur aset
          OpsionalTextInputForm(
            title: "Umur Aset",
            controller: umurAsetC,
            prefixIcon: const Icon(Iconsax.document_text),
            hintTxt: 'Umur Aset',
            readOnly: false,
          ),

          // vendor pengadaan
          OpsionalTextInputForm(
            title: "Vendor Pengadaan",
            controller: venPengadaanC,
            prefixIcon: const Icon(Iconsax.document_text),
            hintTxt: 'Vendor Pengadaan',
            readOnly: false,
          ),

          // vendor pemasangan
          OpsionalTextInputForm(
            title: "Vendor Pemasangan",
            controller: venPemasanganC,
            prefixIcon: const Icon(Iconsax.document_text),
            hintTxt: 'Vendor Pemasangan',
            readOnly: false,
          ),

          // commisioning
          OpsionalTextInputForm(
            title: "Comisioning",
            controller: commisioningC,
            prefixIcon: const Icon(Iconsax.document_text),
            hintTxt: 'Comisioning',
            readOnly: false,
          ),

          const Text(
            'Contact Person',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          // CP
          OpsionalTextInputForm(
            title: "Nama",
            controller: spu1C,
            prefixIcon: const Icon(Iconsax.document_text),
            hintTxt: 'Nama',
            readOnly: false,
          ),

          OpsionalTextInputForm(
            title: "No WA",
            controller: spu2C,
            prefixIcon: const Icon(Iconsax.document_text),
            hintTxt: 'No WA',
            readOnly: false,
          ),

          const Text(
            'Manual Operation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          // SOP
          FileInputForm(
            title: 'SOP',
            desc: 'Unggah file SOP, dalam bentuk pdf',
            pickedFile: _pickedFileSop,
            currentFile: widget.aset.spu3,
            pickedFileName: (spu3C.text),
            uploadFile: () {
              uploadFile();
            },
          ),

          // garansi
          FileInputForm(
            title: 'Garansi',
            desc: 'Unggah file Garansi, dalam bentuk pdf',
            pickedFile: _pickedFileGaransi,
            currentFile: widget.aset.spu4,
            pickedFileName: (spu4C.text),
            uploadFile: () {
              uploadFile2();
            },
          ),
        ],
      ),
    );
  }

  // submit button
  Widget submitButton(BuildContext context) {
    return BigButtonIcon(
      isLoading: _isLoading,
      title: "Simpan",
      icon: Icons.save,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });
          await AsetController()
              .editAset(
                id: widget.aset.id,
                spd1: spd1C.text,
                spd2: spd2C.text,
                spd3: spd3C.text,
                spd4: spd4C.text,
                spd5: spd5C.text,
                lokasi: lokasiC.text,
                tglPasang: tglPasangC.text,
                img1: _pickedImage1,
                img2: _pickedImage2,
                docAset: widget.aset.docAsetId,
                idJpp: widget.aset.docJpp,
                kodeJpp: widget.aset.kodeJpp,
                idPembangkit: widget.aset.docPembangkit,
                status: widget.aset.status,
                alarm: widget.aset.alarm,
                spu1: spu1C.text,
                spu2: spu2C.text,
                spu3: _pickedFileSop,
                sopFileName: spu3C.text,
                spu4: _pickedFileGaransi,
                garansiFileName: spu4C.text,
                umurAset: umurAsetC.text,
                vendorPemasangan: venPemasanganC.text,
                vendorPengadaan: venPengadaanC.text,
                commisioning: commisioningC.text,
                garansi: garansiC.text,
                jenisAset: widget.jenisAset,
              )
              .then((_) => setState(() {
                    _isLoading = false;
                    isDataSaved = true;
                  }));
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      },
    );
  }

// form spd wajib mekanik
  Column mekanikForm() {
    return Column(
      children: [
        // SPD 1.1
        TextInputForm(
          title: 'SPD 1.1',
          controller: spd1C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 1.1',
          readOnly: true,
        ),
        // SPD 1.2
        TextInputForm(
          title: "SPD 1.2",
          controller: spd2C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 1.2',
          readOnly: false,
        ),
        // SPD 1.3
        TextInputForm(
          title: "SPD 1.3",
          controller: spd3C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 1.3',
          readOnly: false,
        ),
      ],
    );
  }

  // form spd opsional mekanik
  List<dynamic> formMekanikOps() {
    return allTextField = [
      {
        "value": spd4C,
        "text_field": TextInputForm(
          title: "SPD 1.4",
          controller: spd4C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 1.4',
          readOnly: false,
        ),
      },
      {
        "value": spd5C,
        "text_field": TextInputForm(
          title: "SPD 1.5",
          controller: spd5C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 1.5',
          readOnly: false,
        ),
      },
    ];
  }

  // form spd wajib elektrik
  Widget elektrikForm() {
    return TextInputForm(
      title: 'SPD 2.1',
      controller: spd1C,
      prefixIcon: const Icon(Iconsax.document_text),
      hintTxt: 'SPD 2.1',
      readOnly: true,
    );
  }

  // form spd opsional elektrik
  List<dynamic> formElektrikOps() {
    return allTextField = [
      {
        "value": spd2C,
        "text_field": TextInputForm(
          title: "SPD 2.2",
          controller: spd2C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 2.2',
          readOnly: false,
        ),
      },
      {
        "value": spd3C,
        "text_field": TextInputForm(
          title: "SPD 2.3",
          controller: spd3C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 2.3',
          readOnly: false,
        ),
      },
      {
        "value": spd4C,
        "text_field": TextInputForm(
          title: "SPD 2.4",
          controller: spd4C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 2.4',
          readOnly: false,
        ),
      },
      {
        "value": spd5C,
        "text_field": TextInputForm(
          title: "SPD 2.5",
          controller: spd5C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 2.5',
          readOnly: false,
        ),
      },
    ];
  }

  // form spd wajib kd
  Widget kdForm() {
    return TextInputForm(
      title: 'SPD 3.1',
      controller: spd1C,
      prefixIcon: const Icon(Iconsax.document_text),
      hintTxt: 'SPD 3.1',
      readOnly: true,
    );
  }

  // form spd opsional kd
  List<dynamic> formKdOps() {
    return allTextField = [
      {
        "value": spd2C,
        "text_field": TextInputForm(
          title: "SPD 3.2",
          controller: spd2C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 3.2',
          readOnly: false,
        ),
      },
      {
        "value": spd3C,
        "text_field": TextInputForm(
          title: "SPD 3.3",
          controller: spd3C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 3.3',
          readOnly: false,
        ),
      },
      {
        "value": spd4C,
        "text_field": TextInputForm(
          title: "SPD 3.4",
          controller: spd4C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 3.4',
          readOnly: false,
        ),
      },
      {
        "value": spd5C,
        "text_field": TextInputForm(
          title: "SPD 3.5",
          controller: spd5C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 3.5',
          readOnly: false,
        ),
      },
    ];
  }

  // form spd wajib sensor
  Column sensorForm() {
    return Column(
      children: [
        // SPD 1
        TextInputForm(
          title: 'SPD 4.1',
          controller: spd1C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 4.1',
          readOnly: true,
        ),
        // SPD 2
        TextInputForm(
          title: 'SPD 4.2',
          controller: spd2C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 4.2',
          readOnly: false,
        ),
      ],
    );
  }

  // form spd opsional sensor
  List<dynamic> formSensorOps() {
    return allTextField = [
      {
        "value": spd3C,
        "text_field": TextInputForm(
          title: "SPD 4.3",
          controller: spd3C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 4.3',
          readOnly: false,
        ),
      },
      {
        "value": spd4C,
        "text_field": TextInputForm(
          title: "SPD 4.4",
          controller: spd4C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 4.4',
          readOnly: false,
        ),
      },
      {
        "value": spd5C,
        "text_field": TextInputForm(
          title: "SPD 4.5",
          controller: spd5C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 4.5',
          readOnly: false,
        ),
      },
    ];
  }

  // form spd wajib it
  Widget itForm() {
    return TextInputForm(
      title: 'SPD 5.1',
      controller: spd1C,
      prefixIcon: const Icon(Iconsax.document_text),
      hintTxt: 'SPD 5.1',
      readOnly: true,
    );
  }

  // form spd opsional it
  List<dynamic> formItOps() {
    return allTextField = [
      {
        "value": spd2C,
        "text_field": TextInputForm(
          title: "SPD 5.2",
          controller: spd2C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 5.2',
          readOnly: false,
        ),
      },
      {
        "value": spd3C,
        "text_field": TextInputForm(
          title: "SPD 5.3",
          controller: spd3C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 5.3',
          readOnly: false,
        ),
      },
      {
        "value": spd4C,
        "text_field": TextInputForm(
          title: "SPD 5.4",
          controller: spd4C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 5.4',
          readOnly: false,
        ),
      },
      {
        "value": spd5C,
        "text_field": TextInputForm(
          title: "SPD 5.5",
          controller: spd5C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 5.5',
          readOnly: false,
        ),
      },
    ];
  }

  // form spd wajib sipil
  Column sipilForm() {
    return Column(
      children: [
        // SPD 1
        TextInputForm(
          title: 'SPD 6.1',
          controller: spd1C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 6.1',
          readOnly: true,
        ),
        // SPD 2
        TextInputForm(
          title: 'SPD 6.2',
          controller: spd2C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 6.2',
          readOnly: false,
        ),
      ],
    );
  }

  // form spd opsional sipil
  List<dynamic> formSipilOps() {
    return allTextField = [
      {
        "value": spd3C,
        "text_field": TextInputForm(
          title: "SPD 6.3",
          controller: spd3C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 6.3',
          readOnly: false,
        ),
      },
      {
        "value": spd4C,
        "text_field": TextInputForm(
          title: "SPD 6.4",
          controller: spd4C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 6.4',
          readOnly: false,
        ),
      },
      {
        "value": spd5C,
        "text_field": TextInputForm(
          title: "SPD 6.5",
          controller: spd5C,
          prefixIcon: const Icon(Iconsax.document_text),
          hintTxt: 'SPD 6.5',
          readOnly: false,
        ),
      },
    ];
  }
}
