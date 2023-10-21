import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/widget/button/big_button.dart';
import 'package:manajemen_aset/widget/input_form/date_input_form.dart';
import 'package:manajemen_aset/widget/input_form/image_form.dart';
import 'package:manajemen_aset/widget/input_form/text_input_form.dart';

import '../../widget/back_verif.dart';
import '../../widget/button/small_button.dart';
import 'aset_controller.dart';

class AddAset extends StatefulWidget {
  final String jppId;
  final String kodeJpp;
  final String pembangkitId;
  final String jenisAset;
  const AddAset({
    Key? key,
    required this.jppId,
    required this.kodeJpp,
    required this.pembangkitId,
    required this.jenisAset,
  }) : super(key: key);

  @override
  State<AddAset> createState() => _AddAsetState();
}

class _AddAsetState extends State<AddAset> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDataSaved = false;

  TextEditingController spd1C = TextEditingController();
  TextEditingController spd2C = TextEditingController();
  TextEditingController spd3C = TextEditingController();
  TextEditingController spd4C = TextEditingController();
  TextEditingController spd5C = TextEditingController();
  TextEditingController tglPasangC = TextEditingController();
  TextEditingController idC = TextEditingController();

  List allTextField = [];
  List displayTextField = [];
  DateTime? _dateTimeP;
  File? _pickedImage;
  File? _pickedImage2;

  void _showDatePickerP() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _dateTimeP = value!;
        tglPasangC.text = DateFormat('dd MMM yyyy').format(_dateTimeP!);
      });
    });
  }

  Future openCamera(bool? isPhoto1) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      if (isPhoto1 == true) {
        _pickedImage = img;
      } else {
        _pickedImage2 = img;
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
                title: 'Batalkan tambah aset?',
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
                      title: 'Batalkan tambah aset?',
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: SingleChildScrollView(
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
                        onPressed: allTextField.length ==
                                displayTextField.length
                            ? null
                            : () {
                                setState(() {
                                  displayTextField.add(
                                      allTextField[displayTextField.length]);
                                });
                              },
                      ),
                      const SizedBox(width: 8),
                      ButtonIconOutline(
                        title: 'Hapus',
                        icon: Icons.remove,
                        txtColor: displayTextField.isNotEmpty
                            ? const Color.fromRGBO(211, 47, 47, 1)
                            : Colors.grey[500],
                        borderColor: displayTextField.isNotEmpty
                            ? const Color.fromRGBO(211, 47, 47, 1)
                            : Colors.grey[500],
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
                  ImageForm(
                    pickedImage: _pickedImage,
                    title: 'Foto 1',
                    desc: "(aset barang terlihat keseluruhan)",
                    openCamera: () {
                      openCamera(true);
                    },
                    deleteImage: () {
                      setState(() {
                        _pickedImage = null;
                      });
                    },
                  ),

                  // foto 2
                  ImageForm(
                    pickedImage: _pickedImage2,
                    title: 'Foto 2',
                    desc: '(dimensi barang nampak dg alat ukur)',
                    openCamera: () {
                      openCamera(false);
                    },
                    deleteImage: () {
                      setState(() {
                        _pickedImage2 = null;
                      });
                    },
                  ),

                  //submit button
                  BigButtonIcon(
                    isLoading: _isLoading,
                    title: "Simpan",
                    icon: Icons.save,
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _pickedImage != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        await AsetController()
                            .addAset(
                              id: '0',
                              spd1: spd1C.text,
                              spd2: spd2C.text,
                              spd3: spd3C.text,
                              spd4: spd4C.text,
                              spd5: spd5C.text,
                              lokasi: "Onsite",
                              tglPasang: tglPasangC.text,
                              img1: _pickedImage,
                              img2: _pickedImage2,
                              idJpp: widget.jppId,
                              kodeJpp: widget.kodeJpp,
                              idPembangkit: widget.pembangkitId,
                              status: 'Belum Diverifikasi',
                              alarm: 'Aman',
                              jenisAset: widget.jenisAset,
                            )
                            .then((_) => setState(() {
                                  _isLoading = false;
                                  isDataSaved = true;
                                },
                              ),
                            );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } else if (_pickedImage == null ||
                          _pickedImage2 == null) {
                        Get.snackbar(
                          'Peringatan',
                          'Foto wajib diisi',
                          backgroundColor: Colors.red[400],
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text titleAppBar() {
    return Text(
      widget.jenisAset == 'mekanik'
          ? "SPD 1 (Mekanik)"
          : widget.jenisAset == 'elektrik'
              ? "SPD 2 (Elektrik)"
              : widget.jenisAset == 'kd'
                  ? "SPD 3 (Komunikasi Data)"
                  : widget.jenisAset == 'sensor'
                      ? "SPD 4 (Sensor)"
                      : widget.jenisAset == 'it'
                          ? "SPD 5 (IT)"
                          : "SPD 6 (Sipil)",
      overflow: TextOverflow.fade,
      style: const TextStyle(
        color: Colors.black87,
      ),
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
          readOnly: false,
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
      readOnly: false,
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
      readOnly: false,
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
          readOnly: false,
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
      readOnly: false,
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
          readOnly: false,
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
